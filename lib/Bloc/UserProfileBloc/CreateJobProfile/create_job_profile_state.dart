abstract class CreateJobProfileState {}

abstract class CreateJobProfileActionState extends CreateJobProfileState{}

class CreateJobProfileInitial extends CreateJobProfileState {}

class CreateJobProfileLoading extends CreateJobProfileState {}

class CreateJobProfileSuccess extends CreateJobProfileActionState {}

class CreateJobProfileFormNotFilledState extends CreateJobProfileActionState {}

class CreateJobProfileError extends CreateJobProfileActionState {}
