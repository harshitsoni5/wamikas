abstract class JobDescriptionState {}

class JobDescriptionInitial extends JobDescriptionState {}

abstract class JobDescActionState extends JobDescriptionState {}

class JobDescLoadingState extends JobDescriptionState {}

class JobDescSuccessState extends JobDescriptionState {}

class JobDescErrorState extends JobDescActionState {}

class JobDescNotFilledState extends JobDescActionState {}
