import 'package:flutter/material.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class AttentionWidget extends StatelessWidget {
  final int profilePercentage;
  const AttentionWidget({
    super.key,
    required this.size,
    required this.profilePercentage,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
            height:size.height>850?size.height * 0.088 :size.height * 0.12,
            width: 4,
            color: ColorClass.primaryColor,
          ),
          Flexible(
            child: Container(
              height:size.height>850?size.height * 0.088 :size.height * 0.12,
              color: const Color(0xffFFF0FA),
              padding: const EdgeInsets.only(left: 10, right: 2),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimpleText(
                    text: 'Attention',
                    fontSize:size.width >390? 13:16,
                    fontColor: ColorClass.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SimpleText(
                    text: "Your profile is currently $profilePercentage% complete. "
                        "Please update missing information to ensure"
                        " that your profile is fully optimized"
                        " and performs well",
                    fontSize:size.width <390? 10:13,
                    fontColor: ColorClass.primaryColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
