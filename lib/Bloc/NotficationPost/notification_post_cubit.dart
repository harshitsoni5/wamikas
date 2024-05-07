import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/post_model.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import 'notification_post_state.dart';

class NotificationPostCubit extends Cubit<NotificationPostState> {
  NotificationPostCubit() : super(NotificationPostInitial());

  Future getPost({required String postId}) async {
    emit(NotificationPostLoading());
    try {
      CollectionReference reference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "users");
      CollectionReference postReference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "posts");
      var querySnapshot = await postReference.doc(postId).get();
      if (querySnapshot.exists) {
        print("vhghg");
        var postData = querySnapshot.data();
        if (postData != null && postData is Map) {
          var snapshot = await reference.doc(postData["uid"]).get();
        if(snapshot.exists){
          var userData = snapshot.data();
          if(userData != null && userData is Map){
            emit(NotificationPostSuccess(
                postModel: PostModel(
                    forumContent: postData["forum_content"],
                    forumName: postData["forum_name"],
                    forumTitle: postData["forum_title"],
                    time: postData["time"],
                    uid: postData["uid"],
                    comments: postData["comments"],
                    like: postData["like"],
                    emailId: userData["email"],
                    name: userData["name"],
                    id: postData["id"],
                    profilePic: userData["profile_pic"])));
          }else{
            emit(NotificationError());
          }
        }
        }
        else{
          emit(NotificationError());
        }
      }else{
       emit(PostRemovedByUser());
      }
    } catch (e) {
      print(e.toString());
      emit(NotificationError());
    }
  }
}
