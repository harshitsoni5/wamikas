import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    userData.profilePic==null?
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(RouteName.userProfile);
                      },
                      child: SvgPicture.asset(
                        "assets/svg/profile.svg",
                        height: 35,
                        width: 35,
                      ),
                    ):
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(RouteName.userProfile);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                         imageUrl: userData.profilePic!,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(
                          RouteName.notification
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/notification.svg",

                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 3,),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
