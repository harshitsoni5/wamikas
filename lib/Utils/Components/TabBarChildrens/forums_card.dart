import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../../Bloc/CommentsBloc/comments_bloc.dart';
import '../../../Bloc/CommentsBloc/comments_event.dart';
import '../../../Bloc/CommentsBloc/comments_state.dart';
import '../../../Models/post_model.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class ForumCard extends StatefulWidget {
  final UserProfileModel userData;
  final List<PostModel> posts;
  final Size size;

  const ForumCard(
      {super.key,
      required this.userData,
      required this.posts, required this.size});

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  TextEditingController commentsController =TextEditingController();
  List<PostModel> localSearch =[];
  String getTimeAgo(String dateString) {
    final postTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    }
    else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}";
    }
  }
  String getTime(var timestamp) {
    final postTime;
    if(timestamp is Timestamp){
      postTime = timestamp.toDate();
    }else{
       postTime = DateTime.parse(timestamp.toString());
    }
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
      return "${postTime.day}/${postTime.month}";
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
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                if(state is CommentsSuccess){
                  final comments = state.comments;
                  if(state.comments.isEmpty){
                    return Container(
                      margin:const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      height:size.height*0.8,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Center(
                              child: SimpleText(
                                text: "No comments yet",
                                fontSize: 18,
                                fontColor: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                margin: const EdgeInsets.only(bottom: 15,top: 10),
                                decoration: BoxDecoration(
                                    color:const Color(0xffF4F4F4),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: const Color(0xffDEDEDE)
                                    )
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
                                        backgroundColor: const Color(0xffE52A9C),
                                        radius: 20,
                                        child: SvgPicture.asset("assets/svg/message_icon.svg",
                                        color: Colors.white,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    margin:const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    height:size.height*0.8,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.only(bottom: 15,top: 10),
                            decoration: BoxDecoration(
                                color:const Color(0xffF4F4F4),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: const Color(0xffDEDEDE)
                                )
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
                                    backgroundColor: const Color(0xffE52A9C),
                                    radius: 20,
                                    child: SvgPicture.asset("assets/svg/message_icon.svg",
                                      color: Colors.white,),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 15),
          margin: const EdgeInsets.symmetric(
              horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                  color: const Color(0xff544c4c33),
                  width: 2
              )
          ),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      if(value.isEmpty){
                        localSearch.clear();
                      }
                      localSearch = widget.posts
                          .where((element) => element.forumTitle
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search topics",
                      hintStyle: TextStyle(
                          color: Color(0xffC8C8C8),
                          fontSize: 14
                      )
                  ),
                ),
              ),
              SvgPicture.asset("assets/svg/search.svg")
            ],
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: localSearch.isEmpty?widget.posts.length:localSearch.length,
            reverse: true,
            itemBuilder: (context,index){
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
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
                            widget.userData.profilePic==null?
                            SvgPicture.asset(
                              "assets/svg/profile.svg",
                              height: 40,
                              width: 40,
                            ):
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.userData.profilePic!,
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
                                  text: widget.posts[index].name,
                                  fontSize: 13.sp,
                                  textHeight: 0.9,
                                ),
                                SimpleText(
                                  text: widget.posts[index].emailId,
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
                          text: localSearch.isNotEmpty
                              ? localSearch[index].forumName
                              : widget.posts[index].forumName,
                          fontSize: 9.sp,
                          fontColor: const Color(0xff455A64),
                        ),
                        const SizedBox(height: 5,),
                        SimpleText(
                          text:localSearch.isEmpty?
                          widget.posts[index].forumTitle:
                          localSearch[index].forumTitle,
                          fontSize: 18.sp,
                          textHeight: 0.9,
                        ),
                        const SizedBox(height: 2,),
                        SimpleText(
                          text:localSearch.isEmpty?
                          widget.posts[index].forumContent:
                          localSearch[index].forumContent,
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
                              onTap:(){
                                BlocProvider.of<CommentsBloc>(context)
                                    .add(CommentsInit(
                                  comments:localSearch.isEmpty? widget.posts[index].comments:
                                  localSearch[index].comments,
                                  userData: widget.userData,

                                ));
                                showBottomSheet(
                                    size: widget.size,
                                    postId:localSearch.isEmpty? widget.posts[index].id:
                                    localSearch[index].id,
                                    userData:widget.userData,
                                    comments: localSearch.isEmpty? widget.posts[index].comments:
                                    localSearch[index].comments,
                                    postModel: localSearch.isEmpty?
                                    widget.posts[index]:localSearch[index]
                                );
                              },
                              child:localSearch.isEmpty? Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/commentss.svg",
                                    height: 15,
                                    width: 15,
                                  ),
                                  const SizedBox(width: 5,),
                                  widget.posts[index].comments.isNotEmpty?
                                      SimpleText(
                                      text: "${
                                          widget.posts[index]
                                              .comments.length
                                              .toString()
                                      } Replies",
                                      fontSize: 16):
                                  const SizedBox(),
                                ],
                              ):Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/commentss.svg",
                                    height: 15,
                                    width: 15,
                                  ),
                                  const SizedBox(width: 5,),
                                  localSearch[index].comments.isNotEmpty?
                                  SimpleText(
                                      text: "${
                                          localSearch[index]
                                              .comments.length
                                              .toString()
                                      } Replies",
                                      fontSize: 16):
                                  const SizedBox(),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SimpleText(
                                text: getTimeAgo(localSearch.isEmpty?
                                widget.posts[index].time:localSearch[index].time),
                                fontSize: 16),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }
}
