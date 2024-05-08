import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Text/simple_text.dart';

class UserProfileAppBar extends StatelessWidget {
  final String title;
  final bool? isBack;
  const UserProfileAppBar({
    super.key,
    required this.size, required this.title,
    this.isBack
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isBack!= null? InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    "assets/svg/ep_back (2).svg",
                    height: 35,
                  )):const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              SimpleText(
                text: title,
                fontSize: size.width <390? 20:22,
                fontColor: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SvgPicture.asset(
            "assets/svg/logo.svg",
            height: size.width <390? 35:40,
          ),
        ],
      ),
    );
  }
}
