import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/module/article_module/view_model/article_view_model.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final int articleId;
  final String articleTitle; // Pass article ID to display a specific article

  const ArticleDetailsScreen(
      {super.key, required this.articleId, required this.articleTitle});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final ArticleViewModel articleViewModel = Get.put(ArticleViewModel());

  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await articleViewModel.getArticleDetails(articleId: widget.articleId);
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InternetAwareWidget(
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true, // Extend body behind the AppBar
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor:
                    Colors.red.withOpacity(0.2), // Transparent AppBar
                elevation: 0, // Remove shadow
                centerTitle: true,
                title: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Recent Articles",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
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
            var article = articleViewModel.articleDataModel.value?.responseBody;

            if (article == null) {
              return const Center(child: Text("Article not found!"));
            } else {
              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // Swipe from right to left
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                                articleHeading: "",
                              ) // Next article screen
                          ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article Image
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Image.network(
                            // Check if the image URL ends with .png, then show dummy image
                            article.imgUrl != null &&
                                    article.imgUrl!.endsWith(".png")
                                ? "assets/images/Core Text Logo (1).png" // Fallback dummy image for .png URLs
                                : APIConfig.imagePath +
                                    (article.imgUrl ??
                                        "assets/test.jpeg"), // Use the image URL if not .png
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              // If the image fails to load, display a fallback image
                              return Image.asset(
                                "assets/images/Core Text Logo (1).png",
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                        ((article.type == "sponsored") || (article.type == "Sponsored") ||
                         (article.type == "Sponsered") || (article.type == "sponsered"))
                                          ? Positioned(
                                              bottom: -15,
                                              right: 30.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffeb602f),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Text(
                                                  article.type ?? "",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : Container(),
                      ],
                    ),
                    spaceWidget(height: 20),

                    // Scrollable Content (Title, Author, Description)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                article.title ?? "",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              spaceWidget(height: 8),

                              // Author and Date
                              Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      article.authorName ?? "",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xffeb602f),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  spaceWidget(width: 10),
                                  Text(
                                    articleViewModel
                                        .formatDate(article.createdAt ?? ""),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                              spaceWidget(height: 16),

                              // Description (Scrollable)
                              HtmlWidget(
                                article.description ?? "",
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    spaceWidget(height: 20),

                    // Actions: Bookmark, Favorite, Share
                  ],
                ),
              );
            }
          }),
          bottomNavigationBar: const CustomBottomNavBar(),
        ),
      ),
    );
  }

  void _openInAppBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      if (!_hasShownError) {
        _hasShownError = true;
        Get.snackbar('Error', 'Could not open the link');
      }
    }
  }
}
