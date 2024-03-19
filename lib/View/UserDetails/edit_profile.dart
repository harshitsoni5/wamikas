import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Text/simple_text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  "assets/svg/rectangle_design.svg",
                  height: size.height * 0.35,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/ep_back (2).svg",
                                      height: 35,
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                                const SimpleText(
                                  text: "Edit Profile",
                                  fontSize: 24,
                                  fontColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              "assets/svg/w-logo.svg",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      border: Border.all(
                                          color: const Color(0xffFF9CEA),
                                          width: 12)),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 45,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorClass.primaryColor,
                                        border: Border.all(
                                            color: const Color(0xffFF9CEA),
                                            width: 6)),
                                    child: SvgPicture.asset(
                                      "assets/svg/plus_profile.svg",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SimpleText(
                                    text: "Tanveer Fatima",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  SimpleText(
                                    text: "UI/UX Designer",
                                    fontSize: 18,
                                    fontColor: Color(0xff6C6C6C),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  SimpleText(
                                    text: "@tanveer.fatima-9313",
                                    fontSize: 18,
                                    fontColor: Color(0xff386BF6),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: 4,
                    color: ColorClass.primaryColor,
                  ),
                  Flexible(
                    child: Container(
                      color: const Color(0xffFFF0FA),
                      padding: const EdgeInsets.only(left: 10, right: 2),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleText(
                            text: 'Attention',
                            fontSize: 16,
                            fontColor: ColorClass.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          SimpleText(
                            text: "Your profile is currently 85% complete. "
                                "Please update missing information to ensure"
                                " that your profile is fully optimized"
                                " and performs well",
                            fontSize: 14,
                            fontColor: ColorClass.primaryColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            EditProfileTiles(
              tileName: "Contact Details",
              onPressed: () {},
              isLastTile: false,
              widget: Row(
                children: [
                const SizedBox(width: 10,),
                Container(
                  height: 4,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffF2F2F2)
                  ),
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.6, // 85% of the width of the parent
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff0AEE49),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),
                SimpleText(text: "60%", fontSize: 12.sp,fontColor: const Color(0xffB5B5B5),),
              ],),
            ),
            EditProfileTiles(
              tileName: "Job Profile & Description",
              onPressed: () {},
              isLastTile: false,
              widget: Row(
                children: [
                  const SizedBox(width: 10,),
                  Container(
                    height: 4,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffF2F2F2)
                    ),
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.25,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff0AEE49),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SimpleText(text: "25%", fontSize: 12.sp,fontColor: const Color(0xffB5B5B5),),
                ],),
            ),
            EditProfileTiles(
              tileName: "Interests and Preferences",
              onPressed: () {},
              isLastTile: false,
            ),
            EditProfileTiles(
              tileName: "Community Engagement",
              onPressed: () {},
              isLastTile: false,
            ),
            EditProfileTiles(
              tileName: "Privacy Settings",
              onPressed: () {},
              isLastTile: false,
            ),
            EditProfileTiles(
              tileName: "Accessibility",
              onPressed: () {},
              isLastTile: false,
            ),
            EditProfileTiles(
              tileName: "Verification",
              onPressed: () {},
              isLastTile: false,
            ),
            EditProfileTiles(
              tileName: "Feedback and Support",
              onPressed: () {},
              isLastTile: true,
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileTiles extends StatelessWidget {
  final String tileName;
  final VoidCallback onPressed;
  final bool isLastTile;
  final Widget? widget;
  const EditProfileTiles({
    super.key,
    required this.tileName,
    required this.onPressed,
    required this.isLastTile,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Row(
              children: [
                SimpleText(text: tileName, fontSize: 14.sp),
                widget ?? const SizedBox(),
                const Spacer(),
                SvgPicture.asset("assets/svg/forward.svg"),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            isLastTile ? const SizedBox() : const Divider()
          ],
        ),
      ),
    );
  }
}
