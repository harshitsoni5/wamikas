import 'package:wamikas/Models/post_model.dart';

abstract class NotificationPostState {}

class NotificationPostInitial extends NotificationPostState {}

class NotificationPostLoading extends NotificationPostState {}

class NotificationPostSuccess extends NotificationPostState {
  final PostModel postModel;
  NotificationPostSuccess({
    required this.postModel
});
}

class NotificationError extends NotificationPostState{}
