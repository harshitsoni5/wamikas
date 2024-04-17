import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/notification_model.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future getAllNotification()async{
    emit(NotificationLoading());
    try{
      CollectionReference notificationListReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "notifications");
      CollectionReference usersReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "users");
      var docId = await SharedData.getIsLoggedIn("phone");
      var allNotification =  await notificationListReference.doc(docId).get();
      if(allNotification.exists){
        var allUserNotification = allNotification.data();
        if(allUserNotification != null && allUserNotification is Map){
          List<NotificationModel> listOfNoitify =[];
          for(int i=0;i<allUserNotification["notifications"].length;i++){
            var data =allNotification["notifications"][i];
            var user =await usersReference.doc(data["uid_of_User"]).get();
            if(user.exists){
              var userData = user.data();
              if(userData != null && userData is Map){
                listOfNoitify.add(NotificationModel(
                    id: data["id"],
                    time: data["time"],
                    title: data["title"],
                    uidOfUser: data["uid_of_User"],
                    name: userData["name"],
                    profilePic: userData["profile_pic"]));
              }
            }
          }
          print("yes");
          emit(NotificationSuccess(listOfNotification: listOfNoitify));
        }
      }else{
        emit(NotificationSuccess(listOfNotification: []));
      }
    }
    catch(e){
      print(e.toString());
      emit(NotificationError());
    }
  }
}
