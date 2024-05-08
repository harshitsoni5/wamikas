import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/TabBarChildrens/forums_card.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../Models/post_model.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/Profile/profile_photo_details.dart';
import '../../Utils/Components/Tiles/attention_widget.dart';
import '../../Utils/Components/Tiles/resources_card.dart';
import '../../Utils/Routes/route_name.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabIndex=0;
  TextEditingController commentsController =TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UserProfileBloc>(context).add(GetUserDataEvent());
    tabController = TabController(length: 2, vsync: this);
    if(tabController.indexIsChanging){
      tabIndex=tabController.index;
      setState(() {});
    }
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            UserProfileAppBar(size: size,title: "My Profile",isBack: true,),
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
                    final List<PostModel> posts= state.listOfForums;
                    return Column(
                      children: [
                        ProfilePhotoWithDetails(
                          data: data,
                          onPressed: (){
                            _pickedImage(size);
                          },
                          isEditProfile: false, isPenNeeded: false,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.profilePercentage == 100 ?
                              const SizedBox(): AttentionWidget(
                                      size: size,
                                      profilePercentage:
                                          state.profilePercentage,
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              TabBar(
                                controller: tabController,
                                indicatorColor: ColorClass.textColor,
                                labelStyle: const TextStyle(color: ColorClass.textColor),
                                unselectedLabelColor: const Color(0xffB5B5B5),
                                tabs: <Widget>[
                                  Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        tabIndex ==0 ?
                                        SvgPicture.asset("assets/svg/forum.svg"):
                                        SvgPicture.asset("assets/svg/forum.svg",
                                          color: const Color(0xffB5B5B5),),
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
                                        tabIndex == 2
                                            ? SvgPicture.asset(
                                                "assets/svg/resources.svg",
                                                color: ColorClass.textColor,
                                              )
                                            : SvgPicture.asset(
                                                "assets/svg/resources.svg"),
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
                                length: 1,
                                child: Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    color: const Color(0xffF0F0F0),
                                    child: TabBarView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      controller: tabController,
                                      children: [
                                       posts.isEmpty?
                                       SvgShowOnEmpty(
                                           data: data, size: size,
                                         svg:"assets/svg/ghost.svg",
                                         title: "You have not created any forum",
                                         isResources: false,
                                       ) :
                                       ForumCard(
                                                userData: data,
                                                posts: posts,
                                                size: size,
                                                fromProfileScreen: true,
                                              ),
                                        // You have not saved any Resource.
                                        // assets/svg/empty_resources.svg
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10,),
                                             LocalData.bookmarked.isEmpty?
                                             Expanded(
                                               child: Center(
                                                 child: Column(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     SvgPicture.asset("assets/svg/empty_resources.svg"),
                                                     const SimpleText(
                                                       text:
                                                       "Agh! It’s lonely here \nYou have not saved any Resources.",
                                                       fontSize: 16,
                                                       fontColor: Colors.black,
                                                       textAlign: TextAlign.center,
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ):ResourcesCard(
                                                list: LocalData.bookmarked,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
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
            ),
          ],
        ),
      ),
    );
  }
}

class CameraButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String svg;
  final Size size;
  const CameraButtons({
    super.key,
    required this.onPressed,
    required this.title,
    required this.svg, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width/3.5,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF9B1065), Color(0xFFFF30C5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svg,height: 30,width: 30,),
            const SizedBox(height: 10),
            SimpleText(text: title, fontSize: 15,fontColor: Colors.white,),
          ],
        ),
      ),
    );
  }
}

class SvgShowOnEmpty extends StatelessWidget {
  final String title;
  final String svg;
  final bool isResources;
  const SvgShowOnEmpty({
    super.key,
    required this.data,
    required this.size,
    required this.title,
    required this.svg,
    required this.isResources,
  });

  final UserProfileModel data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(svg),
         SimpleText(
          text: "Agh! It’s lonely here \n$title",
          fontSize: 16,
          fontColor: Colors.black,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10,),
       isResources? const SizedBox():InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(
              RouteName.forum,
              arguments: data,
            );
          },
          child: Container(
            width: size.width/2,
            margin:
            const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xff9B1065),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorClass.primaryColor,
              ),
            ),
            padding:
            const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: SimpleText(
                text: "Create a forum",
                fontColor: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        )
      ],
    );
  }
}

