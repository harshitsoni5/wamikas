import 'package:wamikas/Models/user_profile_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final UserProfileModel userData;
  final int profilePercentage;
  UserProfileSuccess({
    required this.userData,
    required this.profilePercentage,
  });
}

class UserProfileError extends UserProfileState {}
