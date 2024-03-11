import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Text/simple_text.dart';

class TextFieldContainer extends StatelessWidget {
  final String hintText;
  final String titleBox;
  final TextEditingController controller;
  final int? maxLines;
  const TextFieldContainer({
    super.key,
    required this.hintText,
    required this.titleBox,
    required this.controller,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SimpleText(
            text: titleBox,
            fontSize: 15,
            fontColor: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xffE8E8E8)
              )
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xff888888),
                  fontSize: 12,
                )
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
