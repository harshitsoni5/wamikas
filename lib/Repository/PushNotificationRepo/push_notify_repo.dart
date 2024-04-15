import '../../NetworkRequest/network_request.dart';

class PushNotification{
  static Future sendPushNotification(String title,String body,String fcmToken)async{
    NetworkRequest networkRequest = NetworkRequest();
    try{
      var result = await networkRequest.postNotificationToFireBase
        ("https://fcm.googleapis.com/fcm/send",
          title,
          body,
        fcmToken
      );
    }
    catch(e){
      print(e.toString());
    }
  }
}
