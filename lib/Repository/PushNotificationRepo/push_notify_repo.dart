import '../../NetworkRequest/network_request.dart';

class PushNotification {
  static Future<void> sendPushNotification(
      String title, String body, String fcmToken, String postId) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      print(postId);
      var result = await networkRequest.postNotificationToFireBase(
          "https://fcm.googleapis.com/fcm/send", title, body, fcmToken, postId);
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
