import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleText extends StatelessWidget {
  final String text;
  final Color? fontColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? textHeight;
  final TextOverflow? overflow;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final Color? decorationStyle;
  final int? maxLines;
  const SimpleText(
      {super.key,
      required this.text,
       this.fontColor,
      required this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.textHeight,
      this.overflow,
      this.fontFamily,
      this.maxLines,
      this.textDecoration, this.decorationStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: textHeight,
          decoration: textDecoration,
        decorationColor: decorationStyle,
      ),
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
