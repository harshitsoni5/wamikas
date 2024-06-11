import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Profile/profile_photo_details.dart';
import 'package:wamikas/Utils/Components/Tiles/attention_widget.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import 'package:wamikas/View/UserDetails/user_profile.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../../Utils/Components/Text/simple_text.dart';

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

  Future<void> showLogoutDialog(BuildContext context, Size size) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          height: size.height * 0.17,
          width: size.width - 30,
          padding:
              const EdgeInsets.only(bottom: 15, left: 20, right: 20, top: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimpleText(
                text: "Log Out",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontColor: Colors.black,
              ),
              const SizedBox(
                height: 5,
              ),
              const SimpleText(
                text: 'Are you sure you want to logout ?',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontColor: Colors.blueGrey,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const SimpleText(
                        text: "Cancel",
                        fontSize: 15,
                        fontColor: ColorClass.primaryColor,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        SharedData.clearPref("phone");
                        SharedData.clearPref("uid");
                        SharedData.clearPref("profile");
                        SharedData.clearPref("name");
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteName.signIn, (route) => false);
                      },
                      child: const SimpleText(
                        text: "Ok",
                        fontSize: 15,
                        fontColor: ColorClass.primaryColor,
                      ))
                ],
              )
            ],
          ),
        ));
      },
    );
  }

  void _pickedImage(Size size){
    showDialog<ImageSource>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height:size.height*0.26,
          width:size.width-30,
          padding: const EdgeInsets.only(bottom: 15,left: 20,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.close,color: Colors.white,),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const SimpleText(
                text: 'Choose image source',
                fontSize: 18,
                fontColor: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CameraButtons(
                    title: "Camera",
                    onPressed: () async {
                      PermissionStatus permission = await Permission.camera.status;
                      if (permission.isGranted) {
                        Navigator.of(context).pop();
                        BlocProvider.of<UploadImageCubit>(context)
                            .uploadPhotoEvent(true);
                      } else if (permission.isDenied) {
                        // If permission is denied, request permission again
                        permission = await Permission.camera.request();
                        if (permission.isGranted) {
                          Navigator.of(context).pop();
                          BlocProvider.of<UploadImageCubit>(context)
                              .uploadPhotoEvent(true);
                        } else {
                          showPermissionDeniedDialog('Camera');
                        }
                      } else {
                        // If permission is neither granted nor denied, request permission
                        permission = await Permission.camera.request();
                        if (permission.isGranted) {
                          Navigator.of(context).pop();
                          BlocProvider.of<UploadImageCubit>(context)
                              .uploadPhotoEvent(true);
                        } else {
                          showPermissionDeniedDialog('Camera');
                        }
                      }
                    },
                    svg: "assets/svg/camera.svg",
                    size: size,
                  ),
                  const SizedBox(width: 20,),
                  CameraButtons(
                    size: size,
                    title: "Gallery",
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
                    svg: "assets/svg/gallery.svg",
                  ),
                ],
              )
            ],
          ),
        ),
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
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                                .add(GetUserDataWithoutLoading());
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
                        fontSize:  size.width <400? 20:22,
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
            ),
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                if(state is UserProfileLoading){
                  return const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
                else if(state is UserProfileSuccess){
                  final UserProfileModel data = state.userData;
                  return Column(
                    children: [
                      ProfilePhotoWithDetails(
                        data: data,
                        onPressed: () {
                          _pickedImage(size);
                        },
                        isEditProfile: true,
                        isPenNeeded: false,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      state.profilePercentage == 100 ? const SizedBox()
                          : AttentionWidget(
                              size: size,
                          profilePercentage: state.profilePercentage),
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
                        widget: state.userData.jobTitle== null && state.userData.education == null
                            ? const Padding(
                          padding: EdgeInsets.only(left: 10,top: 2),
                          child: SimpleText(
                            text: "Not Filled",
                            fontSize: 10,
                            fontColor: ColorClass.primaryColor,
                          ),
                        ):
                        const SizedBox(),
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
                        isLastTile: true,
                        assetName: "assets/svg/tabler_hand-love-you.svg",
                        widget: state.userData.eventsOrGroupRec == null
                            ? const Padding(
                          padding: EdgeInsets.only(left: 10,top: 2),
                          child: SimpleText(
                            text: "Not Selected",
                            fontSize: 10,
                            fontColor: ColorClass.primaryColor,
                          ),
                        ):
                              const SizedBox(),
                      ),
                    ],
                  );
                }
                else{
                  return Center(
                    child: SimpleText(
                      text: 'Server Busy. Please try after sometime',
                      fontSize: 16.sp,
                      fontColor: Colors.black,
                    ),
                  );
                }
              },
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
            highlightColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(assetName)
                    ),
                    SimpleText(text: tileName, fontSize: 14.sp),
                    widget ?? const SizedBox(),
                  ],
                ),
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
