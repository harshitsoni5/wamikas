import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/post_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../../Bloc/CommentsBloc/comments_bloc.dart';
import '../../../Bloc/CommentsBloc/comments_event.dart';

class CommentTextField extends StatelessWidget {
  final TextEditingController commentsController;
  final String postId;
  final UserProfileModel userData;
  final List comments;
  final PostModel postModel;

  const CommentTextField(
      {super.key,
      required this.commentsController,
      required this.postId,
      required this.userData,
      required this.comments,
      required this.postModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: const Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: const Color(0xffDEDEDE))),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 5, bottom: 4),
                hintText: "Start typing here",
                hintStyle: TextStyle(
                  color: Color(0xffAFAFAF),
                  fontSize: 13,
                ),
              ),
              controller: commentsController,
            ),
          ),
          InkWell(
            onTap: () {
              if (commentsController.text.isNotEmpty) {
                BlocProvider.of<CommentsBloc>(context).add(PostAComment(
                    postId: postId,
                    commentDesc: commentsController.text,
                    uid: userData.phone,
                    comments: comments,
                    userData: userData,
                    postModel: postModel));
                commentsController.clear();
              }
            },
            child: CircleAvatar(
              backgroundColor: const Color(0xffE52A9C),
              radius: 16,
              child: SvgPicture.asset(
                "assets/svg/message_icon.svg",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
