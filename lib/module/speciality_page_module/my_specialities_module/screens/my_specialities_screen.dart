import 'package:Coretext/module/speciality_page_module/my_specialities_module/model/my_interest_data_model.dart';
import 'package:Coretext/module/speciality_page_module/my_specialities_module/view_model/my_specialities_view_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/app_bar_widget/categories.dart';
import 'package:Coretext/utils/app_bar_widget/categories2.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySpecialityScreen extends StatefulWidget {
  const MySpecialityScreen({super.key});

  @override
  _MySpecialityScreenState createState() => _MySpecialityScreenState();
}

class _MySpecialityScreenState extends State<MySpecialityScreen> {
  final MySpecialitiesViewModel mySpecialitiesViewModel =
      Get.put(MySpecialitiesViewModel());
  DateTime? _lastBackPressTime;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await mySpecialitiesViewModel.getSpecialityList();
      await mySpecialitiesViewModel.getMySpecialityCatSelected();
      hideLoadingDialog();
    });

    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    // Screen responsiveness
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop:  () async {
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 1)) {
          // If the last back press time is null or more than 1 second has passed
          _lastBackPressTime = now; // Update last back press time
          // Show a message to indicate double tap to exit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Double tap to exit the app'),
              duration: Duration(seconds: 2),
            ),
          );
          return false; // Do not pop the route
        }
        return true; // Exit the app
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -10) {
              CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value--;
              Get.to(const SpecialityScreen());
            }
          },
        child: SafeArea(
          child: Scaffold(
            appBar:
            PreferredSize(
                  preferredSize: const Size.fromHeight(
                      40.0), // Adjusted height to accommodate the extra container
                  child: Stack(
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: const Color(0xffeb602f).withOpacity(
                            0.85),
                        elevation: 5,
                        centerTitle: true,
                        title: const IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "My Speciality",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      5.0), // Space between text and underline
                              
                            ],
                          ),
                        ),
                        // 
                      ),
                      // Positioned(
                      //   bottom: 0, // Position it at the bottom of the AppBar
                      //   left: 0,
                      //   right: 0,
                      //   child: Container(
                      //     height: 13.0, // Height of the new container
                      //     color: primaryColor, // Change to your desired color
                      //   ),
                      // ),
                    ],
                  ),
                ),
            //     PreferredSize(
            //       preferredSize: const Size.fromHeight(40.0), // Taller for a modern look
            //       child:
            //     AppBar(
            //   automaticallyImplyLeading: false,
            //   backgroundColor:
            //       Colors.white, // Clean white background for a fresh look
            //   elevation: 5, // Slight shadow to add depth
            //   centerTitle: true, // Center the title for balance
            //   title: const Column(
            //     children: [
            //       Text(
            //         "My Specialities",
            //         style: TextStyle(
            //           fontSize: 20.0, // Bigger text for a bold, modern look
            //           fontWeight: FontWeight.w500, // Bold text for emphasis
            //           color: Colors.white, // Strong color for contrast
            //           letterSpacing: 1.0, // More spacing for an elegant touch
            //         ),
            //       ),
            //       SizedBox(height: 5.0), // Spacing between title and subtitle
            //     ],
            //   ),
            //   flexibleSpace: Container(
            //     decoration: const BoxDecoration(
            //       color: Color(0xffeb602f)
            //       // gradient: LinearGradient(
            //       //   colors: [
            //       //     Colors.white,
            //       //     Colors.grey.shade200
            //       //   ], // Subtle gradient for visual appeal
            //       //   begin: Alignment.topCenter,
            //       //   end: Alignment.bottomCenter,
            //       // ),
            //     ),
            //   ),
            // ),
            // ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section in a white container (Categories, My Interest, Poll, Bookmarks)
                // const Categories(
                //   initialIndex: 1,
                // ),
                const CustomAppBar(),
                // Interest GridView
                Expanded(
                  child: Obx(() {
                    final mySpeciality = mySpecialitiesViewModel
                        .mySpecialityDataModel.value?.responseBody;
                    final selectedSpeciality = mySpecialitiesViewModel
                        .mySpecialitySelectedDataModel.value?.responseBody;
          
                    if (mySpeciality == null) {
                      return const Center(child: Text(""));
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, right: 10, left: 10),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  screenWidth > 600 ? 4 : 3, // Responsive grid
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: mySpecialitiesViewModel.interests.length,
                            itemBuilder: (context, index) {
                              final interest =
                                  mySpecialitiesViewModel.interests[index];
                              final mySpecial = mySpeciality[index];
          
                              // Check if the current item is preselected
                              bool isPreselected = selectedSpeciality?.any(
                                    (selected) =>
                                        selected?.catName == mySpecial?.catName,
                                  ) ??
                                  false;
          
                              // Combine preselected and current selection state
                              bool isSelected = isPreselected || interest.isSelected;
          
                              return _buildInterestItem(
                                mySpecial?.catName ?? '',
                                isSelected, // Preselect and toggle
                                () => mySpecialitiesViewModel.toggleSelection(
                                    interest, mySpecial!),
                                mySpecial?.imgUrl ?? '',
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }),
                )
          
                // Expanded(
                //   child: Obx(() {
                //     final mySpeciality = mySpecialitiesViewModel
                //         .mySpecialityDataModel.value?.responseBody;
                //     final selectedSpeciality = mySpecialitiesViewModel
                //         .mySpecialitySelectedDataModel.value?.responseBody;
          
                //     if (mySpeciality == null) {
                //       return const Center(child: Text("No articles found!"));
                //     } else {
                //       return Container(
                //         color: Colors.white,
                //         child: Padding(
                //           padding:
                //               const EdgeInsets.only(top: 20.0, right: 10, left: 10),
                //           child: GridView.builder(
                //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //               crossAxisCount:
                //                   screenWidth > 600 ? 4 : 3, // Responsive grid
                //               crossAxisSpacing: 10,
                //               mainAxisSpacing: 5,
                //             ),
                //             itemCount: mySpecialitiesViewModel.interests.length,
                //             itemBuilder: (context, index) {
                //               final interest =
                //                   mySpecialitiesViewModel.interests[index];
                //               final mySpecial = mySpeciality[index];
          
                //               // Check if the current item is in the selectedSpeciality list (preselected)
                //               bool isPreselected = selectedSpeciality?.any(
                //                     (selected) =>
                //                         selected?.catName == mySpecial?.catName,
                //                   ) ??
                //                   false;
          
                //               // Combine preselected and current selection state
                //               bool isSelected = isPreselected ||
                //                   interest.isSelected; // Combined logic
          
                //               return _buildInterestItem(
                //                 mySpecial?.catName ?? '',
                //                 isSelected, // Preselect and toggle
                //                 () => mySpecialitiesViewModel.toggleSelection(
                //                     interest, mySpecial!),
                //                 mySpecial?.imgUrl ?? '',
                //               );
                //             },
                //           ),
                //           // GridView.builder(
                //           //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           //     crossAxisCount:
                //           //         screenWidth > 600 ? 4 : 3, // Responsive grid
                //           //     crossAxisSpacing: 10,
                //           //     mainAxisSpacing: 20,
                //           //   ),
                //           //   itemCount: mySpecialitiesViewModel.interests.length,
                //           //   itemBuilder: (context, index) {
                //           //     final interest =
                //           //         mySpecialitiesViewModel.interests[index];
                //           //     final mySpecial = mySpeciality[index];
          
                //           //     // Check if the current item is in the selectedSpeciality list
                //           //     // Combine preselected and current selection state
                //           //     bool isPreselected = selectedSpeciality?.any(
                //           //           (selected) =>
                //           //               selected?.catName == mySpecial?.catName,
                //           //         ) ??
                //           //         false;
          
                //           //     bool isSelected = isPreselected ||
                //           //         interest.isSelected; // Combined logic
          
                //           //     return _buildInterestItem(
                //           //       mySpecial?.catName ?? '',
                //           //       isSelected, // Preselect and toggle
                //           //       () =>
                //           //           mySpecialitiesViewModel.toggleSelection(index),
                //           //       mySpecial?.imgUrl ?? '',
                //           //     );
                //           //   },
                //           // ),
                //         ),
                //       );
                //     }
                //   }),
                // ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          ),
        ),
      ),
    );
  }

  // Method to build each interest item in the grid
  Widget _buildInterestItem(
      String title, bool isSelected, VoidCallback onTap, String imgUrl) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height > 800
                      ? 65
                      : MediaQuery.of(context).size.height > 700
                          ? 65
                          : MediaQuery.of(context).size.height > 650
                              ? 60
                              : MediaQuery.of(context).size.height > 500
                                  ? 60
                                  : MediaQuery.of(context).size.height > 400
                                      ? 50
                                      : 50,
                  width: 80,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 235, 235),
                    border: Border.all(
                        color: isSelected
                            ? const Color(0xffeb602f)
                            : const Color.fromARGB(255, 235, 235, 235),
                        width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.network(APIConfig.categoryPath + imgUrl),
                    // Icon(
                    //   Icons.interests,
                    //   color: isSelected
                    //       ? const Color.fromARGB(255, 219, 114, 21)
                    //       : primaryColor,
                    //   size: 40,
                    // ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 4,
                  child: Visibility(
                    visible: isSelected,
                    child: const CircleAvatar(
                      backgroundColor: Color(0xffeb602f),
                      radius: 12,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xffeb602f) : Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height > 800
                      ? 13
                      : MediaQuery.of(context).size.height > 700
                          ? 12
                          : MediaQuery.of(context).size.height > 650
                              ? 11
                              : MediaQuery.of(context).size.height > 500
                                  ? 11
                                  : MediaQuery.of(context).size.height > 400
                                      ? 10
                                      : 11,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
