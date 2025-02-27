// import 'package:flutter/material.dart';

// class MyBorderShape extends ShapeBorder {
//   MyBorderShape();

//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

//   @override
//   Path? getInnerPath(Rect rect, {required TextDirection textDirection}) => null;

//   double holeSize = 70;

//   @override
//   Path? getOuterPath(Rect rect, {required TextDirection textDirection}) {
//     print(rect.height);
//     return Path.combine(
//       PathOperation.difference,
//       Path()
//         ..addRRect(
//             RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
//         ..close(),
//       Path()
//         ..addOval(Rect.fromCenter(
//             center: rect.center.translate(0, -rect.height / 2),
//             height: holeSize,
//             width: holeSize))
//         ..close(),
//     );
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

//   @override
//   ShapeBorder scale(double t) => this;
// }