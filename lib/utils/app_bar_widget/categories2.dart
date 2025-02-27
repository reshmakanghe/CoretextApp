import 'package:Coretext/module/speciality_page_module/bookmark_module/screen/bookmark_screen.dart';
import 'package:Coretext/module/speciality_page_module/my_specialities_module/screens/my_specialities_screen.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/screen/poll_screen.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      final selectedIndex = CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value;

      return Container(
        decoration: const BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomNavigationItem(
                    index: 0,
                    label: 'Speciality',
                    selectedImagePath:
                    'assets/images/LIST.png', // Image for selected state
                    unselectedImagePath: 'assets/images/LIST2.png',
                    selectedIndex: selectedIndex,
                    id: 'speciality_button',
                  ),
                  CustomNavigationItem(
                    index: 1,
                    label: 'My Speciality',
                    selectedImagePath:
                    'assets/images/REVIEW.png', // Image for selected state
                    unselectedImagePath: 'assets/images/REVIEW 2.png',
                    selectedIndex: selectedIndex,
                    id: 'my_speciality_button',
                  ),
                  CustomNavigationItem(
                    index: 2,
                    label: 'Poll',
                    selectedImagePath:
                    'assets/images/ANALYTICS.png', // Image for selected state
                    unselectedImagePath: 'assets/images/ANALYTICS 2.png',
                    selectedIndex: selectedIndex,
                    id: 'poll_button',
                  ),
                  CustomNavigationItem(
                    index: 3,
                    label: 'Bookmark',
                    selectedImagePath:
                    'assets/images/BOOKMARK 2.png', // Image for selected state
                    unselectedImagePath: 'assets/images/bookmark_5126251-.png',
                    selectedIndex: selectedIndex,
                    id: 'bookmark_button',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
  class CustomNavigationItem extends StatelessWidget {
  final int index;
  final String label;
  final String selectedImagePath;
  final String unselectedImagePath;
  final int selectedIndex;
  final String id;

  const CustomNavigationItem({
    super.key,
    required this.index,
    required this.label,
    required this.selectedImagePath,
    required this.unselectedImagePath, // Both images are required
    required this.selectedIndex,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value = index;
        _handleNavigation(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circle container with icon
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 235, 235),
              border: Border.all(
                color: isSelected
                    ? const Color(0xffeb602f)
                    : primaryColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                isSelected
                    ? selectedImagePath
                    : unselectedImagePath, 
                fit: BoxFit.contain,
                // color: isSelected ? null : Colors.grey, // Unselected icon color
              ),
            ),
          ),
          // Title below the circle container
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xffeb602f)
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height > 800
                  ? 14
                  : MediaQuery.of(context).size.height > 700
                      ? 12
                      : MediaQuery.of(context).size.height > 650
                          ? 10
                          : MediaQuery.of(context).size.height > 500
                              ? 10
                              : MediaQuery.of(context).size.height > 400
                                  ? 8
                                  : 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  void _handleNavigation(int index) {
    // Update the selected index when tapping on a navigation item
  CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value = index;
    switch (index) {
      case 0:
        Get.off( const SpecialityScreen());
        break;
      case 1:
        Get.off(const MySpecialityScreen());
        break;
      case 2:
        Get.off(const PollScreen());
        break;
      case 3:
        Get.off(BookmarksScreen());
      default:
        Get.toNamed('/speciality');
    }
  }
}