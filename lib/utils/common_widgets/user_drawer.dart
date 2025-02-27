import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // showLoadingDialog();
      await userDataViewModel.getUsersDetails();
      //  hideLoadingDialog();
    });
  }

  UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width *
          0.65, // Decreased width to 75% of the screen width
      child: ClipRRect(
        child: Drawer(
          backgroundColor: bodyBGColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  curve: Curves.bounceIn,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                  child: Obx(
                    () {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDataViewModel.userListDataModel.value
                                    ?.responseBody?.first?.firstName ??
                                "",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          spaceWidget(height: 30.0),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              spaceWidget(width: 10.0),
                              ConstantText(
                                text: userDataViewModel.userListDataModel.value
                                        ?.responseBody?.first?.email ??
                                    '',
                                fontSize: 14.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ],
                          ),
                          spaceWidget(height: 10.0),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_android_rounded,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              spaceWidget(width: 10.0),
                              ConstantText(
                                text: userDataViewModel.userListDataModel.value
                                        ?.responseBody?.first?.mobile ??
                                    '',
                                fontSize: 14.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )),
              spaceWidget(height: 30.0),
              ListTile(
                leading: const Icon(Icons.home),
                title: const ConstantText(text: 'Home'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => HomeScreen(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const ConstantText(text: 'Category'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => CategoryScreen2()),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.score),
                title: const ConstantText(text: 'Score History'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //       builder: (context) => ScoreHistoryScreen()),
                  // );

                  // Handle profile navigation
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const ConstantText(text: 'My Cart'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions),
                title: const ConstantText(text: 'Subscriptions'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         //  BottomNavigationBarWidget(
                  //         //   bodyWidget:
                  //         SubscriptionScreen(),
                  //   ),
                  //   // ),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment_rounded),
                title: const ConstantText(text: 'Payment History'),
                onTap: () {
                  //Get.off(const PaymentHistoryScreen());
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         //  BottomNavigationBarWidget(
                  //         //   bodyWidget:
                  //         PaymentHistoryScreen(),
                  //   ),
                  //   // ),
                  // );
                  // Handle navigation to Payment screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection_rounded),
                title: const ConstantText(text: 'Info & Video'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => InfoVideoScreen(),
                  //   ),
                  // );
                  // Handle navigation to Info & Video screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
