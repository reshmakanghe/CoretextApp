import 'package:Coretext/module/article_module/model/article_data_model.dart';
import 'package:Coretext/module/article_module/screen/article_details_screen.dart';
import 'package:Coretext/module/article_module/screen/webview_screen.dart';
import 'package:Coretext/module/article_module/view_model/article_analytics_view_model.dart';
import 'package:Coretext/module/article_module/view_model/article_view_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_anaylicts_data_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/view_model/poll_view_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class PollScreen1 extends StatefulWidget {
  final int pollid;

  const PollScreen1({super.key, required this.pollid});

  @override
  State<PollScreen1> createState() => _PollScreen1State();
}

class _PollScreen1State extends State<PollScreen1> {
  PollViewModel pollViewModel = Get.put(PollViewModel());
  final ArticleViewModel articleViewModel = Get.put(ArticleViewModel());
  ArticleAnalyticsViewModel articleAnalyticsViewModel =
      Get.put(ArticleAnalyticsViewModel());
  // Option selection state
  int? _selectedOption;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // showLoadingDialog();
      await pollViewModel.getPollByIdList(widget.pollid);
      // hideLoadingDialog();
      var firstArticle = _getCurrentArticle(0);
      if (firstArticle != null) {
        articleViewModel.startViewTimer(0, firstArticle);
      } else {
        print("No article found for the 0th index.");
      }
    });

    checkConnectivity();
  }

  ArticleDataModel? _getCurrentArticle(int index) {
    // Try to get the article from any of the available lists (articleListDataModel, articleByCategory, articleByMyCatId)
    return pollViewModel.pollByIdDataModel.value?.responseBody?[index];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
      child: InternetAwareWidget(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -10) {
              CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value--;
              Get.back();
            }
            ;
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
                      backgroundColor:
                          const Color(0xffeb602f).withOpacity(0.85),
                      elevation: 5,
                      centerTitle: true,
                      title: const IntrinsicWidth(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Polls",
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
              body: Obx(() {
                var articleList =
                    pollViewModel.pollByIdDataModel.value?.responseBody;
                if (articleList == null || articleList.isEmpty
                    // articleViewModel
                    //       .articleListDataModel.value?.responseBody?.isEmpty ??
                    //   articleViewModel
                    //       .articleByCategory.value?.responseBody?.isEmpty ??
                    //   articleViewModel
                    //       .articleByMyCatId.value?.responseBody?.isEmpty ??
                    //   true
                    ) {
                  // Show loader for 15 seconds, then show "No articles found!" text
                  return FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 15)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show the loader while waiting
                        return Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white,
                            size: 35,
                          ), // Use your loader widget here
                        );
                      } else {
                        // After 15 seconds, show the "No articles found!" message
                        return const Center(
                          child: Text("No articles found!"),
                        );
                      }
                    },
                  );
                } else {
                  return Swiper(
                    itemCount: articleList.length,

                    scrollDirection: Axis.vertical,
                    // Triggered when the user changes the article
                    onIndexChanged: (index) {
                      var article = _getCurrentArticle(index);
                      articleViewModel.startViewTimer(index,
                          article); // Start or reset the timer on index change
                    },
                    itemBuilder: (context, index) {
                      var article = articleList[index];

                      String trimmedDescription =
                          (article?.description?.length ?? 0) > 200
                              ? '${article?.description!.substring(0, 200)}...'
                              : article?.description ?? "";
                      return Stack(
                        children: [
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (details.delta.dx < -10) {
                                article?.itemType != "poll"
                                    ? article?.externalUrl == ""
                                        ? Get.to(() => ArticleDetailsScreen(
                                              articleTitle:
                                                  article?.title ?? "",
                                              articleId: article?.id ?? 0,
                                            ))
                                        : Get.to(() => WebViewScreen(
                                            url: article?.externalUrl ?? ""))
                                    : Container();
                              } else if (details.delta.dx > 10) {
                                CoreTextAppGlobal.instance
                                    .bottomNavigationBarSelectedIndex.value = 0;
                                Get.to(() => const SpecialityScreen());
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Image Section
                                      SizedBox(
                                        width: double.infinity,
                                        height: article?.itemType == "poll"
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25
                                            : article?.itemType == "ad"
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.59
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                        child:
                                            // const Image(
                                            //   image: AssetImage("assets/test.png"),
                                            //   fit: BoxFit.cover,
                                            // ),

                                            ///TODO: after backend asset changes done it will uncomment
                                            Image.network(
                                          // Check if the image URL ends with .png, then show dummy image
                                          // article?.imgUrl != null
                                          //     // &&
                                          //     //         article!.imgUrl!
                                          //     //             .endsWith(".png")
                                          //     ? "assets/images/Core Text Logo (1).png" // Fallback image for .png URLs
                                          //     :
                                          article?.itemType == "poll"
                                              ? APIConfig.pollPath +
                                                  (article?.imgUrl ??
                                                      "assets/test.jpeg")
                                              : article?.itemType == "ad"
                                                  ? APIConfig.adPath +
                                                      (article?.imgUrl ??
                                                          "assets/test.jpeg")
                                                  : APIConfig.imagePath +
                                                      (article?.imgUrl ??
                                                          "assets/test.jpeg"), // Use the image URL if not .png
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // If the image fails to load, display a fallback image
                                            return Image.asset(
                                              "assets/images/Core Text Logo (1).png",
                                              fit: BoxFit.fill,
                                            );
                                          },
                                        ),
                                        //     Image.network(
                                        //   //  "test.png",
                                        //   APIConfig.imagePath +
                                        //       (article?.imgUrl ??
                                        //           "assets/test.jpeg"),
                                        //   fit: BoxFit.fill,
                                        // ),
                                      ),
                                      // Sponsored Tag
                                      ((article?.type == "sponsored") ||
                                              (article?.type == "Sponsored") ||
                                              (article?.type == "Sponsered") ||
                                              (article?.type == "sponsered"))
                                          ? Positioned(
                                              bottom: -15,
                                              right: 30.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffeb602f),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Text(
                                                  article?.type ?? "",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  spaceWidget(height: 10),
                                  // Title and Author Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article?.title ?? "",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 18
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 16
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 15
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 13.5
                                                            : 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ), //  : SizedBox.shrink(),
                                        article?.itemType == "poll" &&
                                                (article?.selectedOption
                                                        ?.trim()
                                                        .isEmpty ??
                                                    true)
                                            ? HtmlWidget(
                                                trimmedDescription,
                                                textStyle: TextStyle(
                                                  fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height >
                                                          800
                                                      ? 12
                                                      : MediaQuery.of(context)
                                                                  .size
                                                                  .height >
                                                              700
                                                          ? 10
                                                          : MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  650
                                                              ? 10
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .height >
                                                                      500
                                                                  ? 9
                                                                  : 8,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        article?.selectedOption == null &&
                                                article?.itemType != "poll"
                                            ? spaceWidget(height: 8)
                                            : const SizedBox.shrink(),
                                        article?.selectedOption == null &&
                                                article?.itemType == "poll"
                                            ? const Divider(
                                                color: Colors.grey,
                                              )
                                            : const SizedBox.shrink(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: article?.itemType == "poll"
                                                  ? Text(
                                                      (article?.question
                                                                      ?.length ??
                                                                  0) >
                                                              100
                                                          ? '${article?.question!.substring(0, 100)}...'
                                                          : article?.question ??
                                                              "",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height >
                                                                  800
                                                              ? 13
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .height >
                                                                      700
                                                                  ? 12
                                                                  : MediaQuery.of(context)
                                                                              .size
                                                                              .height >
                                                                          650
                                                                      ? 11
                                                                      : MediaQuery.of(context).size.height >
                                                                              500
                                                                          ? 10
                                                                          : 9))
                                                  : AutoSizeText(
                                                      article?.authorName ?? "",
                                                      style: TextStyle(
                                                        fontSize:
                                                            article?.itemType ==
                                                                    "poll"
                                                                ? 14.0
                                                                : 14.0,
                                                        color:
                                                            article?.itemType ==
                                                                    "poll"
                                                                ? Colors.black
                                                                : const Color(
                                                                    0xffeb602f),
                                                        fontWeight:
                                                            article?.itemType ==
                                                                    "poll"
                                                                ? FontWeight
                                                                    .normal
                                                                : FontWeight
                                                                    .bold,
                                                      ),
                                                      maxLines:
                                                          1, // Restrict to a single line, then reduce the font size if it overflows
                                                      minFontSize: article
                                                                  ?.itemType ==
                                                              "poll"
                                                          ? 10
                                                          : 14, // Define the minimum font size if the text overflows
                                                      overflow: TextOverflow
                                                          .ellipsis, // Optional: to add ellipsis for overflowed text
                                                    ),
                                            ),
                                            spaceWidget(width: 10),
                                            article?.itemType == "ad" ||
                                                    article?.itemType == "poll"
                                                ? Container()
                                                : Text(
                                                    articleViewModel.formatDate(
                                                        article?.createdAt ??
                                                            ""),
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.3)),
                                                  ),
                                          ],
                                        ),
                                        spaceWidget(height: 10),
                                        article?.itemType == "ad"
                                            ? article?.externalUrl == ""
                                                ? const Text("")
                                                : Text("")
                                            // Text(article?.externalUrl ?? "",style: TextStyle(fontSize: MediaQuery.of(context)
                                            //               .size
                                            //               .height >
                                            //           800
                                            //       ? 12
                                            //       : MediaQuery.of(context)
                                            //                   .size
                                            //                   .height >
                                            //               700
                                            //           ? 10
                                            //           : MediaQuery.of(context)
                                            //                       .size
                                            //                       .height >
                                            //                   650
                                            //               ? 10
                                            //               : MediaQuery.of(context)
                                            //                           .size
                                            //                           .height >
                                            //                       500
                                            //                   ? 9
                                            //                   : 8,)
                                            //                   ,)
                                            : article?.itemType == "poll"
                                                ? (article?.selectedOption ==
                                                            null ||
                                                        article?.selectedOption
                                                                ?.isEmpty ==
                                                            true)
                                                    ? SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _buildOptionContainer(
                                                                1,
                                                                article?.option1 ??
                                                                    "Option 1",
                                                                article),
                                                            const SizedBox(
                                                                height: 5),
                                                            _buildOptionContainer(
                                                                2,
                                                                article?.option2 ??
                                                                    "Option 2",
                                                                article),
                                                            article?.option3 !=
                                                                        null &&
                                                                    article?.option3 !=
                                                                        ""
                                                                ? const SizedBox(
                                                                    height: 5)
                                                                : const SizedBox
                                                                    .shrink(),
                                                            article?.option3 !=
                                                                        null &&
                                                                    article?.option3 !=
                                                                        ""
                                                                ? _buildOptionContainer(
                                                                    3,
                                                                    article?.option3 ??
                                                                        "Option 3",
                                                                    article)
                                                                : const SizedBox
                                                                    .shrink(),
                                                            article?.option4 !=
                                                                        null &&
                                                                    article?.option4 !=
                                                                        ""
                                                                ? const SizedBox(
                                                                    height: 5)
                                                                : const SizedBox
                                                                    .shrink(),
                                                            article?.option4 !=
                                                                        null &&
                                                                    article?.option4 !=
                                                                        ""
                                                                ? _buildOptionContainer(
                                                                    4,
                                                                    article?.option4 ??
                                                                        "Option 4",
                                                                    article)
                                                                : const SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                      )
                                                    : SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _buildOptionContainer(
                                                                1,
                                                                article?.option1 ??
                                                                    "Option 1",
                                                                article),
                                                            const SizedBox(
                                                                height: 5),
                                                            _buildOptionContainer(
                                                                2,
                                                                article?.option2 ??
                                                                    "Option 2",
                                                                article),
                                                            const SizedBox(
                                                                height: 5),
                                                            article?.option3 !=
                                                                        null &&
                                                                    article?.option3 !=
                                                                        ""
                                                                ? _buildOptionContainer(
                                                                    3,
                                                                    article?.option3 ??
                                                                        "Option 3",
                                                                    article)
                                                                : const SizedBox
                                                                    .shrink(),
                                                            const SizedBox(
                                                                height: 5),
                                                            article?.option4 !=
                                                                        null &&
                                                                    article?.option4 !=
                                                                        ""
                                                                ? _buildOptionContainer(
                                                                    4,
                                                                    article?.option4 ??
                                                                        "Option 4",
                                                                    article)
                                                                : const SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                      )
                                                : const SizedBox.shrink(),
                                        spaceWidget(height: 15.0),
                                        article?.itemType == "ad"
                                            // ||
                                            //         article?.itemType == "poll"
                                            ? Container()
                                            : article?.itemType == "poll"
                                                ? Container(
                                                    child: (article?.selectedOption == null ||
                                                            article?.selectedOption
                                                                    ?.isEmpty ==
                                                                true ||
                                                            article?.selectedOption ==
                                                                "" ||
                                                            article?.selectedOption ==
                                                                null)
                                                        ? Center(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_selectedOption !=
                                                                    null) {
                                                                  // Update the UI state to show the graph and add votes locally
                                                                  setState(() {
                                                                    // Mark the selected option locally so the graph appears
                                                                    article!.selectedOption =
                                                                        _selectedOption
                                                                            .toString();

                                                                    // Update votes for the selected option
                                                                    article
                                                                        .votes![
                                                                            _selectedOption! -
                                                                                1]
                                                                        .vote = (article.votes![_selectedOption! - 1].vote ??
                                                                            0) +
                                                                        1;

                                                                    article.totalVotes =
                                                                        (article.totalVotes ??
                                                                                0) +
                                                                            1;
                                                                  });

                                                                  // Call API to submit the selected option
                                                                  await pollViewModel.pollSelectedOpt(
                                                                      selectedAnswer:
                                                                          _selectedOption,
                                                                      pollId:
                                                                          article!
                                                                              .id);

                                                                  // Show a confirmation message
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Option $_selectedOption selected!')),
                                                                  );
                                                                } else {
                                                                  // Show a message if no option was selected
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Please select an option.')),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffeb602f),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        25.0,
                                                                    vertical:
                                                                        12.0),
                                                                elevation: 5,
                                                              ),
                                                              child: const Text(
                                                                  "Submit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            height:
                                                                screenHeight *
                                                                    0.15,
                                                            child: Stack(
                                                              children: [
                                                                ..._getBarLabels(
                                                                    article!,
                                                                    context),

                                                                BarChart(
                                                                  BarChartData(
                                                                    titlesData:
                                                                        FlTitlesData(
                                                                      bottomTitles:
                                                                          AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(
                                                                          showTitles:
                                                                              true,
                                                                          reservedSize:
                                                                              38,
                                                                          getTitlesWidget:
                                                                              (value, meta) {
                                                                            switch (value.toInt()) {
                                                                              case 0:
                                                                                return SideTitleWidget(
                                                                                  space: 1.0,
                                                                                  meta: meta,
                                                                                  //axisSide: meta.//axisSide,
                                                                                  child: const Text(
                                                                                    'A',
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  ),
                                                                                );
                                                                              case 1:
                                                                                return SideTitleWidget(
                                                                                  meta: meta,
                                                                                  space: 1.0,
                                                                                  //axisSide: meta.//axisSide,
                                                                                  child: const Text(
                                                                                    'B',
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  ),
                                                                                );
                                                                              case 2:
                                                                                return article.option3 != null
                                                                                    ? SideTitleWidget(
                                                                                        meta: meta,
                                                                                        space: 1.0,
                                                                                        //axisSide: meta.//axisSide,
                                                                                        child: const Text(
                                                                                          'C',
                                                                                          style: TextStyle(color: Colors.black),
                                                                                        ),
                                                                                      )
                                                                                    : SizedBox.shrink();
                                                                              case 3:
                                                                                return article.option4 != null
                                                                                    ? SideTitleWidget(
                                                                                        meta: meta,
                                                                                        //axisSide: meta.//axisSide,
                                                                                        space: 1.0,
                                                                                        child: const Text(
                                                                                          'D',
                                                                                          style: TextStyle(color: Colors.black),
                                                                                        ),
                                                                                      )
                                                                                    : SizedBox.shrink();
                                                                              default:
                                                                                return SideTitleWidget(
                                                                                  meta: meta,
                                                                                  //axisSide: meta.//axisSide,
                                                                                  child: const Text(''),
                                                                                );
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      leftTitles:
                                                                          const AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(showTitles: false),
                                                                      ),
                                                                      topTitles:
                                                                          const AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(showTitles: false),
                                                                      ),
                                                                      rightTitles:
                                                                          const AxisTitles(
                                                                        sideTitles:
                                                                            SideTitles(showTitles: false),
                                                                      ),
                                                                    ),
                                                                    gridData:
                                                                        const FlGridData(
                                                                            show:
                                                                                false), // Hide grid lines
                                                                    borderData:
                                                                        FlBorderData(
                                                                            show:
                                                                                false),
                                                                    barGroups:
                                                                        _getBarGroups(
                                                                            article!), // Pass pollQuestion to get bar values
                                                                    barTouchData:
                                                                        BarTouchData(
                                                                      enabled:
                                                                          true,
                                                                      touchTooltipData:
                                                                          BarTouchTooltipData(
                                                                        getTooltipItem: (group,
                                                                            groupIndex,
                                                                            rod,
                                                                            rodIndex) {
                                                                          return BarTooltipItem(
                                                                            '${rod.toY.toStringAsFixed(1)}%', // Display the value of each bar
                                                                            const TextStyle(color: Colors.white),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Add percentage labels at the tips of the bars
                                                                ..._getBarLabels(
                                                                    article,
                                                                    context), // Ensure you pass the context
                                                              ],
                                                            ),
                                                          ))
                                                : GestureDetector(
                                                    onTap: () {
                                                      article?.externalUrl == ""
                                                          ? Get.to(() =>
                                                              ArticleDetailsScreen(
                                                                articleTitle:
                                                                    article?.title ??
                                                                        "",
                                                                articleId:
                                                                    article?.id ??
                                                                        0,
                                                              ))
                                                          : Get.to(() =>
                                                              WebViewScreen(
                                                                url: article
                                                                        ?.externalUrl ??
                                                                    "",
                                                              ));
                                                      articleAnalyticsViewModel
                                                          .articleAnalyticsForLikeShareCount(
                                                        articleId: articleViewModel
                                                            .articleListDataModel
                                                            .value
                                                            ?.responseBody?[
                                                                index]
                                                            ?.id,
                                                        type: "click",
                                                      );
                                                    },
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: [
                                                        const Text(
                                                          'Read More',
                                                          style: TextStyle(
                                                            letterSpacing: 1.5,
                                                            color: Color(
                                                                0xffeb602f),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom:
                                                              0, // Adjust this value to control spacing
                                                          child: Container(
                                                            height:
                                                                2.0, // Thickness of underline
                                                            width:
                                                                85.0, // Adjust to match text width
                                                            color: const Color(
                                                                0xffeb602f), // Underline color
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Read More Button and Icons at Bottom
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: article?.itemType == "ad"
                                //  ||
                                //         article?.itemType == "poll"
                                ? (article?.externalUrl == "" ||
                                        article?.externalUrl == null)
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 60.0,
                                            right: 140.0,
                                            bottom: 20.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              // article?.itemType == "poll"
                                              //     ? Get.to(() => PollScreen1(
                                              //         pollid: article?.id ?? 0))
                                              //     :
                                              Get.to(() => WebViewScreen(
                                                  url: article?.externalUrl ??
                                                      ""));
                                              articleAnalyticsViewModel
                                                  .adAnalytics(
                                                      adId: article?.id,
                                                      type: "click");
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xffeb602f)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                            ),
                                            child: const Center(
                                              child: const Text(
                                                "Know More",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                      )
                                : article?.itemType == "poll"
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // Aligns icons to the right
                                          children: [
                                            Obx(() {
                                              // Get the current article based on the index
                                              var article = articleViewModel
                                                  .articleListDataModel
                                                  .value
                                                  ?.responseBody?[index];

                                              // Determine if the article is marked as a favorite based on isLike
                                              bool isFavorite =
                                                  article?.isLike == 1;

                                              return GestureDetector(
                                                onTap: () {
                                                  // Update like count and toggle favorite status immediately
                                                  if (isFavorite) {
                                                    // If the article is already liked (isLike == 1), set isLike to 0 and decrease the like count
                                                    article?.isLike =
                                                        0; // Mark as not liked
                                                    article?.likes = (article
                                                                .likes ??
                                                            0) -
                                                        1; // Decrease likes count

                                                    // Call the analytics method for 'unlike'
                                                    articleAnalyticsViewModel
                                                        .articleAnalyticsForLikeShareCount(
                                                      articleId: article?.id,
                                                      type: "unlike",
                                                    );

                                                    // Optionally remove from favorite articles if you're using a separate list
                                                    articleViewModel
                                                        .favoriteArticles
                                                        .remove(index);
                                                  } else {
                                                    // If the article is not liked (isLike == 0), set isLike to 1 and increase the like count
                                                    article?.isLike =
                                                        1; // Mark as liked
                                                    article?.likes = (article
                                                                .likes ??
                                                            0) +
                                                        1; // Increase likes count

                                                    // Call the analytics method for 'like'
                                                    articleAnalyticsViewModel
                                                        .articleAnalyticsForLikeShareCount(
                                                      articleId: article?.id,
                                                      type: "like",
                                                    );

                                                    // Optionally add to favorite articles if you're using a separate list
                                                    articleViewModel
                                                        .favoriteArticles
                                                        .add(index);
                                                  }

                                                  // Notify GetX to update the UI immediately
                                                  articleViewModel.updateArticle(
                                                      article); // Assuming you have a method to update the article in the list
                                                },
                                                child: Column(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: isFavorite
                                                              ? Colors.redAccent
                                                              : Colors.grey
                                                                  .shade400,
                                                          width: 2,
                                                        ),
                                                        color: isFavorite
                                                            ? Colors.red.shade50
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Icon(
                                                        isFavorite
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 22.0,
                                                        color: isFavorite
                                                            ? Colors.redAccent
                                                            : Colors
                                                                .grey.shade600,
                                                      ),
                                                    ),
                                                    // Display the updated like count
                                                    Text(
                                                      articleViewModel
                                                          .formatCount(article
                                                                  ?.likes ??
                                                              0), // Display formatted like count
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),

                                            const SizedBox(
                                                width:
                                                    16.0), // Spacing between icons

                                            // Share Icon
                                            GestureDetector(
                                              onTap: () {
                                                var article = articleViewModel
                                                    .articleListDataModel
                                                    .value
                                                    ?.responseBody?[index];
                                                if (article != null) {
                                                  String shareMessage =
                                                      "Check out this article:\nTitle: ${article.title}\nDescription: ${article.description}\nRead more: ${article.externalUrl}";
                                                  Share.share(shareMessage);
                                                  articleAnalyticsViewModel
                                                      .articleAnalyticsForLikeShareCount(
                                                    articleId: articleViewModel
                                                        .articleListDataModel
                                                        .value
                                                        ?.responseBody?[index]
                                                        ?.id,
                                                    type: "share",
                                                  );
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade400,
                                                        width: 2,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.share_outlined,
                                                      size: 22.0,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                  const Text("")
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    16.0), // Spacing between icons
                                            // Bookmark Icon
                                            Obx(() {
                                              bool isBookmarked =
                                                  articleViewModel
                                                      .bookmarkedArticles
                                                      .contains(article?.id);
                                              return GestureDetector(
                                                onTap: () {
                                                  articleViewModel
                                                      .toggleBookmark(article!
                                                          .id!); // Use article.id instead of index
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center, // Center content
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: isBookmarked
                                                              ? Colors
                                                                  .orangeAccent
                                                              : Colors.grey
                                                                  .shade400,
                                                          width: 2,
                                                        ),
                                                        color: isBookmarked
                                                            ? Colors
                                                                .orange.shade50
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Icon(
                                                        isBookmarked
                                                            ? Icons.bookmark
                                                            : Icons
                                                                .bookmark_border,
                                                        size: 22.0,
                                                        color: isBookmarked
                                                            ? Colors
                                                                .orangeAccent
                                                            : Colors
                                                                .grey.shade600,
                                                      ),
                                                    ),
                                                    // Add spacing between the icon and text
                                                    const Text("")
                                                  ],
                                                ),
                                              );
                                            }),

                                            // Favorite Icon
                                          ],
                                        ),
                                      ),
                          ),
                        ],
                      );
                    },
                    physics:
                        const BouncingScrollPhysics(), // Smooth bounce effect when scrolling
                    curve: Curves.easeInOut, // Smooth transition effect
                    duration: 600, // Adjust scroll speed in milliseconds
                    viewportFraction:
                        1.0, // Makes it feel like you're smoothly spreading between screens
                    scale:
                        1.0, // Add a small scaling effect for a more dramatic transition
                    loop:
                        false, // Prevent infinite scrolling for a more natural feel
                  );
                }
              }),
              bottomNavigationBar: const CustomBottomNavBar(),
            ),
          ),
        ),
      ),
    );
  }

//<--New-->
  Widget _buildOptionContainer(
      int optionNumber, String optionText, pollQuestion) {
    const List<String> optionLabels = ['A', 'B', 'C', 'D'];
    bool isHighlighted = pollQuestion.selectedOption != null &&
        pollQuestion.selectedOption == optionNumber.toString();

    // Determine if the option is currently selected by the user
    // Check if there are any selected options
    bool isSelected = pollQuestion.selectedOption.isEmpty
        ? (_selectedOption == optionNumber)
        : (pollQuestion.selectedOption == optionNumber.toString());

// Combine selection and highlighting logic
    bool shouldHighlight = isHighlighted || isSelected;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = optionNumber; // Update the selected option
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height > 800
            ? 40
            : MediaQuery.of(context).size.height > 700
                ? 35
                : MediaQuery.of(context).size.height > 650
                    ? 30
                    : MediaQuery.of(context).size.height > 500
                        ? 30
                        : 27,
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: shouldHighlight
                ? const Color(0xffeb602f)
                : const Color.fromARGB(255, 233, 230, 230),
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: isHighlighted
              ? Colors.white
              : const Color.fromARGB(255, 233, 230, 230),
        ),
        child: Row(
          children: [
            Text(
              "${optionLabels[optionNumber - 1]}. ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height > 800
                      ? 12.0
                      : MediaQuery.of(context).size.height > 700
                          ? 10
                          : MediaQuery.of(context).size.height > 650
                              ? 9
                              : MediaQuery.of(context).size.height > 500
                                  ? 9
                                  : 8),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height > 800
                        ? 12.0
                        : MediaQuery.of(context).size.height > 700
                            ? 10
                            : MediaQuery.of(context).size.height > 650
                                ? 9
                                : MediaQuery.of(context).size.height > 500
                                    ? 9
                                    : 8),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Positioned> _getBarLabels(
      ArticleDataModel pollQuestion, BuildContext context) {
    List<Positioned> labels = [];

    // Get options and votes
    List<String?> options = [
      pollQuestion.option1,
      pollQuestion.option2,
      pollQuestion.option3,
      pollQuestion.option4
    ];

    List<int> votes = [];
    if (pollQuestion.votes != null) {
      for (var vote in pollQuestion.votes!) {
        votes.add(vote.vote ?? 0);
      }
    } else {
      votes = List.filled(options.length, 0);
    }

    double screenWidth = MediaQuery.of(context).size.width;
    int validOptionCount = 0;

    for (int i = 0; i < options.length; i++) {
      // Skip if option is null or empty string
      if (options[i] == null || options[i]!.isEmpty) continue;

      double percentage =
          (votes[i] / pollQuestion.totalVotes! * 100).toDouble();
      double leftPosition = pollQuestion.option3!.isNotEmpty &&
              pollQuestion.option4!.isNotEmpty
          ? (validOptionCount * (screenWidth * 0.2)) + (screenWidth * 0.13)
          : pollQuestion.option3!.isNotEmpty && pollQuestion.option4!.isEmpty
              ? (validOptionCount * (screenWidth * 0.25)) + (screenWidth * 0.16)
              : pollQuestion.option3!.isEmpty && pollQuestion.option4!.isEmpty
                  ? (validOptionCount * (screenWidth * 0.32)) +
                      (screenWidth * 0.25)
                  : (validOptionCount * (screenWidth * 0.2)) +
                      (screenWidth * 0.13);

      labels.add(
        Positioned(
          left: leftPosition,
          bottom: 0.0,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      validOptionCount++;
    }

    return labels;
  }

// Function to create labels for each bar
// Function to get bar groups
  List<BarChartGroupData> _getBarGroups(ArticleDataModel pollQuestion) {
    // Get options and their corresponding votes
    List<String?> options = [
      pollQuestion.option1,
      pollQuestion.option2,
      pollQuestion.option3,
      pollQuestion.option4
    ];

    List<int> votes = [];
    if (pollQuestion.votes != null) {
      for (var vote in pollQuestion.votes!) {
        votes.add(vote.vote ?? 0);
      }
    } else {
      votes = List.filled(options.length, 0);
    }

    List<BarChartGroupData> barGroups = [];
    int validOptionIndex = 0;

    for (int i = 0; i < options.length; i++) {
      // Skip if option is null or empty string
      if (options[i] == null || options[i]!.isEmpty) continue;

      double percentage =
          (votes[i] / pollQuestion.totalVotes! * 100).toDouble();

      barGroups.add(
        BarChartGroupData(
          x: validOptionIndex,
          barRods: [
            BarChartRodData(
              toY: percentage,
              color: const Color(0xffeb602f),
              width: 35,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );

      validOptionIndex++;
    }

    return barGroups;
  }
//<--New-->
//<---Old-->
  // Helper method to build option containers
//   Widget _buildOptionContainer(int optionNumber, String optionText, pollQuestion) {
//     const List<String> optionLabels = ['A', 'B', 'C', 'D'];
//      bool isSelected = _selectedOption == optionNumber || pollQuestion.selectedOption == optionNumber;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedOption = optionNumber;
//         });
//       },
//       child: Container(
//         height: MediaQuery.of(context).size.width * 0.10,
//         padding: const EdgeInsets.only(top:2.0,bottom: 2.0,left: 5),
//         decoration: BoxDecoration(
//           border: Border.all(color: _selectedOption == optionNumber ? const Color(0xffeb602f): const Color.fromARGB(255, 233, 230, 230)),
//           borderRadius: BorderRadius.circular(10.0),
//           color: isSelected ? Colors.white: const Color.fromARGB(255, 233, 230, 230) ,
//         ),
//         child: Row(
//           children: [
//             Text("${optionLabels[optionNumber - 1]}. ",
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
//             const SizedBox(width: 10.0),
//             Expanded(
//               child: Text(optionText, style: const TextStyle(fontSize: 12.0),maxLines: 2,overflow: TextOverflow.ellipsis,),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// List<BarChartGroupData> _getBarGroups(PollAnalyticsDataModel pollQuestion) {
//   // Extract the y values (votes) from selectedOptions, defaulting to 0 if the option is not available
//   List<int> selectedOptionVotes = pollQuestion.votes?.map((option) => option.votes ?? 0).toList() ?? [0, 0, 0, 0];

//   // Ensure we have at least 4 options, filling missing options with 0
//   while (selectedOptionVotes.length < 4) {
//     selectedOptionVotes.add(0);
//   }

//   return List.generate(4, (index) {
//     double percentage = (selectedOptionVotes[index] / 100 * 100).toDouble();

//     return BarChartGroupData(
//       x: index,
//       barRods: [
//         BarChartRodData(
//           toY: percentage, // Use the calculated percentage directly
//           color: const Color(0xffeb602f),
//           width: 35,
//           borderRadius: BorderRadius.zero,
//         ),
//       ],
//     );
//   });
// }

// // Function to create labels for each bar
// List<Widget> _getBarLabels(PollAnalyticsDataModel pollQuestion, BuildContext context) {
//   List<Widget> labels = [];
//   List<int> selectedOptionVotes = pollQuestion.votes?.map((option) => option.votes ?? 0).toList() ?? [0, 0, 0, 0];

//   for (int i = 0; i < selectedOptionVotes.length; i++) {
//     double percentage = (selectedOptionVotes[i] / 100 * 100).toDouble();

//     // Calculate the left position based on the index and bar width
//     double leftPosition = (i * 88)+ 54; // Adjust based on bar width and spacing

//     // Calculate the top position based on the height of the bar
//     double bottom = MediaQuery.of(context).size.height * 0.03 * (1 - (percentage / 100)) - 25; // Adjust for height

//     labels.add(
//       Positioned(
//         left: leftPosition,
//         bottom: bottom,
//         child: Text(
//           '${percentage.toStringAsFixed(1)}%', // Display percentage
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   return labels;
// }
//<---old--->
}
