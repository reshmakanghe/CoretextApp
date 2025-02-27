import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast({required String toastMessage}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: ConstantText(
    text: toastMessage,
  )));
}
