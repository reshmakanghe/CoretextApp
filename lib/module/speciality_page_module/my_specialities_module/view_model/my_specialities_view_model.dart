import 'package:Coretext/module/auth_module/signup/model/signup_data_model.dart';
import 'package:Coretext/module/speciality_page_module/my_specialities_module/model/my_interest_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a model class for Interest
class Interest {
  int id;
  String name;
  bool isSelected;

  Interest({required this.id, required this.name, this.isSelected = false});
}

class MySpecialitiesViewModel extends GetxController {
  MySpecialityDataModel mySelectedSpeciality = Get.put(MySpecialityDataModel());

  Rx<APIBaseModel<List<MySpecialityDataModel?>?>?> mySpecialityDataModel =
      RxNullable<APIBaseModel<List<MySpecialityDataModel?>?>?>().setNull();

  Rx<APIBaseModel<List<MySpecialityDataModel?>?>?> mySpecialityCatId =
      RxNullable<APIBaseModel<List<MySpecialityDataModel?>?>?>().setNull();

  Rx<APIBaseModel<List<MySpecialityDataModel?>?>?>
      mySpecialitySelectedDataModel =
      RxNullable<APIBaseModel<List<MySpecialityDataModel?>?>?>().setNull();

  // List of interests with their selection status
  var interests = <Interest>[].obs;

  @override
  void onInit() {
    super.onInit();
    getSpecialityList();
  }
Future<void> loadStoredSelections() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> selectedIds = prefs.getStringList('selected_interests') ?? [];

  // Add any interests in `responseBody` to `selectedIds` if they're not already there
  final preselectedIds = mySpecialitySelectedDataModel.value?.responseBody
          ?.map((special) => special?.catId.toString())
          .whereType<String>() // Ensures non-null strings only
          .toList() ??
      [];

  for (var id in preselectedIds) {
    if (!selectedIds.contains(id)) {
      selectedIds.add(id);
    }
  }

  // Save the updated selected IDs list to SharedPreferences
  await prefs.setStringList('selected_interests', selectedIds);

  // Update `interests` selection state based on `selectedIds`
  for (var interest in interests) {
    interest.isSelected = selectedIds.contains(interest.id.toString());
  }
  
  interests.refresh();
}

void toggleSelection(
    Interest interest, MySpecialityDataModel mySpecial) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> selectedIds = prefs.getStringList('selected_interests') ?? [];

  // Toggle the interest selection state
  interest.isSelected = !interest.isSelected;

  // Check if the current specialty is preselected in `responseBody`
  bool isPreselected = mySpecialitySelectedDataModel.value?.responseBody?.any(
        (selected) => selected?.catName == mySpecial.catName,
      ) ??
      false;

  if (isPreselected && !interest.isSelected) {
    // If preselected and being unchecked, remove from `selectedSpeciality`
    mySpecialitySelectedDataModel.value?.responseBody?.removeWhere(
      (selected) => selected?.catName == mySpecial.catName,
    );
    selectedIds.remove(interest.id.toString());
  } else if (interest.isSelected) {
    // If newly selected, add to `selectedSpeciality`
    mySpecialitySelectedDataModel.value?.responseBody?.add(mySpecial);
    selectedIds.add(interest.id.toString());
  } else {
    selectedIds.remove(interest.id.toString());
  }

  // Convert the selected IDs to integers and call the posting method
  List<int?> allSelectedIds = selectedIds
      .map((id) => int.tryParse(id))
      .where((id) => id != null)
      .toList();

  mySpecialtyCategoryId(allSelectedIds);

  // Update SharedPreferences with the new selections
  await prefs.setStringList('selected_interests', selectedIds);

  // Refresh the UI state
  interests.refresh();
  mySpecialitySelectedDataModel.refresh();
}


  // Fetch specialties list from the server
  Future<APIBaseModel<List<MySpecialityDataModel?>?>?>
      getSpecialityList() async {
    mySpecialityDataModel.value = await APIService
        .getDataFromServerWithoutErrorModel<List<MySpecialityDataModel?>?>(
      endPoint: specialtyList,
      create: (dynamic json) {
        try {
          return (json as List)
              .map((e) => MySpecialityDataModel.fromJson(e))
              .toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    ); // Assuming that your MySpecialtyDataModel has 'catId' and 'catName'
    var specialties = mySpecialityDataModel.value?.responseBody ?? [];
    // Update the interests list based on API data
    interests.value = specialties.map((speciality) {
      return Interest(
        id: speciality?.catId ?? 0, // Defaulting to 0 if null
        name:
            speciality?.catName ?? 'Unknown', // Defaulting to 'Unknown' if null
      );
    }).toList();
    await loadStoredSelections();
    return mySpecialityDataModel.value;
  }

  // Change the mySpecialtyCategoryId method to accept the selected IDs
  Future<APIBaseModel<List<MySpecialityDataModel?>?>?>? mySpecialtyCategoryId(
      List<int?>? allSelectedIds) async {
    // Create the body to send in the request
    var body = {
      'user_id':
          "${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? ""}",
      'cat_id': allSelectedIds?.isNotEmpty == true ? allSelectedIds : [],
    };

    print('Request Body: $body');
    mySpecialityCatId.value =
        await APIService.postDataToServer<List<MySpecialityDataModel?>?>(
            endPoint: mapCategory,
            body: body,
            create: (dynamic json) {
              return (json as List)
                  .map((item) => MySpecialityDataModel.fromJson(item))
                  .toList();
            });

    return mySpecialityCatId.value;
  }

  // Send selected specialties to the server
  // Future<APIBaseModel<List<MySpecialityDataModel?>?>?>?
  //     mySpecialtyCategoryId() async {
  //   List<int> selectedCatIds = getSelectedCatIds();

  //   // Create the body to send in the request
  //   var body = {
  //     'user_id':
  //         "${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? ""}",
  //     'cat_id': selectedCatIds,
  //   };

  //   print('Request Body: $body');

  //   mySpecialityCatId.value =
  //       await APIService.postDataToServer<List<MySpecialityDataModel?>?>(
  //           endPoint: mapCategory,
  //           body: body,
  //           create: (dynamic json) {
  //             return (json as List)
  //                 .map((item) => MySpecialityDataModel.fromJson(item))
  //                 .toList();
  //           });

  //   return mySpecialityCatId.value;
  // }

  // Get selected cat IDs
  List<int> getSelectedCatIds() {
    return interests
        .where((interest) => interest.isSelected)
        .map((interest) => interest.id)
        .toList();
  }

  // Fetch the selected specialties by ID
  Future<APIBaseModel<List<MySpecialityDataModel?>?>?>
      getMySpecialityCatSelected() async {
    mySpecialitySelectedDataModel.value = await APIService
        .getDataFromServerWithoutErrorModel<List<MySpecialityDataModel?>?>(
      endPoint: mySpecialtyCatById,
      create: (dynamic json) {
        try {
          return (json as List)
              .map((e) => MySpecialityDataModel.fromJson(e))
              .toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    return mySpecialitySelectedDataModel.value;
  }
}
