import '../../Models/user_profile_model.dart';

abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent{}

class HomePostLikeEvent extends HomeEvent{
  final String postId;
  final bool likeOrNot;
  HomePostLikeEvent({
    required this.postId,
    required this.likeOrNot
  });
}

class HomePostCommentEvent extends HomeEvent{
  final String postId;
  final String comment;
  final String uid;
  HomePostCommentEvent({
    required this.postId,
    required this.comment,
    required this.uid,
  });
}


class SearchTopicsEvent extends HomeEvent{
  final String text;
  SearchTopicsEvent({
    required this.text,
  });
}