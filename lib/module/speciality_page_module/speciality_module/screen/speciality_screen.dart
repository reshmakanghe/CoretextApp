import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/view_model/speciality_view_model.dart';
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

class SpecialityScreen extends StatefulWidget {
  const SpecialityScreen({super.key});

  @override
  _SpecialityScreenState createState() => _SpecialityScreenState();
}

class _SpecialityScreenState extends State<SpecialityScreen> {
  final SpecialityViewModel myInterestViewModel =
      Get.put(SpecialityViewModel());
  DateTime? _lastBackPressTime;
  // final int _doublePressDelay = 1000; // 1 second for double tap
  List<bool> isTappedList = []; // Track tap state for each item
  @override
  void initState() {
    super.initState();

    // Prevent screenshots on this screen
    // _disableScreenshots();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await myInterestViewModel.getSpecialityList();
      hideLoadingDialog();
      isTappedList = List.filled(
          myInterestViewModel.specialityDataModel.value?.responseBody?.length ??
              0,
          false);
    });

    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    // Screen responsiveness
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
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
            CoreTextAppGlobal.instance.bottomNavigationBarSelectedIndex.value =
                1; // Update index for ArticleScreen
            Get.to(() => ArticleScreen(
                  articleHeading: 'Recent Articles',
                ));
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
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
                            "Speciality",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(
                              height: 5.0), // Space between text and underline
                        ],
                      ),
                    ),
                   
                  ),
                  
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section in a white container (Categories, My Interest, Poll, Bookmarks)
                const CustomAppBar(),
          
                // Interest GridView
                Expanded(
                  child: Obx(() {
                    final speciality = myInterestViewModel
                        .specialityDataModel.value?.responseBody;
                    if (speciality == null) {
                      return const Center(child: Text(""));
                    } else {
                      // Initialize isTappedList once the data is available
                      if (isTappedList.isEmpty) {
                        isTappedList = List.filled(speciality.length, false);
                      }
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, right: 10, left: 10),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  screenWidth > 600 ? 4 : 3, // Responsive grid
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: speciality.length,
                            itemBuilder: (context, index) {
                              // final interest = myInterestViewModel.interests[index];
                              final special = speciality[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTappedList[index] = !isTappedList[
                                        index]; // Toggle the tap state for each item
                                  });
                                  Get.to(() => ArticleScreen(
                                        catId: special!.catId!,
                                        articleHeading: special.catName ?? "",
                                      ));
                                },
                                child: _buildInterestItem(
                                  special?.catName ??
                                      "", // Access the name property
                                  special?.imgUrl ?? "",
                                  isTappedList[
                                      index], // Pass the tap state for each item
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          ),
        ),
      ),
    );
  }

  // Method to build each interest item in the grid
  Widget _buildInterestItem(String title, String imgUrl, bool isTapped) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
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
                    color: isTapped
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 235, 235),
                    border: Border.all(
                        color: isTapped
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
                // Positioned(
                //   top: 0,
                //   right: 4,
                //   child: Visibility(
                //     visible: isTapped,
                //     child: const CircleAvatar(
                //       backgroundColor: Color(0xffeb602f),
                //       radius: 12,
                //       child: Icon(
                //         Icons.check,
                //         color: Colors.white,
                //         size: 20,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isTapped ? const Color(0xffeb602f) : Colors.black,
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
