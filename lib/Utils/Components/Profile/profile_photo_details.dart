import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'dart:io';
import '../../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../../Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import '../../Color/colors.dart';
import '../../Routes/route_name.dart';
import '../Text/simple_text.dart';

class ProfilePhotoWithDetails extends StatelessWidget {
  final UserProfileModel data;
  final VoidCallback onPressed;
  final bool isEditProfile;
  final bool isPenNeeded;
  const ProfilePhotoWithDetails(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.isPenNeeded,
      required this.isEditProfile});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Stack(
                children: [
                  // Positioned(
                  //   left:0,
                  //   child: SvgPicture.asset("assets/svg/Rectangle 382.svg"),
                  // ),
                  // Positioned(
                  //   right: 0,
                  //   child: SvgPicture.asset("assets/svg/Rectangle 381.svg"),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: size.height >850 ?150:size.height<600? 115:140,
                    width: size.height >850 ?150:size.height<600? 115:140,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(size.height >850 ?90:80),
                        border: Border.all(
                            color: const Color(0xffFF9CEA),
                            width: 12)),
                    child: BlocBuilder<UploadImageCubit,
                        UploadImageState>(
                      builder: (context, state) {
                        if (state is UploadImageLoading) {
                          return const Center(
                            child:
                            CircularProgressIndicator(),
                          );
                        } else if (state is UploadImageSuccess) {
                          return Center(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(size.height >850 ?90:80),
                              child: Image.file(
                                File(state.path!),
                                fit: BoxFit.cover,
                                height: size.height >850 ?150:size.height<600? 115:140,
                                width: size.height >850 ?150:size.height<600? 115:140,
                              ),
                            ),
                          );
                        } else {
                          return data.profilePic == null
                              ? Center(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(
                                  size.height >850 ?90:80),
                              child: SvgPicture.asset(
                                "assets/svg/profile.svg",
                                height:size.height >850 ?60:50,
                              ),
                            ),
                          )
                              : Center(
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius
                                    .circular(80),
                                child: CachedNetworkImage(
                                  imageUrl: data.profilePic! ,
                                  fit: BoxFit.cover,
                                  height: size.height >850 ?150:size.height<600? 115:140,
                                  width: size.height >850 ?150:size.height<600? 115:140,
                                )
                          ),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: size.height >850 ?50:size.height<600? 40:50,
                    child: InkWell(
                      onTap: onPressed,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        height:size.height >850? 50:47,
                        width:size.height >850? 50:47,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(30),
                            color: ColorClass.primaryColor,
                            border: Border.all(
                                color:
                                const Color(0xffFF9CEA),
                                width: 6)),
                        child: SvgPicture.asset(
                          "assets/svg/plus_profile.svg",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SimpleText(
                      text: data.name,
                      fontSize:size.width <390? 16.sp:18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    Row(
                      children: [
                        data.jobTitle != null
                            ? SimpleText(
                          text: data.jobTitle!,
                          fontSize:size.width <390? 13:15,
                          fontColor:
                          const Color(0xff6C6C6C),
                          fontWeight: FontWeight.w300,
                        )
                            : SimpleText(
                          text: "Not Specified",
                          fontSize:size.width <390? 14:16,
                          fontColor:
                          const Color(0xff6C6C6C),
                          fontWeight: FontWeight.w300,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                       isPenNeeded? InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed(
                                  RouteName.jobDescription,
                                  arguments: data);
                            },
                            child:  Icon(
                              Icons.edit,
                              color: const Color(0xff6C6C6C),
                              size: size.width <390? 16:19,
                            )):const SizedBox(),
                      ],
                    ),
                    SimpleText(
                      text: data.phone,
                      fontSize:size.width >390? 13:14,
                      fontColor: const Color(0xff6C6C6C),
                      fontWeight: FontWeight.w500,
                    ),
                    SimpleText(
                      text: data.email,
                      fontSize:size.width <390? 11:13,
                      fontColor: const Color(0xff6C6C6C),
                      fontWeight: FontWeight.w300,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isEditProfile? const SizedBox():InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            RouteName.editProfile,
                            arguments: data
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorClass.primaryColor,
                            borderRadius:
                            BorderRadius.circular(20)),
                        padding:  EdgeInsets.symmetric(
                            horizontal:size.width <390? 25:30, vertical: 5),
                        child:  Center(
                          child: SimpleText(
                            text: 'Edit Profile',
                            fontSize:size.width<390 ?17.5:15,
                            fontColor: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
