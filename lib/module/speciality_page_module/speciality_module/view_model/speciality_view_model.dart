import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_data_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/model/speciality_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Interest {
  String name;

  Interest({required this.name});
}

class SpecialityViewModel extends GetxController {
  Rx<APIBaseModel<List<SpecialityDataModel?>?>?> specialityDataModel =
      RxNullable<APIBaseModel<List<SpecialityDataModel?>?>?>().setNull();
  // List of interests
  var interests = <Interest>[
    Interest(name: 'General Practice'),
    Interest(name: 'Gynecology'),
    Interest(name: 'Pediatrics'),
    Interest(name: 'Orthopedics'),
    Interest(name: 'Respiratory'),
    Interest(name: 'General Surgery'),
    Interest(name: 'Diabetes'),
    Interest(name: 'Cardiology'),
    Interest(name: 'Opthalmology'),
  ].obs;

  RxList<SpecialityDataModel> specialties = <SpecialityDataModel>[].obs;

  Future<APIBaseModel<List<SpecialityDataModel?>?>?> getSpecialityList() async {
    specialityDataModel.value = await APIService
        .getDataFromServerWithoutErrorModel<List<SpecialityDataModel?>?>(
      endPoint: specialtyList,
      create: (dynamic json) {
        try {
          return (json as List)
              .map((e) => SpecialityDataModel.fromJson(e))
              .toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    return specialityDataModel.value;
  }

  Future<void> fetchSpecialties() async {
    try {
      var response = await getSpecialityList();
      if (response != null && response.responseBody != null) {
        // Update the specialties list with SpecialityDataModel objects
        specialties.value = response.responseBody!
            .map((speciality) => speciality!) // Ensure speciality is not null
            .toList();

        // Optionally, select the first specialty by default
        // if (specialties.isNotEmpty) {
        //   selectedSpecialty.value = specialties.first;
        // }
      }
    } catch (e) {
      debugPrint('Error fetching specialties: $e');
    }
  }
  // Future<void> fetchSpecialties() async {
  //   try {
  //     var response = await getSpecialityList();
  //     if (response != null && response.responseBody != null) {
  //       // Extract cat_name values and update specialties list
  //       specialties.value = response.responseBody!
  //           .map((speciality) => speciality?.catName ?? '')
  //           .toList();

  //       // Optionally, select the first specialty by default
  //       // if (specialties.isNotEmpty) {
  //       //   selectedSpecialty.value = specialties.first;
  //       // }
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching specialties: $e');
  //   }
  // }
}
