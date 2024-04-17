abstract class ForumUserState {}

class ForumUserInitial extends ForumUserState {}

class ForumUserLoading extends ForumUserState {}

class ForumUserSuccess extends ForumUserState{
  final String name;
  final String? profilePic;
  final String uid;
  ForumUserSuccess({
    required this.name,
    required this.profilePic,
    required this.uid,
});
}
