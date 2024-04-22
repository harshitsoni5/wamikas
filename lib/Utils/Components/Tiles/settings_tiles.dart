import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../Text/simple_text.dart';

class SettingsTiles extends StatelessWidget {
  final String tileName;
  final VoidCallback onPressed;
  final bool isLastTile;
  final Widget? widget;
  final String assetName;
  final bool? hideArrow;
  const SettingsTiles({
    super.key,
    required this.tileName,
    required this.onPressed,
    required this.isLastTile,
    required this.assetName,
     this.hideArrow,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(assetName,height: 22,width: 22,)
                ),
                const SizedBox(width: 10,),
                SimpleText(
                  text: tileName,
                  fontSize: 14.5.sp,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                widget ?? const SizedBox(),
                const Spacer(),
                hideArrow==null? SvgPicture.asset("assets/svg/forward.svg"):
                const SizedBox(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isLastTile ? const SizedBox() : const Divider(
            color: Color(0xffCFCFCF),)
        ],
      ),
    );
  }
}
