// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;

//   WebViewScreen({required this.url});

//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   bool _isLoading = true;
//   late WebViewController _webViewController;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }

//   // Method to scroll WebView programmatically

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // onTap: _scrollWebView, // Scroll on tap anywhere on the screen
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () async {
//               if (await _webViewController.canGoBack()) {
//                 _webViewController.goBack();
//               } else {
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//         ),
//         body: Stack(
//           children: [
//             WebView(
//               initialUrl: widget.url,
//               javascriptMode: JavascriptMode.unrestricted,
//               backgroundColor: Colors.transparent,
//               onWebViewCreated: (WebViewController controller) {
//                 _webViewController = controller;
//               },
//               onPageFinished: (String url) {
//                 setState(() {
//                   _isLoading = false;
//                 });
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                 });
//               },
//             ),
//             // Show loading indicator while the page is loading
//             if (_isLoading)
//               AnimatedOpacity(
//                 opacity: _isLoading ? 1.0 : 0.0,
//                 duration: Duration(milliseconds: 300),
//                 child: Container(
//                   color: Colors.transparent,
//                   child: LinearProgressIndicator(
//                     backgroundColor: Colors.black,
//                     color: Colors.white,
//                     minHeight: 2.0,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;
  late WebViewController _webViewController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  // Helper to check for any common file extension in the URL
  bool _hasFileExtension(String url) {
    final fileExtensions = ['.pdf', '.docx', '.xlsx', '.pptx', '.txt', '.csv'];
    return fileExtensions.any((extension) => url.contains(extension));
  }

  // Load file with document viewer if it has a file extension
  void _loadUrlWithViewer(String url) async {
    String viewerUrl;

    if (url.endsWith('.pdf')) {
      viewerUrl = 'https://docs.google.com/gview?embedded=true&url=$url';
    } else {
      viewerUrl = 'https://view.officeapps.live.com/op/view.aspx?src=$url';
    }

    await _webViewController.loadUrl(viewerUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _webViewController.runJavascript("window.scrollBy(0, 100);");
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: Colors.transparent,
              onWebViewCreated: (WebViewController controller) {
                _webViewController = controller;
              },
              navigationDelegate: (NavigationRequest request) {
                final url = request.url;

                if (_hasFileExtension(url)) {
                  _loadUrlWithViewer(
                      url); // Open file in viewer if it has a file extension
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
            ),
            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.black,
                color: Colors.white,
                minHeight: 2.0,
              ),
          ],
        ),
      ),
    );
  }
}
