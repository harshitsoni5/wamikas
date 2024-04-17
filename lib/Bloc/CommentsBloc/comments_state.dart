abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsSuccess extends CommentsState {
  final List comments;
  CommentsSuccess({
    required this.comments,
  });
}

class CommentsError extends CommentsState{}

