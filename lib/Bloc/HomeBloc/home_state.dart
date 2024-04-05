import '../../Models/post_model.dart';
import '../../Models/user_profile_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState{}

class HomeSuccess extends HomeState{
final List<PostModel> listOfAllPost;
final UserProfileModel userData;
HomeSuccess({
  required this.listOfAllPost,
  required this.userData,
});
}

class HomeError extends HomeState{}

