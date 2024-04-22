import '../../Models/event_model.dart';
import '../../Models/post_model.dart';
import '../../Models/resources_model.dart';
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

class BookmarkResources extends HomeEvent{
  final String id;
  final bool bookmarkOrNot;
  BookmarkResources({
    required this.id,
    required this.bookmarkOrNot
  });
}

class DeletePostEvent extends HomeEvent{
  final String postId;
  final List<PostModel> listsOfPost;
  final UserProfileModel userData;
  final List<EventModel> workshopData;
  final List<EventModel> trendingData;
  final List<EventModel> featuredData;
  final List<ResourcesModel> personalFinance;
  final List<ResourcesModel> personalGrowth;

  DeletePostEvent({
    required this.postId,
    required this.listsOfPost,
    required this.workshopData,
    required this.personalFinance,
    required this.personalGrowth,
    required this.featuredData,
    required this.userData,
    required this.trendingData,
  });
}