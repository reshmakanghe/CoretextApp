import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

void showLoadingDialog() {
  Get.dialog(
    LoadingDialog(),
    barrierDismissible: false,
  );
}

void hideLoadingDialog() {
  Get.back();
}
