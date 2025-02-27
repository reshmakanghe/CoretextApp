import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class ArrowButton extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onTap;

  const ArrowButton({
    Key? key,
    required this.isLeft,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      top: screenWidth * 0.25,
      child: IconButton(
        icon: Icon(
          isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          size: 30,
        ),
        onPressed: onTap,
      ),
    );
  }
}