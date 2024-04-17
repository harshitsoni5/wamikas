import '../../Models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationModel> listOfNotification;
  NotificationSuccess({
    required this.listOfNotification
});
}

class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {}
