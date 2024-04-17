import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../Bloc/CommentsBloc/comments_bloc.dart';
import '../../Bloc/CommentsBloc/comments_event.dart';
import '../../Bloc/CommentsBloc/comments_state.dart';
import '../../Models/post_model.dart';
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

  void _pickedImage(){
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Choose image source'),
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

  String getTimeAgo(String dateString) {
    final postTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}/${postTime.year}";
    }
  }

  String getTime(Timestamp timestamp) {
    final postTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}/${postTime.year}";
    }
  }

  void showBottomSheet({
    required Size size,
    required String postId,
    required UserProfileModel userData,
    required List comments,
    required PostModel postModel,
  }) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              if(state is CommentsSuccess){
                final comments = state.comments;
                return Container(
                  margin:const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  height:size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SimpleText(
                            text: "Most relevant",
                            fontSize: 12.sp,
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data = comments[index];
                              bool isLikeOrNot =false;
                              if (state.comments[index]["likes"]
                                  .contains(userData.phone)) {
                                isLikeOrNot = true;
                              }else{
                                isLikeOrNot=false;
                              }
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: CircleAvatar(
                                          radius: 20,
                                          child:data["profile_pic"] == null?
                                          Image.asset("assets/images/dp.png"):
                                          Image.network(
                                            data["profile_pic"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SimpleText(
                                              text: data["name"],
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SimpleText(
                                              text:
                                              data["comments_desc"],
                                              fontSize: 11.sp,
                                              fontColor: const Color(0xff696969),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6,),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            BlocProvider.of<CommentsBloc>(context).
                                            add(LikeAComment(
                                                postId: postId,
                                                comments: state.comments,
                                                postModel: postModel,
                                                likeOrNot: isLikeOrNot,
                                                commentModel: Comment(
                                                    uid: state.comments[index]
                                                    ["uid"],
                                                    name: state.comments[index]
                                                    ["name"],
                                                    profilePic:
                                                    state.comments[index]
                                                    ["profile_pic"],
                                                    time: state.comments[index]
                                                    ["time"],
                                                    commentsDesc:
                                                    state.comments[index]
                                                    ["comments_desc"],
                                                    likes: state.comments[index]
                                                    ["likes"],
                                                    commentId:
                                                    state.comments[index]
                                                    ["comment_id"])));
                                          },
                                          child: isLikeOrNot
                                              ? SvgPicture.asset(
                                              "assets/svg/like_filled.svg")
                                              : SvgPicture.asset(
                                              "assets/svg/like_wami.svg")),
                                      const SizedBox(width: 5),
                                      SimpleText(text: "Like", fontSize: 10.sp),
                                      const Spacer(),
                                      SimpleText(text: getTime(data["time"]), fontSize: 10.sp),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 15,top: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffDEDEDE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  onSubmitted: (val){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        ReduceBottomSheetSize(
                                            comments: state.comments,
                                            isClicked: false));
                                  },
                                  onTap: (){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        ReduceBottomSheetSize(
                                            comments: state.comments,
                                            isClicked: true));
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Start Typing here",
                                    hintStyle: TextStyle(
                                      color: Color(0xffAFAFAF),
                                      fontSize: 14,
                                    ),
                                  ),
                                  controller: commentsController,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(commentsController.text.isNotEmpty){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        PostAComment(
                                            postId: postId,
                                            commentDesc:
                                            commentsController.text,
                                            uid: userData.phone,
                                            comments: comments,
                                            userData: userData,
                                            postModel: postModel
                                        ));
                                    commentsController.clear();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  child: SvgPicture.asset("assets/svg/message_icon.svg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    final double topPadding = safeAreaInsets.top;
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserProfileSuccess) {
          final UserProfileModel data = state.userData;
          final List<PostModel> posts= state.listOfForums;
          return Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    "assets/svg/rectangle_design.svg",
                    height: size.height >850 ?size.height*0.28 :size.height*0.35,
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                   SimpleText(
                                    text: "My Profile",
                                    fontSize: size.width <390? 20:22,
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
                                                height:size.height >850 ?60:50,
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
                                        padding:  EdgeInsets.symmetric(
                                            horizontal:size.width <390? 25:30, vertical: 5),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 10,
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
                              tabIndex ==2 ?
                              SvgPicture.asset("assets/svg/resources.svg",
                                color: ColorClass.textColor,)
                                  :SvgPicture.asset("assets/svg/resources.svg"),
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
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: [
                           posts.isEmpty?
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset("assets/svg/ghost.svg"),
                               const SimpleText(
                                 text:
                                 "Agh! It’s lonely here \nYou have not created any forum.",
                                 fontSize: 16,
                                 fontColor: Colors.black,
                                 textAlign: TextAlign.center,
                               ),
                               const SizedBox(height: 10,),
                               InkWell(
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
                           ) :
                           ListView.builder(
                                shrinkWrap: true,
                                itemCount: posts.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: const Color(0xff544c4c33),
                                                width: 2
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                data.profilePic==null?
                                                SvgPicture.asset(
                                                  "assets/svg/profile.svg",
                                                  height: 40,
                                                  width: 40,
                                                ):
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(30),
                                                  child: Image.network(
                                                    data.profilePic!,
                                                    height: 40,
                                                    width: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SimpleText(
                                                      text: posts[index].name,
                                                      fontSize: 13.sp,
                                                      textHeight: 0.9,
                                                    ),
                                                    SimpleText(
                                                      text: posts[index].emailId,
                                                      fontSize: 12.sp,
                                                      fontColor: ColorClass.textColor,
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                    Icons.more_vert
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            SimpleText(
                                              text: posts[index].forumName,
                                              fontSize: 9.sp,
                                              fontColor: const Color(0xff455A64),
                                            ),
                                            const SizedBox(height: 5,),
                                            SimpleText(
                                              text: posts[index].forumTitle,
                                              fontSize: 18.sp,
                                              textHeight: 0.9,
                                            ),
                                            const SizedBox(height: 2,),
                                            SimpleText(
                                              text: posts[index].forumContent,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w300,
                                              fontColor: const Color(0xff777777),
                                            ),
                                            const Divider(
                                              color: Color(0xffB5B5B5),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    showBottomSheet(
                                                        size: size,
                                                        postId: posts[index].id,
                                                        userData: state.userData,
                                                        comments: posts[index].comments,
                                                        postModel: posts[index]
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/svg/commentss.svg",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                                posts[index].comments.isNotEmpty?
                                                InkWell(
                                                  onTap: (){
                                                    BlocProvider.of<CommentsBloc>(context)
                                                        .add(CommentsInit(
                                                      comments: posts[index].comments,
                                                      userData: state.userData,

                                                    ));
                                                    showBottomSheet(
                                                        size: size,
                                                        postId: posts[index].id,
                                                        userData: state.userData,
                                                        comments: posts[index].comments,
                                                        postModel: posts[index]
                                                    );
                                                  },
                                                  child:  SimpleText(
                                                      text: "${
                                                          posts[index]
                                                              .comments.length
                                                              .toString()
                                                      } Replies",
                                                      fontSize: 16),
                                                ):
                                                const SizedBox(),
                                                const Spacer(),
                                                SimpleText(
                                                    text: getTimeAgo(posts[index].time),
                                                    fontSize: 16),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15,),
                                  const SimpleText(
                                    text: "Personal Finance",
                                    fontSize: 14,
                                    fontColor: Color(0xff570035),
                                  ),
                                  const SizedBox(height: 5,),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xffCFCFCF),
                                        )
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.asset("assets/images/fianance.png",
                                              fit: BoxFit.cover,),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SimpleText(
                                                  text: "Debt management, and building credit.",
                                                  fontSize: 14),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/svg/ph_video-light.svg",
                                                    height: 15,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(width: 6,),
                                                  const SimpleText(
                                                    text: "By- Shruti Hasan",
                                                    fontSize: 14,
                                                    fontColor: Color(0xffE52A9C),
                                                  )
                                                ],
                                              )
                                            ],
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
    );
  }
}
