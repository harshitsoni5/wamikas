import '../../../Models/post_model.dart';
import '../../../Models/resources_model.dart';
import '../../../Models/user_profile_model.dart';

abstract class UserProfileEvent {}

class GetUserDataEvent extends UserProfileEvent{}

class GetUserDataWithoutLoading extends UserProfileEvent{}

class DeletePost extends UserProfileEvent{
  final String postId;
  final List<PostModel> listsOfPost;
  final UserProfileModel userData;
  final List<ResourcesModel> personalFinance;
  final List<ResourcesModel> personalGrowth;
  final int profilePercentage;
  DeletePost({
    required this.postId,
    required this.listsOfPost,
    required this.personalFinance,
    required this.personalGrowth,
    required this.userData,
    required this.profilePercentage,
  });
}
