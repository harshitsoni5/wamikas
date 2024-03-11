import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Utils/Components/Buttons/back_button_with_logo.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';

import '../../Utils/Color/colors.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const BackButtonWithLogo(),
            SizedBox(
              height: size.height*0.1,
            ),
            Column(
              children: [
                const SimpleText(
                  text: "Upload Photo",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SimpleText(
                  text:
                      "Please upload a Picture to create\n your profile Pic",
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  width: size.width,
                  child: Column(
                    children: [
                      DottedBorder(
                        color: const Color(0xffD2D2D2),
                        dashPattern: const [6, 6, 6, 6],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/upload_photo.png",
                              width:size.width,fit: BoxFit.fitHeight,)),
                      ),
                      const SizedBox(height: 20,),
                      Container(
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
                            Row(
                             children: [
                               SvgPicture.asset("assets/svg/cloud.svg"),
                               const SizedBox(width: 10,),
                               const SimpleText(
                                 text: "Browse",
                                 fontColor: Colors.white,
                                 fontSize: 15,
                                 fontFamily: 'Poppins',
                                 fontWeight: FontWeight.bold,
                               ),
                             ],
                           ),
                            SvgPicture.asset("assets/svg/ep_fwrd.svg"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const SimpleText(
                        text: "Skip >>",
                        fontSize: 15,
                        fontColor: ColorClass.primaryColor,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
