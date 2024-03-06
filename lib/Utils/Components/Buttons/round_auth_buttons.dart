import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import '../Text/simple_text.dart';

class RoundAuthButtons extends StatelessWidget {
  final Size size;
  final String btnText;
  const RoundAuthButtons({super.key, required this.size, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
      width: size.width,
      decoration: ShapeDecoration(
        color: ColorClass.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SimpleText(
            text: btnText,
            fontColor: Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
          SvgPicture.asset("assets/svg/ep_fwrd.svg"),
        ],
      ),
    );
  }
}
