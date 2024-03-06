import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Text/simple_text.dart';

class OnBoardingText extends StatelessWidget {
  final String title;
  final String subTitle;
  final String svgPicture;
  const OnBoardingText({
    super.key,
    required this.title,
    required this.subTitle,
    required this.svgPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 50.0),
      child: Column(
        children: [
          SvgPicture.asset("assets/svg/logo.svg"),
          const SizedBox(height: 20,),
          SimpleText(
            textAlign: TextAlign.center,
            text: title,
            fontColor: const Color(0xFF0E0D0D),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,),
          SimpleText(
            text:subTitle,
            textAlign: TextAlign.center,
            fontColor: const Color(0xFF606060),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,),
          const SizedBox(height: 15,),
          SvgPicture.asset(svgPicture),
        ],
      ),
    );
  }
}
