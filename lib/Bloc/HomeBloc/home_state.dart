import '../../Models/event_model.dart';
import '../../Models/post_model.dart';
import '../../Models/user_profile_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState{}

class HomeSuccess extends HomeState{
final List<PostModel> listOfAllPost;
final UserProfileModel userData;
final List<EventModel> workshopData;
final List<EventModel> trendingData;
final List<EventModel> featuredData;
HomeSuccess({
  required this.listOfAllPost,
  required this.userData,
  required this.workshopData,
  required this.trendingData,
  required this.featuredData,
});
}

class HomeError extends HomeState{}

