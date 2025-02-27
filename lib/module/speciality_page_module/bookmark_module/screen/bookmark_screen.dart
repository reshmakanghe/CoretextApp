import 'package:Coretext/module/article_module/model/article_data_model.dart';
import 'package:Coretext/module/article_module/screen/ad_details_screen.dart';
import 'package:Coretext/module/article_module/screen/aricle_details_screen.dart';
import 'package:Coretext/module/article_module/screen/article_details_screen.dart';
import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/article_module/screen/webview_screen.dart';
import 'package:Coretext/module/article_module/view_model/article_analytics_view_model.dart';
import 'package:Coretext/module/article_module/view_model/article_view_model.dart';
import 'package:Coretext/module/speciality_page_module/my_specialities_module/view_model/my_specialities_view_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/model/poll_data_model.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/view_model/poll_view_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final ArticleViewModel articleViewModel = Get.put(ArticleViewModel());
  ArticleAnalyticsViewModel articleAnalyticsViewModel =
      Get.put(ArticleAnalyticsViewModel());
  PollViewModel pollViewModel = Get.put(PollViewModel());

  // Track if the error has been shown
  bool _hasShownError = false;
  int? _selectedOption;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await articleViewModel.getBookmarkedArticlesFromLocalStorage();
      hideLoadingDialog();
    });

    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
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
          if (details.delta.dx > 10) {
            CoreTextAppGlobal.instance.appNavigationBarSelectedIndex.value = 0;
            Get.to(const SpecialityScreen());
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
                    backgroundColor: const Color(0xffeb602f).withOpacity(0.85),
                    elevation: 5,
                    centerTitle: true,
                    title: const IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Bookmark",
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
            body: Obx(() {
              final bookmarkedArticles =
                  articleViewModel.getBookMarkByid.value?.responseBody;
              if (bookmarkedArticles == null) {
                return const Center(child: Text('No bookmark yet.'));
              }
              return Swiper(
                itemCount: articleViewModel
                        .getBookMarkByid.value?.responseBody?.length ??
                    0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var article = articleViewModel
                      .getBookMarkByid.value?.responseBody?[index];
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
                            CoreTextAppGlobal.instance
                                .appNavigationBarSelectedIndex.value = 0;
                            Get.to(() => const SpecialityScreen());
                          }
                        },
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
                                        ? MediaQuery.of(context).size.height *
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
                                  //          Positioned(
                                  //           top: 0,
                                  //           left: 0,
                                  //           right: 0,
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               color: const Color(0xffeb602f).withOpacity(
                                  // 0.10)
                                  //             ),
                                  //             child: AppBar(
                                  //               automaticallyImplyLeading: false,
                                  //               backgroundColor: Colors.transparent, // Make AppBar transparent
                                  //               elevation: 0, // Remove shadow
                                  //               centerTitle: true,
                                  //               title: IntrinsicWidth(
                                  //                 child: Column(
                                  //                   mainAxisSize: MainAxisSize.min,
                                  //                   children: [
                                  //                    Text(
                                  //                   widget.articleHeading.isEmpty
                                  //                       ? "Recent Articles"
                                  //                       : widget.articleHeading,
                                  //                   style: TextStyle(
                                  //                     fontSize: 20.0,
                                  //                     fontWeight: FontWeight.w500,
                                  //                     color: Colors.white,
                                  //                     letterSpacing: 1.0,
                                  //                     shadows: [
                                  //                       Shadow(
                                  //                         color: Colors.black.withOpacity(0.2),
                                  //                         offset: const Offset(1, 1),
                                  //                         blurRadius: 3,
                                  //                       ),
                                  //                       Shadow(
                                  //                         color: Colors.black.withOpacity(0.2),
                                  //                         offset: const Offset(2, 2),
                                  //                         blurRadius: 3,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //          ),
                                  // Sponsored Tag
                                  ((article?.type == "sponsored") ||
                                          (article?.type == "Sponsored") ||
                                          (article?.type == "Sponsered") ||
                                          (article?.type == "sponsered"))
                                      ? Positioned(
                                          bottom: -15,
                                          right: 30.0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 6.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffeb602f),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // article?.itemType != "ad"
                                    // ?
                                    Text(
                                      // textAlign: TextAlign.justify,
                                      article?.title ?? "",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height >
                                                    800
                                                ? 18
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 15
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
                                              fontSize: MediaQuery.of(context)
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
                                              return {'text-align': 'justify'};
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
                                                  (article?.question?.length ??
                                                              0) >
                                                          100
                                                      ? '${article?.question!.substring(0, 100)}...'
                                                      : article?.question ?? "",
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
                                                                  : MediaQuery.of(context)
                                                                              .size
                                                                              .height >
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
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .height >
                                                                        500
                                                                    ? 7
                                                                    : 6,
                                                    color: article?.itemType ==
                                                            "poll"
                                                        ? Colors.black
                                                        : const Color(
                                                            0xffeb602f),
                                                    fontWeight:
                                                        article?.itemType ==
                                                                "poll"
                                                            ? FontWeight.normal
                                                            : FontWeight.normal,
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
                                                              ? 12
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
                                                    article?.createdAt ?? ""),
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
                                                                ? 12
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .height >
                                                                        500
                                                                    ? 12
                                                                    : 11,
                                                    color: Colors.black
                                                        .withOpacity(0.3)),
                                              ),
                                      ],
                                    ),
                                    spaceWidget(height: 5),
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
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                customWidgetBuilder: (element) {
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
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .height >
                                                                        650
                                                                    ? 11
                                                                    : MediaQuery.of(context).size.height >
                                                                            500
                                                                        ? 10
                                                                        : 9,
                                                        fontWeight:
                                                            FontWeight.normal),
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
                                                        child: ElevatedButton(
                                                          onPressed: () async {
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
                                                                    .vote = (article
                                                                            .votes![_selectedOption! -
                                                                                1]
                                                                            .vote ??
                                                                        0) +
                                                                    1;

                                                                article.totalVotes =
                                                                    (article.totalVotes ??
                                                                            0) +
                                                                        1;
                                                              });

                                                              // Call API to submit the selected option
                                                              await pollViewModel
                                                                  .pollSelectedOpt(
                                                                      selectedAnswer:
                                                                          _selectedOption,
                                                                      pollId:
                                                                          article!
                                                                              .id);

                                                              // Show a confirmation message
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        'Option $_selectedOption selected!')),
                                                              );
                                                            } else {
                                                              // Show a message if no option was selected
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Please select an option.')),
                                                              );
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffeb602f),
                                                            padding:
                                                                const EdgeInsets
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
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
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
                                                                          (value,
                                                                              meta) {
                                                                        switch (
                                                                            value.toInt()) {
                                                                          case 0:
                                                                            return SideTitleWidget(
                                                                              meta: meta,
                                                                              space: 1.0,
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
                                                                              meta: meta,
                                                                              //axisSide: meta.//axisSide,
                                                                              space: 1.0,
                                                                              child: const Text(
                                                                                'D',
                                                                                style: TextStyle(color: Colors.black),
                                                                              ),
                                                                            );
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
                                                                    sideTitles: SideTitles(
                                                                        showTitles:
                                                                            false),
                                                                  ),
                                                                  topTitles:
                                                                      const AxisTitles(
                                                                    sideTitles: SideTitles(
                                                                        showTitles:
                                                                            false),
                                                                  ),
                                                                  rightTitles:
                                                                      const AxisTitles(
                                                                    sideTitles: SideTitles(
                                                                        showTitles:
                                                                            false),
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
                                                                  enabled: true,
                                                                  touchTooltipData:
                                                                      BarTouchTooltipData(
                                                                    getTooltipItem: (group,
                                                                        groupIndex,
                                                                        rod,
                                                                        rodIndex) {
                                                                      return BarTooltipItem(
                                                                        '${rod.toY.toStringAsFixed(1)}%', // Display the value of each bar
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.white),
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
                                                      : Get.to(
                                                          () => WebViewScreen(
                                                                url: article
                                                                        ?.externalUrl ??
                                                                    "",
                                                              ));
                                                  articleAnalyticsViewModel
                                                      .articleAnalyticsForLikeShareCount(
                                                    articleId: articleViewModel
                                                        .articleListDataModel
                                                        .value
                                                        ?.responseBody?[index]
                                                        ?.id,
                                                    type: "click",
                                                  );
                                                },
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    const Text(
                                                      'Read More',
                                                      style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        color:
                                                            Color(0xffeb602f),
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
                                            bottom: 10.0),
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
                                                      MaterialStateProperty.all(
                                                          const Color(
                                                              0xffeb602f)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    article?.buttonName ?? "",
                                                    //"Know More",
                                                    style: const TextStyle(
                                                        color: Colors.white),
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
                                          var articleList = articleViewModel
                                              .getBookMarkByid
                                              .value
                                              ?.responseBody;
                                          var article = articleList != null &&
                                                  articleList.length > index
                                              ? articleList[index]
                                              : null;
                                          if (article == null)
                                            return SizedBox.shrink();

                                          // Determine if the article is marked as a favorite based on `isLike`
                                          bool isFavorite = article.isLike == 1;

                                          return GestureDetector(
                                            onTap: () async {
                                              articleViewModel.toggleFavorite(
                                                  index, article);
                                              // Update the article data in the ViewModel (if necessary)
                                              articleViewModel.updateArticle(
                                                  article); // Ensure this method updates the observable list
                                              // Update the UI immediately by calling `update()`
                                              articleViewModel.update();
                                              // Trigger a UI refresh
                                              articleViewModel.getBookMarkByid
                                                  .refresh();
                                              // Optionally, update the list if necessary
                                              // articleViewModel.updateArticle(article);
                                            },
                                            child: Column(
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: isFavorite
                                                          ? Colors.redAccent
                                                          : Colors
                                                              .grey.shade400,
                                                      width: 2,
                                                    ),
                                                    color: isFavorite
                                                        ? Colors.red.shade50
                                                        : Colors.transparent,
                                                  ),
                                                  child: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: 18.0,
                                                    color: isFavorite
                                                        ? Colors.redAccent
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                                // Display the updated like count
                                                Text(
                                                  articleViewModel.formatCount(
                                                      article?.likes ??
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
                                                .getBookMarkByid
                                                .value
                                                ?.responseBody?[index];
                                            if (article != null) {
                                              String shareMessage =
                                                  "Check out this article:\nTitle: ${article.title}\nDescription: ${article.description}\nRead more: ${article.externalUrl}";
                                              Share.share(shareMessage);
                                              articleAnalyticsViewModel
                                                  .articleAnalyticsForLikeShareCount(
                                                articleId: article
                                                    .id, // Ensure article ID is correct
                                                type: "share",
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                padding: const EdgeInsets.all(
                                                    8.0), // Increase padding for better tap area
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                    width: 2,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.share_outlined,
                                                  size: 18.0,
                                                  color: Colors.grey.shade600,
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
                                          bool isBookmarked = articleViewModel
                                              .bookmarkedArticles
                                              .contains(article?.id);
                                          return GestureDetector(
                                            onTap: () {
                                              articleViewModel.toggleBookmark(
                                                  article!
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
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: isBookmarked
                                                          ? Colors.orangeAccent
                                                          : Colors
                                                              .grey.shade400,
                                                      width: 2,
                                                    ),
                                                    color: isBookmarked
                                                        ? Colors.orange.shade50
                                                        : Colors.transparent,
                                                  ),
                                                  child: Icon(
                                                    isBookmarked
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    size: 18.0, //22.0,
                                                    color: isBookmarked
                                                        ? Colors.orangeAccent
                                                        : Colors.grey.shade600,
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
            }),
            bottomNavigationBar: const CustomBottomNavBar(),
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

    // Check if the option should be highlighted based on article's selected option
    bool isHighlighted = pollQuestion.selectedOption != null &&
        pollQuestion.selectedOption == optionNumber.toString();

    // Determine if the option is currently selected by the user
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
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: shouldHighlight
                ? const Color(
                    0xffeb602f) // Highlight color if selected or indicated
                : const Color.fromARGB(
                    255, 233, 230, 230), // Default border color
          ),
          borderRadius: BorderRadius.circular(10.0),
          color:
              isHighlighted // Set the background color to green if highlighted
                  ? Colors.white // Change this to the desired highlight color
                  : const Color.fromARGB(
                      255, 233, 230, 230), // Default background color
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

  List<BarChartGroupData> _getBarGroups(ArticleDataModel pollQuestion) {
    // Extract the y values (votes) from selectedOptions, defaulting to 0 if the option is not available
    List<int> selectedOptionVotes =
        pollQuestion.votes?.map((option) => option.vote ?? 0).toList() ??
            [0, 0, 0, 0];

    // Ensure we have at least 4 options, filling missing options with 0
    while (selectedOptionVotes.length < 4) {
      selectedOptionVotes.add(0);
    }

    return List.generate(4, (index) {
      double percentage =
          (selectedOptionVotes[index] / pollQuestion.totalVotes! * 100)
              .toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percentage, // Use the calculated percentage directly
            color: const Color(0xffeb602f),
            width: 35,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

  // Function to create labels for each bar
  List<Widget> _getBarLabels(
      ArticleDataModel pollQuestion, BuildContext context) {
    List<Widget> labels = [];
    List<int> selectedOptionVotes =
        pollQuestion.votes?.map((option) => option.vote ?? 0).toList() ??
            [0, 0, 0, 0];

    for (int i = 0; i < selectedOptionVotes.length; i++) {
      double percentage =
          (selectedOptionVotes[i] / pollQuestion.totalVotes! * 100).toDouble();
      double screenWidth = MediaQuery.of(context).size.width;
      double leftPosition = (i * (screenWidth * 0.2)) + (screenWidth * 0.13);

      labels.add(
        Positioned(
          left: leftPosition,
          bottom: 0.0,
          child: Text(
            '${percentage.toStringAsFixed(1)}%', // Display percentage
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return labels;
  }
}
