import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  const AppText(
      this.text, {
        super.key,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.align,
        this.overflow,
        this.maxLines,
        this.decoration,
        this.fontStyle,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
    );
  }
}
