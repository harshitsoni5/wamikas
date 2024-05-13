abstract class OtpVerificationState {}

abstract class OtpVerificationActionState extends OtpVerificationState{}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpResendSuccessState extends OtpVerificationActionState {
  final String? verificationId;
  OtpResendSuccessState({required this.verificationId});
}

class OtpResendFailed extends OtpVerificationActionState{}

class OtpNotFilled extends OtpVerificationActionState{}

class OtpVerificationSuccess extends OtpVerificationActionState {}

class OtpVerificationUserAlreadyExistsState extends OtpVerificationActionState {}

class OtpVerificationFailed extends OtpVerificationActionState {}

class OtpVerificationError extends OtpVerificationState {}
