import 'package:Coretext/module/speciality_page_module/poll_module/screen/poll_question.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/view_model/poll_view_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/app_bar_widget/categories.dart';
import 'package:Coretext/utils/app_bar_widget/categories2.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/common_widgets/arrows.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  PollViewModel pollViewModel = Get.put(PollViewModel());

  int _currentIndex = 0;
  DateTime? _lastBackPressTime;
  final int _doublePressDelay = 1000; // 1 second for double tap
  // Initialize PageController with default index
  PageController _pageController = PageController(initialPage: 0); 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await pollViewModel.getPollList();
      hideLoadingDialog();
    });

    checkConnectivity();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose PageController when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return WillPopScope(
    onWillPop: () async {
      final now = DateTime.now();

      if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 1)) {
        // Update the last back press time
        _lastBackPressTime = now;
        // Show a message to indicate double tap to exit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Double tap to exit the app'),
            duration: Duration(seconds: 1),
          ),
        );
        return false; // Do not exit the app, but allow single-tap back navigation
      }

      // If double-tap detected within 1 second, allow exiting the app
      return true;
    },
    child: GestureDetector(
       onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -10) {
              CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value--;
              Get.back();
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
                        backgroundColor:  const Color(0xffeb602f).withOpacity(
                              0.85),
                        elevation: 5,
                        centerTitle: true,
                        title: const IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Poll",
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
          
          body: SingleChildScrollView(
         child: Column(
          children: [
            const CustomAppBar(),
            Obx(() {
              final polls = pollViewModel.pollDataModel.value?.responseBody
                      ?.where((poll) => poll?.itemType == "poll")
                      .toList() ??
                  [];
        
              // Check if polls list is empty or doesn't contain any "poll" items
              if (polls.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("", style: TextStyle(fontSize: 18)),
                  ),
                );
              }
        
              return Column(
                children: [
                  Stack(
                    children: [
                      // PageView for Polls
                      SizedBox(
                        height: screenWidth,
                        width: screenWidth,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: polls.length,
                          onPageChanged: (index) {
                            _currentIndex = index; // Since Obx, no need to call setState
                          },
                          itemBuilder: (context, index) {
                            final poll = polls[index];
                    
                            // Only render polls with the correct item type
                            if (poll?.itemType != "poll") return const SizedBox.shrink();
                    
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => PollScreen1(pollid: poll!.id!));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      color: Colors.white,
                                      height: screenWidth * 0.5,
                                      width: screenWidth * 0.8,
                                      child: poll?.imgUrl?.isEmpty ?? true
                                          ? Image.asset("assets/images/Core Text Logo (1).png")
                                          : Image.network(
                                              APIConfig.pollPath + (poll?.imgUrl ?? ""),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        poll?.title ?? "",
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Left Arrow Button
                      ArrowButton(
                        isLeft: true,
                        onTap: () {
                          if (_currentIndex > 0) {
                            _pageController.animateToPage(
                              _currentIndex - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      // Right Arrow Button
                      ArrowButton(
                        isLeft: false,
                        onTap: () {
                          if (_currentIndex < polls.length - 1) {
                            _pageController.animateToPage(
                              _currentIndex + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
        ),
          bottomNavigationBar: const CustomBottomNavBar(),
        ),
      ),
    ),
  );
}

}
