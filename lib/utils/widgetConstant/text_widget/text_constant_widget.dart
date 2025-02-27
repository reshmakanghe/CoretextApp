import 'package:flutter/material.dart';

class ConstantText extends StatelessWidget {
  final TextStyle? style;
  final String? text;
  final double? fontSize;
  final double? height;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final String? fontFamily;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;

  const ConstantText(
      {super.key,
      required this.text,
      this.textDecoration,
      this.fontSize,
      this.height,
      this.color,
      this.fontFamily,
      this.overflow,
      this.fontWeight,
      this.maxLines,
      this.textAlign,
      this.style,
      this.softWrap,
      this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      // (text ?? "").tr(),
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height > 800
            ? 12
            : MediaQuery.of(context).size.height > 700
                ? 12
                : MediaQuery.of(context).size.height > 650
                    ? 10
                    : MediaQuery.of(context).size.height > 500
                        ? 8
                        : MediaQuery.of(context).size.height > 400
                            ? 6
                            : 14,
        height: height,
        color: color ?? style?.color,
        fontFamily: fontFamily ?? style?.fontFamily,
        fontWeight: fontWeight ?? style?.fontWeight,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
