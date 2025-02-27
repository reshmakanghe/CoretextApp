import 'dart:async';
import 'dart:io';

import 'package:Coretext/module/article_module/model/article_analytics_data_model.dart';
import 'package:Coretext/module/article_module/model/article_data_model.dart';
import 'package:Coretext/module/article_module/screen/ad_details_screen.dart';
import 'package:Coretext/module/article_module/screen/article_details_screen.dart';
import 'package:Coretext/module/article_module/view_model/article_analytics_view_model.dart';

import 'package:Coretext/module/speciality_page_module/my_specialities_module/view_model/my_specialities_view_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:http/http.dart' as http;
import 'package:Coretext/module/speciality_page_module/poll_module/view_model/poll_view_model.dart';

import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:Coretext/module/article_module/screen/webview_screen.dart';
import 'package:Coretext/module/article_module/view_model/article_view_model.dart';

import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ArticleScreen extends StatefulWidget {
  final int? catId;
  String articleHeading;
  ArticleScreen({super.key, this.catId, required this.articleHeading});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final MySpecialitiesViewModel mySpecialitiesViewModel =
      Get.put(MySpecialitiesViewModel());
  final ArticleViewModel articleViewModel = Get.put(ArticleViewModel());
  ArticleAnalyticsViewModel articleAnalyticsViewModel =
      Get.put(ArticleAnalyticsViewModel());
  PollViewModel pollViewModel = Get.put(PollViewModel());

  // Track if the error has been shown
  bool _hasShownError = false;
  int? _selectedOption;
  DateTime? _lastBackPressTime;

  final RxList<int> bookmarkedArticles = RxList<int>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // List<int> selectedCatIds = mySpecialitiesViewModel.getSelectedCatIds();

      // Check if category IDs exist and fetch articles based on the appropriate API
      // showLoadingDialog();

      if (widget.catId != null) {
        await articleViewModel.getArticlesByCategory(catId: widget.catId!);
      } else {
        await articleViewModel.getArticles();
      }
      // hideLoadingDialog(); // Default API call for all articles

      // After the API call completes, call `_getCurrentArticle(0)` and start the timer
      var firstArticle = _getCurrentArticle(0);
      if (firstArticle != null) {
        articleViewModel.startViewTimer(0, firstArticle);
      } else {
        print("No article found for the 0th index.");
      }
    });

    checkConnectivity();
  }

  @override
  void dispose() {
    articleViewModel.reset();
    // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to get the current article based on index
  ArticleDataModel? _getCurrentArticle(int index) {
    // Try to get the article from any of the available lists (articleListDataModel, articleByCategory, articleByMyCatId)
    return articleViewModel.articleListDataModel.value?.responseBody?[index] ??
        articleViewModel.articleByCategory.value?.responseBody?[index] ??
        articleViewModel.articleByMyCatId.value?.responseBody?[index];
  }

// Function to start the timer for the first article
  void _startTimerForFirstArticle() {
    var firstArticle = _getCurrentArticle(0);
    if (firstArticle != null) {
      articleViewModel.startViewTimer(
          0, firstArticle); // Start the timer for the 0th article
    } else {
      print("No article found for the first index.");
    }
  }

  String truncateContentByCharacters(String content, {int maxChars = 540}) {
    if (content.length > maxChars) {
      return '${content.substring(0, maxChars)}...';
    } else {
      return content;
    }
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
        return true;
      },
      child: InternetAwareWidget(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10) {
              CoreTextAppGlobal.instance.bottomNavigationBarSelectedIndex
                  .value = 0; // Update index for ArticleScreen
              Get.to(() => const SpecialityScreen());
            }
          },
          child: SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true, // Extend body behind the AppBar
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor:
                    Colors.orange.withOpacity(0.1), // Transparent AppBar
                elevation: 0, // Remove shadow
                centerTitle: true,
                title: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.articleHeading.isEmpty
                            ? "Recent Articles"
                            : widget.articleHeading,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 3,
                            ),
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Obx(() {
                var articleList = articleViewModel
                        .articleListDataModel.value?.responseBody ??
                    articleViewModel.articleByCategory.value?.responseBody ??
                    articleViewModel.articleByMyCatId.value?.responseBody;
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
                    // articleViewModel
                    //         .articleListDataModel.value?.responseBody?.length ??
                    //     articleViewModel
                    //         .articleByCategory.value?.responseBody?.length ??
                    //     articleViewModel
                    //         .articleByMyCatId.value?.responseBody?.length ??
                    //     0,
                    scrollDirection: Axis.vertical,
                    // Triggered when the user changes the article
                    onIndexChanged: (index) {
                      var article = _getCurrentArticle(index);
                      articleViewModel.startViewTimer(index,
                          article); // Start or reset the timer on index change
                    },
                    itemBuilder: (context, index) {
                      var article = articleList[index];
                      // articleViewModel.articleListDataModel.value
                      //         ?.responseBody?[index] ??
                      //     articleViewModel
                      //         .articleByCategory.value?.responseBody?[index] ??
                      //     articleViewModel
                      //         .articleByMyCatId.value?.responseBody?[index];
                      String? trimmedDescription = article?.description != null
                          ? (article!.description!.length > 600
                              ? '${article.description!.substring(0, 550)}...'
                              : article.description)
                          : "";
                      return Stack(
                        children: [
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (details.delta.dx < -10) {
                                if (article?.itemType == "article") {
                                  // Call the analytics method for articles
                                  articleAnalyticsViewModel
                                      .articleAnalyticsForLikeShareCount(
                                    articleId: article?.id ?? 0,
                                    type: "click",
                                  );

                                  // Navigate based on the external URL condition
                                  article?.externalUrl == ""
                                      ? Get.to(() => ArticleDetailsScreen(
                                            articleTitle: article?.title ?? "",
                                            articleId: article?.id ?? 0,
                                          ))
                                      : Get.to(() => WebViewScreen(
                                            url: article?.externalUrl ?? "",
                                          ));
                                } else if (article?.itemType == "ad") {
                                  // Call the ad analytics method for ads
                                  articleAnalyticsViewModel.adAnalytics(
                                    adId: article?.id ?? 0,
                                    type: "click",
                                  );
                                  Get.to(() => WebViewScreen(
                                      url: article?.externalUrl ?? ""));

                                  // Perform navigation specific to ads if needed
                                  // Get.to(() => articleAnalyticsViewModel
                                  //     .adAnalytics(adId: article?.id ?? 0));
                                }
                              } else if (details.delta.dx > 10) {
                                CoreTextAppGlobal.instance
                                    .bottomNavigationBarSelectedIndex.value = 0;
                                Get.to(() => const SpecialityScreen());
                              }
                            },

                            //old code
                            // onHorizontalDragUpdate: (details) {
                            //   if (details.delta.dx < -10) {
                            //     article?.itemType != "poll"
                            //         ? article?.externalUrl == ""
                            //             ? Get.to(() => ArticleDetailsScreen(
                            //                   articleTitle: article?.title ?? "",
                            //                   articleId: article?.id ?? 0,
                            //                 ))
                            //             : Get.to(() => WebViewScreen(
                            //                 url: article?.externalUrl ?? ""))
                            //         : Container();
                            //   } else if (details.delta.dx > 10) {
                            //     CoreTextAppGlobal.instance
                            //         .bottomNavigationBarSelectedIndex.value = 0;
                            //     Get.to(() => const SpecialityScreen());
                            //   }
                            // },
                            // onPanUpdate: (details) {
                            //   // Detect right-to-left swipe
                            //   if (details.delta.dx < -0) {
                            //     Get.to(() => WebViewScreen(
                            //         url: article?.externalUrl ??
                            //             "https://www.google.com/"));
                            //   }
                            // },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Image Section
                                      Container(
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
                                                    0.62
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
                                        // article?.itemType != "ad"
                                        // ?
                                        Text(
                                          // textAlign: TextAlign.justify,
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
                                                            ? 14
                                                            : 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        article?.itemType == "poll" &&
                                                (article?.selectedOption
                                                        ?.trim()
                                                        .isEmpty ??
                                                    true)
                                            ? HtmlWidget(
                                                trimmedDescription!,
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
                                                customStylesBuilder: (element) {
                                                  return {
                                                    'text-align': 'justify'
                                                  };
                                                },
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
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height >
                                                                800
                                                            ? 10
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .height >
                                                                    700
                                                                ? 10
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .height >
                                                                        650
                                                                    ? 8
                                                                    : MediaQuery.of(context).size.height >
                                                                            500
                                                                        ? 7
                                                                        : 6,
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
                                                                    .normal,
                                                      ),
                                                      maxLines:
                                                          1, // Restrict to a single line, then reduce the font size if it overflows
                                                      minFontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height >
                                                              800
                                                          ? 14
                                                          : MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  700
                                                              ? 14
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .height >
                                                                      650
                                                                  ? 13
                                                                  : MediaQuery.of(context)
                                                                              .size
                                                                              .height >
                                                                          500
                                                                      ? 12
                                                                      : 11, // Define the minimum font size if the text overflows
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
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height >
                                                                800
                                                            ? 14
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .height >
                                                                    700
                                                                ? 14
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .height >
                                                                        650
                                                                    ? 13
                                                                    : MediaQuery.of(context).size.height >
                                                                            500
                                                                        ? 12
                                                                        : 11,
                                                        color: Colors.black
                                                            .withOpacity(0.3)),
                                                  ),
                                          ],
                                        ),
                                        spaceWidget(height: 16),
                                        article?.itemType == "ad"
                                            ? article?.externalUrl == ""
                                                ? const Text("")
                                                : const Text("")
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
                                                : HtmlWidget(
                                                    article?.description ?? "",
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
                                                              ? 12
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .height >
                                                                      650
                                                                  ? 11
                                                                  : MediaQuery.of(context)
                                                                              .size
                                                                              .height >
                                                                          500
                                                                      ? 10
                                                                      : 9,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    customWidgetBuilder:
                                                        (element) {
                                                      return Text(
                                                        element
                                                            .text, // Convert HTML element to text
                                                        maxLines:
                                                            15, // Limit text to 2 lines
                                                        overflow: TextOverflow
                                                            .ellipsis, // Add ellipsis if it overflows
                                                        style: TextStyle(
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
                                                                    ? 12
                                                                    : MediaQuery.of(context).size.height >
                                                                            650
                                                                        ? 11
                                                                        : MediaQuery.of(context).size.height >
                                                                                500
                                                                            ? 10
                                                                            : 9,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      );
                                                    },
                                                  ),
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
                                                                                  meta: meta,
                                                                                  space: 1.0,
                                                                                  ////axisSide: meta.//axisSide,
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
                                                                                return SideTitleWidget(
                                                                                  meta: meta,
                                                                                  space: 1.0,
                                                                                  //axisSide: meta.//axisSide,
                                                                                  child: const Text(
                                                                                    'C',
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  ),
                                                                                );
                                                                              case 3:
                                                                                return SideTitleWidget(
                                                                                  //     //axisSide: meta.//axisSide,
                                                                                  meta: meta,
                                                                                  space: 1.0,
                                                                                  child: const Text(
                                                                                    'D',
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  ),
                                                                                );
                                                                              default:
                                                                                return SideTitleWidget(
                                                                                  //  //axisSide: meta.//axisSide,
                                                                                  meta: meta,
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
                                                                                false), // Hide the grid lines
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
                                    : Center(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 60.0,
                                                right: 140.0,
                                                bottom: 20.0),
                                            child: article?.button == 1
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      // article?.itemType == "poll"
                                                      //     ? Get.to(() => PollScreen1(
                                                      //         pollid: article?.id ?? 0))
                                                      //     :
                                                      Get.to(() => WebViewScreen(
                                                          url: article
                                                                  ?.externalUrl ??
                                                              ""));
                                                      articleAnalyticsViewModel
                                                          .adAnalytics(
                                                              adId: article?.id,
                                                              type: "click");
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xffeb602f)),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        article?.buttonName ??
                                                            "",
                                                        //"Know More",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ))
                                                : Container()),
                                      )
                                : article?.itemType == "poll"
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // Aligns icons to the right
                                          children: [
                                            Obx(() {
                                              // Get the article from either `articleListDataModel` or `articleByCategory`
                                              var articleList = articleViewModel
                                                  .articleListDataModel
                                                  .value
                                                  ?.responseBody;
                                              var categoryArticleList =
                                                  articleViewModel
                                                      .articleByCategory
                                                      .value
                                                      ?.responseBody;

                                              // Check which list has data, then get the article based on the index
                                              var article = articleList !=
                                                          null &&
                                                      articleList.length > index
                                                  ? articleList[index]
                                                  : categoryArticleList !=
                                                              null &&
                                                          categoryArticleList
                                                                  .length >
                                                              index
                                                      ? categoryArticleList[
                                                          index]
                                                      : null;

                                              // Check if the article exists before proceeding
                                              if (article == null)
                                                return SizedBox.shrink();

                                              // Determine if the article is marked as a favorite based on `isLike`
                                              bool isFavorite =
                                                  article.isLike == 1;

                                              return GestureDetector(
                                                onTap: () async {
                                                  articleViewModel
                                                      .toggleFavorite(
                                                          index, article);
                                                  // if (isFavorite) {
                                                  //   // Handle 'unlike' case
                                                  //   article.isLike =
                                                  //       0; // Mark as not liked
                                                  //   article.likes = (article
                                                  //               .likes ??
                                                  //           1) -
                                                  //       1; // Ensure likes is at least 1 before subtracting

                                                  //   // Call the analytics method for 'unlike'
                                                  //   await articleAnalyticsViewModel
                                                  //       .articleAnalyticsForLikeShareCount(
                                                  //     articleId: article.id,
                                                  //     type: "unlike",
                                                  //   );

                                                  //   // Remove from favorite articles list if applicable
                                                  //   articleViewModel
                                                  //       .favoriteArticles
                                                  //       .remove(index);
                                                  // } else {
                                                  //   // Handle 'like' case
                                                  //   article.isLike =
                                                  //       1; // Mark as liked
                                                  //   article.likes = (article
                                                  //               .likes ??
                                                  //           0) +
                                                  //       1; // Ensure likes starts from 0 if null

                                                  //   // Call the analytics method for 'like'
                                                  //   await articleAnalyticsViewModel
                                                  //       .articleAnalyticsForLikeShareCount(
                                                  //     articleId: article.id,
                                                  //     type: "like",
                                                  //   );

                                                  //   // Add to favorite articles list if applicable
                                                  //   articleViewModel
                                                  //       .favoriteArticles
                                                  //       .add(index);
                                                  // }

                                                  // if (isFavorite) {
                                                  //   // Handle 'unlike' case
                                                  //   article.isLike =
                                                  //       0; // Mark as not liked
                                                  //   article.likes = (article
                                                  //               .likes ??
                                                  //           0) -
                                                  //       1; // Decrease like count

                                                  //   // Call the analytics method for 'unlike'
                                                  //   await articleAnalyticsViewModel
                                                  //       .articleAnalyticsForLikeShareCount(
                                                  //     articleId: article.id,
                                                  //     type: "unlike",
                                                  //   );

                                                  //   // Remove from favorite articles list if applicable
                                                  //   articleViewModel
                                                  //       .favoriteArticles
                                                  //       .remove(index);
                                                  // } else {
                                                  //   // Handle 'like' case
                                                  //   article.isLike =
                                                  //       1; // Mark as liked
                                                  //   article.likes = (article
                                                  //               .likes ??
                                                  //           0) +
                                                  //       1; // Increase like count

                                                  //   // Call the analytics method for 'like'
                                                  //   await articleAnalyticsViewModel
                                                  //       .articleAnalyticsForLikeShareCount(
                                                  //     articleId: article.id,
                                                  //     type: "like",
                                                  //   );

                                                  //   // Add to favorite articles list if applicable
                                                  //   articleViewModel
                                                  //       .favoriteArticles
                                                  //       .add(index);
                                                  // }

                                                  // Update the article data in the ViewModel (if necessary)
                                                  articleViewModel.updateArticle(
                                                      article); // Ensure this method updates the observable list

                                                  // Update the UI immediately by calling `update()`
                                                  articleViewModel.update();
                                                  articleViewModel
                                                      .articleListDataModel
                                                      .refresh();
                                                  articleViewModel
                                                      .articleByCategory
                                                      .refresh();
                                                },
                                                // Obx(() {
                                                //   // Get the current article based on the index
                                                //       var article = articleViewModel
                                                //               .articleListDataModel
                                                //               .value
                                                //               ?.responseBody?[index] ??
                                                //       articleViewModel
                                                //           .articleByCategory
                                                //           .value
                                                //           ?.responseBody?[index];

                                                //   // Determine if the article is marked as a favorite based on isLike
                                                //   bool isFavorite =
                                                //       article?.isLike == 1;

                                                //   return GestureDetector(
                                                //     onTap: () async {
                                                //       if (isFavorite) {
                                                //         //new code
                                                //         // If the article is already liked (isLike == 1), set isLike to 0 and decrease the like count
                                                //         // Make the API call and await the response
                                                //         // APIBaseModel<
                                                //         //         ArticleAnalyticsDataModel?>?
                                                //         //     responseUnlikeSuccessful =
                                                //         //     await articleAnalyticsViewModel
                                                //         //         .articleAnalyticsForLikeShareCount(
                                                //         //   articleId: article?.id,
                                                //         //   type: "unlike",
                                                //         // );

                                                //         // // If the API call is successful, proceed with updating the like count and status
                                                //         // if (responseUnlikeSuccessful
                                                //         //         ?.status ==
                                                //         //     true) {
                                                //         //   // Update the UI to reflect the unliked status
                                                //         //   article?.isLike =
                                                //         //       0; // Mark as not liked
                                                //         //   article?.likes = (article
                                                //         //               .likes ??
                                                //         //           0) -
                                                //         //       1; // Decrease like count

                                                //         //   // Optionally remove from favorite articles if using a separate list
                                                //         //   articleViewModel
                                                //         //       .favoriteArticles
                                                //         //       .remove(index);
                                                //         // } else {
                                                //         //   // Handle any error or unsuccessful response here, like showing a message
                                                //         //   print(
                                                //         //       "Failed to unlike the article.");
                                                //         // }
                                                //         //old code

                                                //         article?.isLike =
                                                //             0; // Mark as not liked
                                                //         article?.likes = (article
                                                //                     .likes ??
                                                //                 0) -
                                                //             1; // Decrease likes count

                                                //         // Call the analytics method for 'unlike'
                                                //         articleAnalyticsViewModel
                                                //             .articleAnalyticsForLikeShareCount(
                                                //           articleId: article?.id,
                                                //           type: "unlike",
                                                //         );

                                                //         // Optionally remove from favorite articles if you're using a separate list
                                                //         articleViewModel
                                                //             .favoriteArticles
                                                //             .remove(index);
                                                //       } else {
                                                //         // Make the API call and await the response
                                                //         // APIBaseModel<
                                                //         //         ArticleAnalyticsDataModel?>?
                                                //         //     responseLikeSuccessful =
                                                //         //     await articleAnalyticsViewModel
                                                //         //         .articleAnalyticsForLikeShareCount(
                                                //         //   articleId: article?.id,
                                                //         //   type: "like",
                                                //         // );

                                                //         // If the API call is successful, proceed with updating the like count and status
                                                //         // if (responseLikeSuccessful
                                                //         //         ?.status ==
                                                //         //     true) {
                                                //         //   // Update the UI to reflect the liked status
                                                //         //   article?.isLike =
                                                //         //       1; // Mark as liked
                                                //         //   article?.likes = (article
                                                //         //               .likes ??
                                                //         //           0) +
                                                //         //       1; // Increase like count

                                                //         //   // Optionally add to favorite articles if using a separate list
                                                //         //   articleViewModel
                                                //         //       .favoriteArticles
                                                //         //       .add(index);
                                                //         // } else {
                                                //         //   // Handle any error or unsuccessful response here, like showing a message
                                                //         //   print(
                                                //         //       "Failed to like the article.");
                                                //         // }

                                                //         //old code
                                                //         // // If the article is not liked (isLike == 0), set isLike to 1 and increase the like count
                                                //         article?.isLike =
                                                //             1; // Mark as liked
                                                //         article?.likes = (article
                                                //                     .likes ??
                                                //                 0) +
                                                //             1; // Increase likes count

                                                //         // Call the analytics method for 'like'
                                                //         articleAnalyticsViewModel
                                                //             .articleAnalyticsForLikeShareCount(
                                                //           articleId: article?.id,
                                                //           type: "like",
                                                //         );

                                                //         // Optionally add to favorite articles if you're using a separate list
                                                //         articleViewModel
                                                //             .favoriteArticles
                                                //             .add(index);
                                                //       }
                                                //       //old code
                                                //       // Update like count and toggle favorite status immediately
                                                //       // if (isFavorite) {
                                                //       //   // If the article is already liked (isLike == 1), set isLike to 0 and decrease the like count
                                                //       //   article?.isLike =
                                                //       //       0; // Mark as not liked
                                                //       //   article?.likes = (article
                                                //       //               .likes ??
                                                //       //           0) -
                                                //       //       1; // Decrease likes count

                                                //       //   // Call the analytics method for 'unlike'
                                                //       //   articleAnalyticsViewModel
                                                //       //       .articleAnalyticsForLikeShareCount(
                                                //       //     articleId: article?.id,
                                                //       //     type: "unlike",
                                                //       //   );

                                                //       //   // Optionally remove from favorite articles if you're using a separate list
                                                //       //   articleViewModel
                                                //       //       .favoriteArticles
                                                //       //       .remove(index);
                                                //       // } else {
                                                //       //   // If the article is not liked (isLike == 0), set isLike to 1 and increase the like count
                                                //       //   article?.isLike =
                                                //       //       1; // Mark as liked
                                                //       //   article?.likes = (article
                                                //       //               .likes ??
                                                //       //           0) +
                                                //       //       1; // Increase likes count

                                                //       //   // Call the analytics method for 'like'
                                                //       //   articleAnalyticsViewModel
                                                //       //       .articleAnalyticsForLikeShareCount(
                                                //       //     articleId: article?.id,
                                                //       //     type: "like",
                                                //       //   );

                                                //       //   // Optionally add to favorite articles if you're using a separate list
                                                //       //   articleViewModel
                                                //       //       .favoriteArticles
                                                //       //       .add(index);
                                                //       // }

                                                //       // Notify GetX to update the UI immediately
                                                //       articleViewModel.updateArticle(
                                                //           article); // Assuming you have a method to update the article in the list
                                                //     },
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
                                                        size: 18.0,
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
                                                            ?.responseBody?[
                                                        index] ??
                                                    articleViewModel
                                                            .articleByCategory
                                                            .value
                                                            ?.responseBody?[
                                                        index] ??
                                                    articleViewModel
                                                        .articleByMyCatId
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
                                                      size: 18.0,
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
                                                  // Toggle the bookmark state
                                                  articleViewModel
                                                      .toggleBookmark(
                                                          article!.id!);

                                                  // Show the Snackbar
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        isBookmarked
                                                            ? 'Article removed from bookmarks'
                                                            : 'Article added to bookmarks',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          isBookmarked
                                                              ? Colors
                                                                  .redAccent // Color for removed bookmark
                                                              : Colors
                                                                  .orange, // Color for added bookmark
                                                      duration: Duration(
                                                          seconds:
                                                              2), // Duration of the Snackbar
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        size: 18.0,
                                                        color: isBookmarked
                                                            ? Colors
                                                                .orangeAccent
                                                            : Colors
                                                                .grey.shade600,
                                                      ),
                                                    ),
                                                    const Text(
                                                        "") // Space between the icon and the text (if any)
                                                  ],
                                                ),
                                              );
                                            })

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

  void _openInAppBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true, // Use Safari view controller in iOS
        forceWebView: true, // Use WebView in Android
        enableJavaScript: true, // Enable JavaScript for web content
      );
    } else {
      // Only show the error once
      if (!_hasShownError) {
        _hasShownError = true;
        Get.snackbar('Error', 'Could not open the link');
      }
    }
  }

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
}
