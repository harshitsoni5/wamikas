import 'package:wamikas/Models/user_profile_model.dart';
import '../../Models/post_model.dart';

abstract class CommentsEvent {}

class CommentsInit extends CommentsEvent{
  final List comments;
  final UserProfileModel userData;
  CommentsInit({
    required this.comments,
    required this.userData,
  });
}

class PostAComment extends CommentsEvent{
  final String postId;
  final String commentDesc;
  final String uid;
  final List comments;
  final PostModel postModel;
  final UserProfileModel userData;
  PostAComment({
    required this.postId,
    required this.commentDesc,
    required this.uid,
    required this.comments,
    required this.userData,
    required this.postModel,

  });
}

class ReduceBottomSheetSize extends CommentsEvent {
  final List comments;
  final bool isClicked;
  ReduceBottomSheetSize({
    required this.comments,
    required this.isClicked,
  });
}

class LikeAComment extends CommentsEvent{
  final String postId;
  final List comments;
  final PostModel postModel;
  final Comment commentModel;
  final bool likeOrNot;
  LikeAComment({
    required this.postId,
    required this.comments,
    required this.postModel,
    required this.commentModel,
    required this.likeOrNot,
  });
}

