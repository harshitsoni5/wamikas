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
  HomePostCommentEvent({
    required this.postId,
    required this.comment
  });
}
