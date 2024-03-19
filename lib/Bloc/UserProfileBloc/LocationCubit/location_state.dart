abstract class LocationState {}

abstract class LocationActionState extends LocationState{}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationActionState {}

class ForumNotFilledProperly extends LocationActionState {}

class LocationError extends LocationActionState {}
