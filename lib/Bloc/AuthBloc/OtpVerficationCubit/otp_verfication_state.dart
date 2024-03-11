abstract class OtpVerificationState {}

abstract class OtpVerificationActionState extends OtpVerificationState{}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationActionState {}

class OtpVerificationUserAlreadyExistsState extends OtpVerificationActionState {}

class OtpVerificationFailed extends OtpVerificationActionState {}

class OtpVerificationError extends OtpVerificationState {}
