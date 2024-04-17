import 'package:wamikas/Models/user_profile_model.dart';
import '../../../Models/post_model.dart';
import '../../../Models/resources_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final UserProfileModel userData;
  final int profilePercentage;
  final List<PostModel> listOfForums;
  final List<ResourcesModel> personalFinance;
  final List<ResourcesModel> personalGrowth;
  UserProfileSuccess({
    required this.userData,
    required this.profilePercentage,
    required this.listOfForums,
    required this.personalFinance,
    required this.personalGrowth,
  });
}

class UserProfileError extends UserProfileState {}
