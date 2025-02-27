import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/string_constants.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:Coretext/utils/widgetConstant/textfield_widget/text_box_widget.dart';
import 'package:flutter/material.dart';

class ShowModalBottomSheet extends StatelessWidget {
  final bool isScrollControlled;
  final bool showDragHandle;
  final BuildContext context;
  final Widget child;
  final Widget builder;

  const ShowModalBottomSheet({
    super.key,
    required this.isScrollControlled,
    required this.showDragHandle,
    required this.context,
    required this.child,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ConstantText(
          text: otpVerification,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 15.0,
        ),
        const ConstantText(
          text: otpSentToYourRegisteredMobileNumber,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextBoxField(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            cursorColor: Colors.white,
            cursorHeight: 18.0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 7.0),
            controller: otpController,
            keyboardType: TextInputType.number,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            hintText: enterOtp,
            hintStyle: TextStyle(color: greyColor.withOpacity(0.4)),
            showLabel: true,
            textLabel: const ConstantText(text: enterOtp),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 30.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 35),
                backgroundColor: Colors.red, // background
                foregroundColor: Colors.white,
              ),
              child: const ConstantText(
                text: verifyOtp,
                color: Colors.white,
              ),
              onPressed: () {}),
        ),
      ],
    );
  }
}
