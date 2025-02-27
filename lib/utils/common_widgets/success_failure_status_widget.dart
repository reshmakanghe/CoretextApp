import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:flutter/material.dart';

class SuccessFailureStatusScreen extends StatefulWidget {
  final String? successMessage;
  final String? errorMessage;
  const SuccessFailureStatusScreen(
      {Key? key, this.successMessage, this.errorMessage})
      : super(key: key);

  @override
  State<SuccessFailureStatusScreen> createState() =>
      _SuccessFailureStatusScreenState();
}

class _SuccessFailureStatusScreenState
    extends State<SuccessFailureStatusScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
            CoreTextAppGlobal.instance.bottomNavigationBarSelectedIndex.value =
                0;
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (popRoute) => const InvoiceListScreen(),
            //   ),
            // );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.red,
              ),
              // Lottie.asset(
              //   "assets/lottie_animations/success_animation.json",
              //   width: (orientation == Orientation.portrait
              //           ? MediaQuery.of(context).size.width
              //           : MediaQuery.of(context).size.height) /
              //       2,
              //   height: (orientation == Orientation.portrait
              //           ? MediaQuery.of(context).size.width
              //           : MediaQuery.of(context).size.height) /
              //       2,
              // ),
              spaceWidget(height: 20.0),
              ConstantText(
                text: widget.successMessage,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
