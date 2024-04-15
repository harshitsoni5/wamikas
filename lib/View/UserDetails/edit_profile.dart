import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Text/simple_text.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  final UserProfileModel userData;
  const EditProfile({
    super.key,
    required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    BlocProvider.of<UserProfileBloc>(context).add(GetUserDataEvent());
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
    final EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    final double topPadding = safeAreaInsets.top;
    return Scaffold(
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if(state is UserProfileLoading){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(state is UserProfileSuccess){
            final UserProfileModel data = state.userData;
            return Column(
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/rectangle_design.svg",
                      height: size.height >850 ?size.height*0.3 :size.height*0.35,
                    ),
                    Container(
                      padding:  EdgeInsets.only(top: topPadding),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          BlocProvider.of<UserProfileBloc>(
                                                  context)
                                              .add(GetUserDataEvent());
                                        },
                                        child: SvgPicture.asset(
                                          "assets/svg/ep_back (2).svg",
                                          height: 35,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                     SimpleText(
                                      text: "Edit Profile",
                                      fontSize:  size.width <400? 18:22,
                                      fontColor: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  "assets/svg/w-logo.svg",
                                  height: size.width <390? 35:40,
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
                                          } else if (state
                                          is UploadImageSuccess) {
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
                                                    height: size.height >850 ?150:size.height<600? 115:140,
                                                    width: size.height >850 ?150:size.height<600? 115:140,
                                                  )),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: size.height >850 ?50:size.height<600? 40:50,
                                      child: InkWell(
                                        onTap: () {
                                          _pickedImage();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          height:size.height >850? 50:45,
                                          width:size.height >850? 50:45,
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
                                        fontSize: size.width <390? 16.sp:18.sp,
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
                                          InkWell(
                                              onTap: (){
                                                Navigator.of(context).pushNamed(
                                                    RouteName.jobDescription,
                                                    arguments: data);
                                              },
                                              child:  Icon(
                                                Icons.edit,
                                                color: const Color(0xff6C6C6C),
                                                size: size.width <390? 18:20,
                                              )),
                                        ],
                                      ),
                                      SimpleText(
                                        text: data.phone,
                                        fontSize:size.width <390? 13:14,
                                        fontColor: const Color(0xff6C6C6C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SimpleText(
                                        text: data.email,
                                        fontSize: size.width <390?11:13,
                                        fontColor: const Color(0xff6C6C6C),
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
                state.profilePercentage == 100 ?
                const SizedBox():Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Container(
                        height:size.height>850?size.height * 0.1 :size.height * 0.12,
                        width: 4,
                        color: ColorClass.primaryColor,
                      ),
                      Flexible(
                        child: Container(
                          height:size.height>850?size.height * 0.1 :size.height * 0.12,
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
                                text: "Your profile is currently ${state.profilePercentage}% complete. "
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
                ),
                const SizedBox(
                  height: 20,
                ),
                EditProfileTiles(
                  tileName: "Contact Details",
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteName.contactDetails,
                        arguments: data);
                  },
                  isLastTile: false,
                  assetName: "assets/svg/iconamoon_profile-light.svg",
                ),
                EditProfileTiles(
                  tileName: "Job Profile & Description",
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteName.jobDescription,
                        arguments: data);
                  },
                  isLastTile: false,
                  assetName: "assets/svg/bag.svg",
                ),
                EditProfileTiles(
                  tileName: "Interests and Preferences",
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteName.interestAndPref,
                        arguments: data);
                  },
                  isLastTile: false,
                  assetName: "assets/svg/tabler_hand-love-you.svg",
                  widget: state.userData.eventsOrGroupRec == null
                      ? const Padding(
                    padding: EdgeInsets.only(left: 10,top: 2),
                    child: SimpleText(
                      text: "Not Selected",
                      fontSize: 10,
                      fontColor: Color(0xffF72532),
                    ),
                  ):
                        const SizedBox(),
                ),
                EditProfileTiles(
                  tileName: "Logout",
                  onPressed: () {
                    SharedData.clearPref("phone");
                    SharedData.clearPref("uid");
                    SharedData.clearPref("profile");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteName.signIn, (route) => false);
                  },
                  isLastTile: true,
                  assetName: "assets/svg/logout.svg",
                ),
              ],
            );
          }
          else{
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

class EditProfileTiles extends StatelessWidget {
  final String tileName;
  final VoidCallback onPressed;
  final bool isLastTile;
  final Widget? widget;
  final String assetName;
  const EditProfileTiles({
    super.key,
    required this.tileName,
    required this.onPressed,
    required this.isLastTile,
    required this.assetName,
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
          InkWell(
            onTap: onPressed,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(assetName)
                ),
                SimpleText(text: tileName, fontSize: 14.sp),
                widget ?? const SizedBox(),
                const Spacer(),
                SvgPicture.asset("assets/svg/forward.svg"),
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
