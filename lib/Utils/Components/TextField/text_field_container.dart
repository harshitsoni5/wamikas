import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Text/simple_text.dart';

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^[\w@\s.]*$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class TextFieldContainer extends StatelessWidget {
  final String hintText;
  final String titleBox;
  final TextEditingController controller;
  final int? maxLines;
  final bool? readOnlyTrue;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? isToolbarAllowed;
  const TextFieldContainer({
    super.key, // Added Key? key parameter
    required this.hintText,
    required this.titleBox,
    required this.controller,
    this.isToolbarAllowed,
    this.maxLines,
    this.readOnlyTrue,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
  }); // Super constructor

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SimpleText(
            text: titleBox,
            fontSize: 14.sp,
            fontColor: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xffE8E8E8)
              )
          ),
          child: TextField(
            onTapOutside: (event) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            onChanged: onChanged,
            keyboardType: keyboardType,
            maxLength: maxLength,
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnlyTrue ?? false,
            toolbarOptions: isToolbarAllowed!=null ? ToolbarOptions(
              copy: true,
              cut: true,
              paste: true,
              selectAll: true,
            ):null,

            decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xff888888),
                  fontSize: 14,
                )
            ),
            inputFormatters: [EmailInputFormatter()], // Apply EmailInputFormatter
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
