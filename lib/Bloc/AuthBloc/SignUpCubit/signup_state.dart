import 'package:firebase_auth/firebase_auth.dart';

abstract class SignupState {}

abstract class SignUpActionState extends SignupState{}

class AuthInitialState extends SignupState {}

class AuthLoadingState extends SignupState {}

class AuthCodeSentState extends SignUpActionState {
  final String verificationId;
  AuthCodeSentState({required this.verificationId});
}

class UserAlreadyExists extends SignUpActionState{}

class UserNotExists extends SignUpActionState{}

class FormNotFilledProperly extends SignUpActionState{}

class AuthCodeVerifiedState extends SignupState {}

class AuthLoggedInState extends SignupState {
  final User firebaseUser;
  AuthLoggedInState(this.firebaseUser);
}

class AuthErrorState extends SignUpActionState {
  final String error;
  AuthErrorState(this.error);
}

class UsernameEmpty extends SignUpActionState{}

class EmailEmpty extends SignUpActionState{}

class PhoneEmpty extends SignUpActionState{}

class EmailInvalid extends SignUpActionState{}

class PhoneInvalid extends SignUpActionState{}
