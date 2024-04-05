abstract class ForumState {}

abstract class ForumActionState extends ForumState{}

class ForumInitial extends ForumState {}

class ForumLoading extends ForumState {}

class ForumSuccess extends ForumActionState {}

class ForumError extends ForumActionState {}

class ForumNotSelected extends ForumActionState {}

class ForumDescriptionMissing extends ForumActionState {}

class ForumHeadlinesMissing extends ForumActionState {}
