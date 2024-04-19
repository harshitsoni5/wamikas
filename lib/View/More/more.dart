import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Utils/Components/Profile/profile_photo_details.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import '../../Models/user_profile_model.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Tiles/settings_tiles.dart';
import '../../Utils/Routes/route_name.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {

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
        title: const Center(
          child: Text('Choose image source',style: TextStyle(
              fontSize: 16
          ),),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Camera'),
            onPressed: () async {
              PermissionStatus permission = await Permission.camera.status;
              if (permission.isGranted) {
                Navigator.of(context).pop();
                BlocProvider.of<UploadImageCubit>(context).uploadPhotoEvent(true);
              } else if (permission.isDenied) {
                // If permission is denied, request permission again
                permission = await Permission.camera.request();
                if (permission.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context).uploadPhotoEvent(true);
                } else {
                  showPermissionDeniedDialog('Camera');
                }
              } else {
                // If permission is neither granted nor denied, request permission
                permission = await Permission.camera.request();
                if (permission.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context).uploadPhotoEvent(true);
                } else {
                  showPermissionDeniedDialog('Camera');
                }
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
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          UserProfileAppBar(size: size,title: "Settings"),
          const SizedBox(height: 20,),
          Expanded(
            child: BlocConsumer<UserProfileBloc, UserProfileState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if (state is UserProfileSuccess) {
                  final UserProfileModel data = state.userData;
                  return Column(
                    children: [
                      ProfilePhotoWithDetails(
                        data: data,
                        onPressed: (){
                          _pickedImage();
                        },
                        isEditProfile: false,
                      ),
                      const SizedBox(height: 20,),
                      SettingsTiles(
                        tileName: "Privacy Policy",
                        onPressed: () {

                        },
                        isLastTile: true,
                        assetName: "assets/svg/privacy_policy.svg",
                        hideArrow: true,
                      ),
                      const SizedBox(height: 15,),
                      SettingsTiles(
                        tileName: "Terms Of Use",
                        onPressed: () {

                        },
                        isLastTile: true,
                        assetName: "assets/svg/terms_of_use.svg",
                        hideArrow: true,
                      ),
                      const SizedBox(height: 15,),
                      SettingsTiles(
                        tileName: "Logout",
                        onPressed: () {
                          SharedData.clearPref("phone");
                          SharedData.clearPref("uid");
                          SharedData.clearPref("profile");
                          SharedData.clearPref("name");
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteName.signIn, (route) => false);
                        },
                        isLastTile: true,
                        assetName: "assets/svg/logout.svg",
                      ),
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
          ),
        ],
      ),
    );
  }
}
