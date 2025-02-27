// import 'package:Coretext/module/article_module/screen/article_screen.dart';
// import 'package:Coretext/module/speciality_page_module/bookmark_module/screen/bookmark_screen.dart';
// import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'webview_screen.dart'; // Import for the next article screen

// import 'package:Coretext/utils/loader.dart';
// import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
// import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
// import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
// import 'package:Coretext/module/article_module/view_model/article_view_model.dart';

// class ArticleDetailsScreen extends StatefulWidget {
//   final int articleId; // Pass article ID to display a specific article

//   const ArticleDetailsScreen({super.key, required this.articleId});

//   @override
//   State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
// }

// class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
//   final ArticleViewModel articleViewModel = Get.put(ArticleViewModel());

//   bool _hasShownError = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       showLoadingDialog();
//       await articleViewModel.getArticleDetails(articleId: widget.articleId);
//       hideLoadingDialog();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InternetAwareWidget(
//       child: SafeArea(
//         child: Scaffold(
//           // appBar: AppBar(
//           //   automaticallyImplyLeading: false,
//           // ),
//           body: Obx(() {
//             var article = articleViewModel.articleDataModel.value;

//             if (article == null) {
//               return const Center(child: Text("Article not found!"));
//             } else {
//               return GestureDetector(
//                 onHorizontalDragEnd: (details) {
//                   if (details.primaryVelocity! > 0) {
//                     // Swipe from right to left
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ArticleScreen(
//                                 articleHeading: "",
//                               ) // Next article screen
//                           ),
//                     );
//                   }
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Article Image
//                     Stack(
//                       alignment: Alignment.center,
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           height: MediaQuery.of(context).size.height * 0.3,
//                           child: const Image(
//                             image: AssetImage("assets/test.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: -15,
//                           right: 30.0,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20.0, vertical: 6.0),
//                             decoration: BoxDecoration(
//                               color: Colors.deepOrange,
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: Text(
//                               article.responseBody?.type ?? "",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     spaceWidget(height: 20),

//                     // Scrollable Content (Title, Author, Description)
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Title
//                               Text(
//                                 article.responseBody?.title ?? "",
//                                 style: const TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               spaceWidget(height: 8),

//                               // Author and Date
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: AutoSizeText(
//                                       article.responseBody?.authorName ?? "",
//                                       style: const TextStyle(
//                                         fontSize: 18.0,
//                                         color: Color.fromARGB(255, 255, 60, 0),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       minFontSize: 14,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   spaceWidget(width: 10),
//                                   Text(
//                                     articleViewModel.formatDate(
//                                         article.responseBody?.createdAt ?? ""),
//                                     style: TextStyle(
//                                         color: Colors.black.withOpacity(0.3)),
//                                   ),
//                                 ],
//                               ),
//                               spaceWidget(height: 16),

//                               // Description (Scrollable)
//                               HtmlWidget(
//                                 article.responseBody?.description ?? "",
//                                 textStyle: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     spaceWidget(height: 20),

//                     // Actions: Bookmark, Favorite, Share
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           Text(
//                             article.responseBody?.authorName ?? "",
//                             style: const TextStyle(color: Colors.deepOrange),
//                           ),
//                           Spacer(),
//                           Obx(() {
//                             bool isBookmarked = articleViewModel
//                                 .bookmarkedArticles
//                                 .contains(article.responseBody?.id);
//                             return IconButton(
//                               icon: Icon(
//                                 size: 30.0,
//                                 isBookmarked
//                                     ? Icons.bookmark
//                                     : Icons.bookmark_border,
//                                 color:
//                                     isBookmarked ? Colors.orange : Colors.black,
//                               ),
//                               onPressed: () {
//                                 articleViewModel.toggleBookmark(
//                                     article.responseBody!.id ?? 0);

//                                 if (!isBookmarked) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => BookmarksScreen(),
//                                     ),
//                                   );
//                                 }
//                               },
//                             );
//                           }),
//                           Obx(() {
//                             bool isFavorite = articleViewModel.favoriteArticles
//                                 .contains(article.responseBody?.id);
//                             return IconButton(
//                               icon: Icon(
//                                 size: 30.0,
//                                 isFavorite
//                                     ? Icons.favorite
//                                     : Icons.favorite_border_outlined,
//                                 color: isFavorite ? Colors.red : primaryColor,
//                               ),
//                               onPressed: () {
//                                 articleViewModel.toggleFavorite(
//                                     article.responseBody?.id ?? 0);
//                               },
//                             );
//                           }),
//                           IconButton(
//                             icon: const Icon(Icons.share),
//                             onPressed: () {
//                               var article = articleViewModel
//                                   .articleDataModel.value?.responseBody;

//                               if (article != null) {
//                                 String shareMessage =
//                                     "Check out this article:\n"
//                                     "Title: ${article.title}\n"
//                                     "Description: ${article.description}\n"
//                                     "Read more: ${article.externalUrl}\n";
//                                 Share.share(shareMessage);
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           }),
//           bottomNavigationBar: const CustomBottomNavBar(),
//         ),
//       ),
//     );
//   }

//   void _openInAppBrowser(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url, forceWebView: true, enableJavaScript: true);
//     } else {
//       if (!_hasShownError) {
//         _hasShownError = true;
//         Get.snackbar('Error', 'Could not open the link');
//       }
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GoogleDriveVideoPlayer extends StatefulWidget {
  @override
  _GoogleDriveVideoPlayerState createState() => _GoogleDriveVideoPlayerState();
}

class _GoogleDriveVideoPlayerState extends State<GoogleDriveVideoPlayer> {
  late VideoPlayerController _controller;
  final String videoUrl = 'https://drive.google.com/uc?export=view&id=1IPAaVdER2Dz-RDjx091TEh2t2KZYO3DM';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true); // Set to loop
          _controller.play(); // Start playing automatically
        }); // Refresh when the video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Drive Video Player"),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
