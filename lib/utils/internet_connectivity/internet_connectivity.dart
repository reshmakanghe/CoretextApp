import 'dart:async';
import 'dart:ui';

import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetAwareWidget extends StatefulWidget {
  final Widget child;

  InternetAwareWidget({required this.child});

  @override
  _InternetAwareWidgetState createState() => _InternetAwareWidgetState();
}

class _InternetAwareWidgetState extends State<InternetAwareWidget> {
  bool _hasInternet = true;
  Timer? _stableTimer;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnectivity();
    });
    _startStableTimer();
  }

  @override
  void dispose() {
    _stableTimer?.cancel();
    super.dispose();
  }

  void _startStableTimer() {
    _stableTimer = Timer(Duration(seconds: 60), () {
      if (!_hasInternet && mounted) {
        setState(() {
          // Screen is marked as not stable after 60 seconds without internet
        });
      }
    });
  }

  void _resetStableTimer() {
    _stableTimer?.cancel();
    _startStableTimer();
  }

  Future<void> _checkInternetConnectivity() async {
    bool hasInternet = await _isConnectedToInternet();
    if (mounted) {
      setState(() {
        _hasInternet = hasInternet;
      });
    }
    if (hasInternet) {
      _resetStableTimer();
    }
  }

  Future<bool> _isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _resetStableTimer();
      },
      child: Stack(
        children: [
          widget.child,
          if (!_hasInternet)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(colorBlack)),
                        onPressed: _checkInternetConnectivity,
                        child: Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
