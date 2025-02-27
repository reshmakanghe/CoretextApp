import 'package:flutter/material.dart';

class ReusableLoginHeader extends StatelessWidget {
  final String titleText;

  const ReusableLoginHeader({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.4, // Upper 40% for blue section
          width: constraints.maxWidth,
          color: Colors.blue, // Set blue color or use your primary color
          child: Center(
            child: SizedBox(
              height: 200, // Set a fixed height for the Column content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Profile-02.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    titleText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
