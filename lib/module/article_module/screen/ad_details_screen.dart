import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdDetailsScreen extends StatefulWidget {
  final String url;

  const AdDetailsScreen({super.key, required this.url});

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Print the URL to debug
  print("Using URL: ${widget.url}");

  // Initialize the video player controller
  _controller = VideoPlayerController.network(widget.url)
    ..initialize().then((_) {
      if (mounted) {
        setState(() {
          _controller.setLooping(true); // Set to loop
          _controller.play(); // Start playing automatically
        });
      }
    }).catchError((error) {
      print("Error initializing video player: $error");
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), // Adjusted height
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
                      "Advertisement",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 5.0), // Space between text and underline
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
