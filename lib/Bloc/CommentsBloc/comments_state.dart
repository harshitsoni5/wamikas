abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState{}

class CommentsSuccess extends CommentsState {
  final List comments;
  final bool isClicked;
  CommentsSuccess({
    required this.comments,
    required this.isClicked,
  });
}

class CommentsError extends CommentsState{}

