import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../Routes/route_name.dart';
import '../Text/simple_text.dart';

class HomeAppBar extends StatelessWidget {
  final UserProfileModel userData;
  const HomeAppBar({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                "assets/svg/logo.svg",
                height: 44.h,
                width: 55.w,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleText(
                    text: "Welcome",
                    fontSize: 11.sp,
                    textHeight: 0.8,
                  ),
                  SimpleText(
                    text: userData.name,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/message.svg",
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "assets/svg/notification.svg",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              userData.profilePic==null?
              SvgPicture.asset(
                "assets/svg/profile.svg",
                height: 40,
                width: 40,
              ):
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  userData.profilePic!,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffE8E8E8),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          onTap:(){
                            Navigator.of(context).pushNamed(
                                RouteName.forum,
                                arguments: userData
                            );
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "What’s on your mind",
                              hintStyle: TextStyle(
                                  color: Color(0xff888888)
                              )
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/svg/search.svg",
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
}
