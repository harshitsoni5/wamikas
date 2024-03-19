import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackButtonWithLogo extends StatelessWidget {
  const BackButtonWithLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset("assets/svg/ep_back.svg")),
          SvgPicture.asset("assets/svg/w-logo.svg",height: 40,),
        ],
      ),
    );
  }
}
