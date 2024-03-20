abstract class ContactDetailsState {}

class ContactDetailsInitial extends ContactDetailsState {}

abstract class ContactDetailsActionState extends ContactDetailsState{}

class ContactDetailsLoading extends ContactDetailsState {}

class ContactDetailsSuccess extends ContactDetailsActionState {}

class ContactDetailsError extends ContactDetailsActionState {}

class EmailEmpty extends ContactDetailsActionState{}

class NameEmpty extends ContactDetailsActionState{}

class EmailInvalidState extends ContactDetailsActionState{}
