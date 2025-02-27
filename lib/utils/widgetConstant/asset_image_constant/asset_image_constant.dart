
// import 'package:flutter/material.dart';




// class ImageFromAssetPath<T> {
//   final String assetPath;
//   final double? width;
//   final double? height;
//   final Color? color;
//   late ImageProvider provider;
//   final BoxFit? fit;
// final String? semanticLabel; 

//   late T imageWidget;
//   ImageFromAssetPath({
//     required this.assetPath,
//     this.fit,
//     this.width,
//     this.height,
//     this.color,
//      this.semanticLabel, 
//   }) {
//     provider = AssetImage(assetPath);

//     imageWidget = Semantics(
//       textField: true,
//        label: semanticLabel ?? '',
      
//       child: Image.asset(
//         assetPath,
//         height: height,
//         width: width,
//         color: color,
//         fit: fit,
       
//       ),
//     ) as T;
//   }
// }
