abstract class InterestsState {}

abstract class InterestsActionState extends InterestsState{}

class InterestsInitial extends InterestsState {}

class InterestsLoading extends InterestsState {}

class InterestsSuccess extends InterestsActionState {}

class InterestsNotSelected extends InterestsActionState {}

class InterestsError extends InterestsActionState {}
