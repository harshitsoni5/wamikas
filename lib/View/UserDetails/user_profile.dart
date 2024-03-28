import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'dart:io';
import '../../Utils/Routes/route_name.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    BlocProvider.of<UserProfileBloc>(context).add(GetUserDataEvent());
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {});
    super.initState();
  }

  void showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: Text(
              'Permission to access $permissionType is required to use this feature.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _pickedImage(){
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Choose image source'),
        actions: [
          ElevatedButton(
            child: const Text('Camera'),
            onPressed: () async {
              Permission permission = Permission.camera;
              if (await permission.isGranted) {
                Navigator.of(context).pop();
                BlocProvider.of<UploadImageCubit>(context)
                    .uploadPhotoEvent(true);
              } else if (await permission.isDenied) {
                permission = Permission.camera;
                if (await permission.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context)
                      .uploadPhotoEvent(true);
                } else {
                  showPermissionDeniedDialog('Camera');
                }
              } else {
                showPermissionDeniedDialog('Camera');
              }
            },
          ),
          ElevatedButton(
            child: const Text('Gallery'),
            onPressed: () async {
              PermissionStatus status =await Permission.photos.request();
              if ( status.isGranted) {
                Navigator.of(context).pop();
                BlocProvider.of<UploadImageCubit>(context)
                    .uploadPhotoEvent(false);
              } else if ( status.isDenied) {
                status = await Permission.photos.request();
                if ( status.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context)
                      .uploadPhotoEvent(false);
                } else {
                  showPermissionDeniedDialog('Gallery');
                }
              } else {
                showPermissionDeniedDialog('Gallery');
              }
            },
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserProfileSuccess) {
            final UserProfileModel data = state.userData;
            return Column(
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
                                          // Navigator.of(context).pop();
                                        },
                                        child: SvgPicture.asset(
                                          "assets/svg/ep_back (2).svg",
                                          height: 35,
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const SimpleText(
                                      text: "My Profile",
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
                                          borderRadius:
                                              BorderRadius.circular(80),
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
                                          } else if (state
                                              is UploadImageSuccess) {
                                            return Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                child: Image.file(
                                                  File(state.path!),
                                                  fit: BoxFit.cover,
                                                  width: 140,
                                                  height: 140,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return data.profilePic == null
                                                ? Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80),
                                                      child: SvgPicture.asset(
                                                        "assets/svg/profile.svg",
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80),
                                                        child: Image.network(
                                                          data.profilePic!,
                                                          fit: BoxFit.cover,
                                                          width: 140,
                                                          height: 140,
                                                        )),
                                                  );
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: 45,
                                      child: InkWell(
                                        onTap: () {
                                          _pickedImage();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          height: 60,
                                          width: 60,
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      Row(
                                        children: [
                                          data.jobTitle != null
                                              ? SimpleText(
                                                  text: data.jobTitle!,
                                                  fontSize: 16.sp,
                                                  fontColor:
                                                      const Color(0xff6C6C6C),
                                                  fontWeight: FontWeight.w300,
                                                )
                                              : SimpleText(
                                                  text: "Not Specified",
                                                  fontSize: 16.sp,
                                                  fontColor:
                                                      const Color(0xff6C6C6C),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(Icons.edit),
                                        ],
                                      ),
                                      SimpleText(
                                        text: data.phone,
                                        fontSize: 15,
                                        fontColor: const Color(0xff6C6C6C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SimpleText(
                                        text: data.email,
                                        fontSize: 15,
                                        fontColor: const Color(0xff6C6C6C),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 5),
                                          child: const Center(
                                            child: SimpleText(
                                              text: 'Edit Profile',
                                              fontSize: 16,
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
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                state.profilePercentage == 100 ?
                const SizedBox():Container(
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
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SimpleText(
                                text: 'Attention',
                                fontSize: 16,
                                fontColor: ColorClass.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              SimpleText(
                                text: "Your profile is currently ${state.profilePercentage}% complete. "
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
                TabBar(
                  controller: tabController,
                  indicatorColor: ColorClass.primaryColor,
                  tabs: <Widget>[
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/svg/forum.svg"),
                          const SizedBox(
                            width: 5,
                          ),
                          SimpleText(
                            text: 'Forum',
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/svg/events.svg"),
                          const SizedBox(
                            width: 5,
                          ),
                          SimpleText(
                            text: 'Events',
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/svg/resources.svg"),
                          const SizedBox(
                            width: 5,
                          ),
                          SimpleText(
                            text: 'Resources',
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DefaultTabController(
                  length: 2,
                  child: Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/profile.svg",
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SimpleText(
                                    text: "w/graphic_design",
                                    fontSize: 14.sp,
                                    fontColor: ColorClass.userColor,
                                  ),
                                  const Spacer(),
                                  SimpleText(
                                    text: "7 hr. ago",
                                    fontSize: 14.sp,
                                    fontColor: const Color(0xff7C7C7C),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: SimpleText(
                                  text: "I’m guessing not.",
                                  fontSize: 15.sp,
                                  fontColor: const Color(0xff5A5858),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/svg/like_wami.svg"),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SimpleText(text: "Like", fontSize: 15.sp),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SvgPicture.asset("assets/svg/comments.svg"),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SimpleText(
                                        text: "Comment", fontSize: 15.sp),
                                    const Spacer(),
                                    SimpleText(text: "1.2 K", fontSize: 12.sp),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    SvgPicture.asset(
                                      "assets/svg/like_filled.svg",
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SimpleText(text: "2.9 K", fontSize: 12.sp),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    SvgPicture.asset(
                                      "assets/svg/comments_filled.svg",
                                      height: 15,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/svg/profile.svg"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SimpleText(
                                    text: "w/graphic_design",
                                    fontSize: 14.sp,
                                    fontColor: ColorClass.userColor,
                                  ),
                                  const Spacer(),
                                  SimpleText(
                                    text: "7 hr. ago",
                                    fontSize: 14.sp,
                                    fontColor: const Color(0xff7C7C7C),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/profile.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SimpleText(
                                    text: "w/graphic_design",
                                    fontSize: 14.sp,
                                    fontColor: ColorClass.userColor,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: SimpleText(
                text: 'Oops something went wrong',
                fontSize: 16.sp,
                fontColor: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}
