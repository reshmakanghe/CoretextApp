import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/module/user_profile/screen/profile.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      
      final selectedIndex = CoreTextAppGlobal.instance.bottomNavigationBarSelectedIndex.value;
      
      double height = MediaQuery.of(context).size.width > 600 ? 60 : 55;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildBottomNavigationItem(
                  index: 0,
                  label: 'Categories',
                  imagePath: 'assets/images/Vector (3).png',
                  selectedIndex: selectedIndex,
                  id: 'categories_button',
                  context: context,

                ),
                _buildBottomNavigationItem(
                  index: 1,
                  label: 'Home',
                  imagePath: 'assets/images/Vector (2).png',
                  selectedIndex: selectedIndex,
                  id: 'home_button',
                  context: context,

                ),
                _buildBottomNavigationItem(
                  index: 2,
                  label: 'Profile',
                  imagePath: 'assets/images/Group.png',
                  selectedIndex: selectedIndex,
                  id: 'profile_button',
                  context: context,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomNavigationItem({
    required int index,
    required String label,
    required String imagePath,
    required int selectedIndex,
    required String id,
    required BuildContext context,
  }) {
    bool isSelected = selectedIndex == index;

    return Tooltip(
      message: label,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: IconButton(
          key: Key(id),
          icon: Image.asset(
            imagePath,
            // width: 60,
            // height: 60,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          onPressed: () {
            CoreTextAppGlobal.instance.bottomNavigationBarSelectedIndex.value = index;
            CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value = 0;
            _handleNavigation(index,context);
          },
        ),
      ),
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        Get.off(const SpecialityScreen());
        break;
      case 1:
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ArticleScreen(articleHeading: 'Recent Articles'),),
      );
        break;
      case 2:
        Get.off(const UserProfile());
        break;
      default:
        Get.toNamed('/home');
    }
  }
}


