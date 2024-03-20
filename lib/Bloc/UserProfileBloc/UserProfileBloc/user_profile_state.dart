import 'package:wamikas/Models/user_profile_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final UserProfileModel userData;
  UserProfileSuccess({required this.userData});
}

class UserProfileError extends UserProfileState {}
