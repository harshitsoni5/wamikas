import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/HomeBloc/home_event.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Components/TextField/comment_textfield.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../../Bloc/CommentsBloc/comments_bloc.dart';
import '../../../Bloc/CommentsBloc/comments_event.dart';
import '../../../Bloc/CommentsBloc/comments_state.dart';
import '../../../Models/event_model.dart';
import '../../../Models/post_model.dart';
import '../../../Models/resources_model.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class ForumCard extends StatefulWidget {
  final UserProfileModel userData;
  final List<PostModel> posts;
  final Size size;
  final bool fromProfileScreen;

  const ForumCard(
      {super.key,
      required this.userData,
      required this.posts,
      required this.size,
      required this.fromProfileScreen});

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  TextEditingController commentsController = TextEditingController();
  List<PostModel> localSearch = [];
  bool mostRelevant = false;
  bool isEmpty = false;
  bool isSearching =false;

  final TextEditingController searchController = TextEditingController();

  showBottomSheet({
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -20,
                left: size.width / 2.2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsSuccess) {
                      final comments = state.comments;
                      if (state.comments.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          height: size.height * 0.8,
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
                                  child: CommentTextField(
                                      commentsController: commentsController,
                                      postId: postId,
                                      userData: userData,
                                      comments: comments,
                                      postModel: postModel),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        height: size.height * 0.8,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // GestureDetector(
                            //   onTap: (){
                            //     print(mostRelevant);
                            //     setState(() {
                            //       mostRelevant=!mostRelevant;
                            //     });
                            //   },
                            //   child: Row(
                            //     children: [
                            //       SimpleText(
                            //         text: "Most relevant",
                            //         fontSize: 12.sp,
                            //       ),
                            //       const SizedBox(width: 5),
                            //       const Icon(Icons.keyboard_arrow_down),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    final data = comments[index];
                                    bool isLikeOrNot = false;
                                    if (state.comments[index]["likes"]
                                        .contains(userData.phone)) {
                                      isLikeOrNot = true;
                                    } else {
                                      isLikeOrNot = false;
                                    }
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: CircleAvatar(
                                                radius: 20,
                                                child: data["profile_pic"] ==
                                                        null
                                                    ? SvgPicture.asset(
                                                        "assets/svg/profile.svg",
                                                        height: 30)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            data["profile_pic"],
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SimpleText(
                                                    text: data["name"],
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SimpleText(
                                                    text: data["comments_desc"],
                                                    fontSize: 11.sp,
                                                    fontColor:
                                                        const Color(0xff696969),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  BlocProvider.of<CommentsBloc>(context).add(LikeAComment(
                                                      postId: postId,
                                                      comments: state.comments,
                                                      postModel: postModel,
                                                      likeOrNot: isLikeOrNot,
                                                      commentModel: Comment(
                                                          uid: state.comments[index]
                                                              ["uid"],
                                                          name: state.comments[index]
                                                              ["name"],
                                                          profilePic: state
                                                                  .comments[index]
                                                              ["profile_pic"],
                                                          time: state.comments[index]
                                                              ["time"],
                                                          commentsDesc: state
                                                                  .comments[index]
                                                              ["comments_desc"],
                                                          likes: state.comments[index]
                                                              ["likes"],
                                                          commentId: state
                                                                  .comments[index]
                                                              ["comment_id"])));
                                                },
                                                child: isLikeOrNot
                                                    ? SvgPicture.asset(
                                                        "assets/svg/like_filled.svg",
                                                        height: 15,
                                                      )
                                                    : SvgPicture.asset(
                                                        "assets/svg/like_wami.svg")),
                                            const SizedBox(width: 5),
                                            SimpleText(
                                                text: "Like", fontSize: 10.sp),
                                            const SizedBox(width: 5,),
                                            state.comments[index]["likes"]
                                                    .isNotEmpty
                                                ? SimpleText(
                                                    text: state
                                                        .comments[index]
                                                            ["likes"]
                                                        .length
                                                        .toString(),
                                                    fontSize: 10.sp)
                                                : const SizedBox(),
                                            const Spacer(),
                                            SimpleText(
                                                text: LocalData.getTime(
                                                    data["time"]),
                                                fontSize: 10.sp),
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
                              child: CommentTextField(
                                  commentsController: commentsController,
                                  postId: postId,
                                  userData: userData,
                                  comments: comments,
                                  postModel: postModel),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showBottomSheetOnDeletePost({
    required Size size,
    required String postId,
    required UserProfileModel userData,
    required PostModel postModel,
    required List<PostModel> listsOfPost,
    required List<EventModel> workshopData,
    required List<EventModel> trendingData,
    required List<EventModel> featuredData,
    required List<ResourcesModel> personalFinance,
    required List<ResourcesModel> personalGrowth,
  }) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -50,
                left: size.width / 2.2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: size.height*0.08,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: InkWell(
                    onTap: (){
                      BlocProvider.of<HomeBloc>(context).add(DeletePostEvent(
                          postId: postId,
                          listsOfPost: listsOfPost,
                          workshopData: workshopData,
                          personalFinance: personalFinance,
                          personalGrowth: personalGrowth,
                          featuredData: featuredData,
                          userData: userData,
                          trendingData: trendingData));
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SimpleText(text: "Delete post", fontSize: 15,
                          fontColor: Colors.black,fontWeight: FontWeight.w500,),
                          Icon(Icons.delete,color: Colors.red,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        widget.fromProfileScreen
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffE8E8E8))),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              setState(() {
                                isEmpty = false;
                              });
                              localSearch.clear();
                            } else {
                              setState(() {
                                isEmpty = true;
                              });
                              localSearch = widget.posts
                                  .where((element) => element.forumTitle
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search topics",
                            hintStyle: TextStyle(
                                color: Color(0xffC8C8C8), fontSize: 14)),
                      ),
                    ),
                    searchController.text.isEmpty
                        ? SvgPicture.asset(
                            "assets/svg/search.svg",
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                localSearch = widget.posts;
                              });
                              searchController.text = "";
                            },
                            child: const Icon(Icons.close),
                          )
                  ],
                ),
              ),
        widget.fromProfileScreen
            ? const SizedBox()
            : const SizedBox(
                height: 10,
              ),
        localSearch.isEmpty && isEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 80),
                alignment: Alignment.center,
                child: const SimpleText(
                  text: "No results found",
                  fontSize: 14,
                  fontColor: Colors.black38,
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: localSearch.isEmpty
                    ? widget.posts.length
                    : localSearch.length,
                reverse: true,
                itemBuilder: (context, index) {
                  PostModel postData = localSearch.isEmpty? widget.posts[index]:localSearch[index];
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffE8E8E8)),
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                                        )

                                        // Image.network(
                                        //   widget.posts[index].profilePic!,
                                        //   height: 40,
                                        //   width: 40,
                                        //   fit: BoxFit.cover,
                                        // ),
                                        ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SimpleText(
                                      text: localSearch.isEmpty
                                          ? widget.posts[index].name
                                          : localSearch[index].name,
                                      fontSize: 12.sp,
                                      textHeight: 0.9,
                                    ),
                                    SimpleText(
                                      text: localSearch.isEmpty
                                          ? widget.posts[index].emailId
                                          : localSearch[index].name,
                                      fontSize: 11.5.sp,
                                      fontColor: ColorClass.textColor,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                widget.posts[index].uid == widget.userData.phone
                                    ? GestureDetector(
                                        onTap: () {
                                          showBottomSheetOnDeletePost(
                                              size: widget.size,
                                              postId: widget.posts[index].id,
                                              userData: widget.userData,
                                              postModel: widget.posts[index],
                                              listsOfPost: widget.posts,
                                              workshopData: LocalData.workshopEvents,
                                              trendingData: LocalData.trendingEvents,
                                              featuredData: LocalData.featuredEvents,
                                              personalFinance: LocalData.personalFinance,
                                              personalGrowth: LocalData.personalGrowth);
                                        },
                                        child: const Icon(Icons.more_vert))
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SimpleText(
                              text: localSearch.isNotEmpty
                                  ? localSearch[index].forumName
                                  : widget.posts[index].forumName,
                              fontSize: 9.sp,
                              fontColor: const Color(0xff455A64),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SimpleText(
                              text: localSearch.isEmpty
                                  ? widget.posts[index].forumTitle
                                  : localSearch[index].forumTitle,
                              fontSize: 14.sp,
                              textHeight: 0.9,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            ReadMoreText(
                              localSearch.isEmpty
                                  ? widget.posts[index].forumContent
                                  : localSearch[index].forumContent,
                              trimMode: TrimMode.Line,
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff777777)),
                              trimLines: 4,
                              colorClickableText: ColorClass.textColor,
                              trimCollapsedText: ' Read more',
                              trimExpandedText: ' Read less',
                              lessStyle: GoogleFonts.roboto(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w300,
                                  color: ColorClass.textColor),
                              moreStyle: GoogleFonts.roboto(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w300,
                                  color: ColorClass.textColor),
                            ),
                            const Divider(
                              color: Color(0xffB5B5B5),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<CommentsBloc>(context)
                                        .add(CommentsInit(
                                      comments: localSearch.isEmpty
                                          ? widget.posts[index].comments
                                          : localSearch[index].comments,
                                      userData: widget.userData,
                                    ));
                                    showBottomSheet(
                                        size: widget.size,
                                        postId: localSearch.isEmpty
                                            ? widget.posts[index].id
                                            : localSearch[index].id,
                                        userData: widget.userData,
                                        comments: localSearch.isEmpty
                                            ? widget.posts[index].comments
                                            : localSearch[index].comments,
                                        postModel: localSearch.isEmpty
                                            ? widget.posts[index]
                                            : localSearch[index]);
                                  },
                                  child: localSearch.isEmpty
                                      ? Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/commentss.svg",
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            widget.posts[index].comments
                                                    .isNotEmpty
                                                ? SimpleText(
                                                    text:
                                                        "${widget.posts[index].comments.length.toString()} Comments",
                                                    fontSize: 11.5.sp)
                                                : const SizedBox(),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/commentss.svg",
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            localSearch[index].comments.isNotEmpty
                                                ? SimpleText(
                                                    text:
                                                        "${localSearch[index].comments.length.toString()} Comments",
                                                    fontSize: 11.5.sp)
                                                : const SizedBox(),
                                          ],
                                        ),
                                ),
                                const Spacer(),
                                SimpleText(
                                    text: LocalData.getTimeAgo(
                                        localSearch.isEmpty
                                            ? widget.posts[index].time
                                            : localSearch[index].time),
                                    fontSize: 12.sp),
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
