abstract class FeedbackState {}

abstract class FeedBackActionState extends FeedbackState{}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState{}

class FeedBackSuccess extends FeedBackActionState{}

class FeedBackName extends FeedBackActionState{}

class FeedbackEmailEmpty extends FeedBackActionState{}

class FeedbackExperience extends FeedBackActionState{}

class FeedbackError extends FeedBackActionState{}




