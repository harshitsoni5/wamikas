import 'package:flutter/material.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import '../Text/simple_text.dart';

class RoundFinaliseButton extends StatelessWidget {
  final String btnText;
  final bool isEnable;

  const RoundFinaliseButton(
      {super.key,
      required this.size,
      required this.btnText,
      required this.isEnable});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 45,
      decoration: ShapeDecoration(
        color: isEnable ? ColorClass.primaryColor : const Color(0xFFB0DEDA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: SimpleText(
          text: btnText,
          fontColor: Colors.white,
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
