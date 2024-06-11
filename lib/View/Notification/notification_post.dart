import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Bloc/NotficationPost/notification_post_cubit.dart';
import 'package:wamikas/Bloc/NotficationPost/notification_post_state.dart';
import '../../Bloc/CommentsBloc/comments_bloc.dart';
import '../../Bloc/CommentsBloc/comments_event.dart';
import '../../Models/post_model.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Text/simple_text.dart';

class NotificationPost extends StatefulWidget {
  final String postId;
  const NotificationPost({super.key, required this.postId});
  @override
  State<NotificationPost> createState() => _NotificationPostState();
}

class _NotificationPostState extends State<NotificationPost> {
  List<bool> isLiked = [];

  String getTime(var timestamp) {
    var postTime;
    if (timestamp is Timestamp) {
      postTime = timestamp.toDate();
    } else {
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

  @override
  void initState() {
    BlocProvider.of<NotificationPostCubit>(context)
        .getPost(postId: widget.postId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0,top: 15,bottom: 15),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset("assets/svg/ep_back (2).svg")),
                  const SizedBox(width: 15,),
                  const SimpleText(
                    text: "Recent Comment's",
                    fontSize: 22,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),

            BlocBuilder<NotificationPostCubit, NotificationPostState>(
              builder: (context, state) {
                if (state is NotificationPostLoading) {
                  return  Container(
                    height: size.height/1.5,
                    alignment: Alignment.center,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                else if (state is NotificationPostSuccess) {
                  final postData = state.postModel;
                  if (isLiked.isEmpty) {
                    isLiked = List.generate(postData.comments.length, (index) => false);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    postData.profilePic == null
                                        ? SvgPicture.asset(
                                      "assets/svg/profile.svg",
                                      height: 40,
                                      width: 40,
                                    )
                                        : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        postData.profilePic!,
                                        progressIndicatorBuilder: (context,
                                            url, downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress
                                                    .progress),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                        height: 40.0,
                                        width: 40.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SimpleText(
                                          text: postData.name,
                                          fontSize: 13.sp,
                                          textHeight: 0.9,
                                        ),
                                        SimpleText(
                                          text: postData.emailId,
                                          fontSize: 12.sp,
                                          fontColor: ColorClass.textColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                SimpleText(
                                  text: postData.forumName,
                                  fontSize: 9.sp,
                                  fontColor: const Color(0xff455A64),
                                ),
                                const SizedBox(height: 5,),
                                SimpleText(
                                  text: postData.forumTitle,
                                  fontSize: 18.sp,
                                  textHeight: 0.9,
                                ),
                                const SizedBox(height: 2,),
                                SimpleText(
                                  text: postData.forumContent,
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
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/commentss.svg",
                                            height: 15,
                                            width: 15,
                                          ),
                                          const SizedBox(width: 5,),
                                          postData.comments.isNotEmpty?
                                          SimpleText(
                                              text: "${
                                                  postData.comments.length.toString()
                                              } Replies",
                                              fontSize: 16):
                                          const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    SimpleText(
                                        text: getTime(postData.time),
                                        fontSize: 16),
                                  ],
                                ),
                                const Divider(),
                                ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemCount: postData.comments.length,
                                    itemBuilder: (context,index){
                                      final commentData= postData.comments[index];
                                      return SizedBox(
                                        width: size.width,
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(40),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    child:commentData["profile_pic"] == null?
                                                    Image.asset("assets/images/dp.png"):
                                                    Image.network(
                                                      commentData["profile_pic"],
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
                                                        text: commentData["name"],
                                                        fontSize: 11.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      SimpleText(
                                                        text:
                                                        commentData["comments_desc"],
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
                                                  onTap: () {
                                                    setState(() {
                                                      isLiked[index] = !isLiked[index];
                                                    });
                                                    BlocProvider.of<CommentsBloc>(context).add(
                                                      LikeAComment(
                                                        postId: widget.postId,
                                                        comments: postData.comments,
                                                        postModel:postData,
                                                        likeOrNot: isLiked[index], // Pass the like/dislike state
                                                        commentModel: Comment(
                                                          uid: commentData["uid"],
                                                          name: commentData["name"],
                                                          profilePic: commentData["profile_pic"],
                                                          time: commentData["time"],
                                                          commentsDesc: commentData["comments_desc"],
                                                          likes: commentData["likes"],
                                                          commentId: commentData["comment_id"],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    isLiked[index]
                                                        ? "assets/svg/like_filled.svg"
                                                        : "assets/svg/like_wami.svg",
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                SimpleText(text: "Like", fontSize: 10.sp),
                                                const Spacer(),
                                                SimpleText(
                                                  text: getTime(commentData["time"]),
                                                  fontSize: 10.sp,
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            )
                        ),
                      ],
                    ),
                  );
                }
                else if(state is PostRemovedByUser){
                  return const Center(
                    child: SimpleText(
                      text: "Post is removed by the user",
                      fontSize: 16,
                    ),
                  );
                }
                else {
                  return const Center(
                    child: SimpleText(
                      text: "oops Something went wrong",
                      fontSize: 16,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
