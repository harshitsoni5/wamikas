import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../Repository/PushNotificationRepo/push_notify_repo.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<CommentsInit>(commentsInit);
    on<PostAComment>(postAComment);
    on<LikeAComment>(likeAComment);
  }

  FutureOr<void> commentsInit(
      CommentsInit event, Emitter<CommentsState> emit) async {
    emit(CommentsSuccess(
      comments: event.comments,
    ));
  }

  FutureOr<void> postAComment(
      PostAComment event, Emitter<CommentsState> emit) async {
      CollectionReference postReference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "posts");
      CollectionReference usersReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "users");
      var docId = await SharedData.getIsLoggedIn("phone");
      var postDetails = await postReference.doc(event.postId).get();
      if (postDetails.exists) {
        var postData = postDetails.data();
        var uuid = const Uuid();
        if (postData != null && postData is Map) {
          List comments = event.comments;
          comments.add({
            "comments_desc": event.commentDesc,
            "likes": [],
            "name": event.userData.name,
            "profile_pic": event.userData.profilePic,
            "time": DateTime.now(),
            "uid": event.uid,
            "comment_id": uuid.v4()
          });
          emit(CommentsSuccess(
            comments: comments,
          ));
          await FireStoreDataBaseServices.setDataToUserCollection(
              "posts", event.postId, {
            "comments": comments,
            "uid": postData["uid"],
            "forum_name": event.postModel.forumName,
            "forum_title": event.postModel.forumTitle,
            "forum_content": event.postModel.forumContent,
            "like": [],
            "time": event.postModel.time,
            "id": event.postModel.id
          });
          //event uid h ki jo uss post par comment mar raha h
          //post["uid"] ki jo actual post jisne bnaya h
          var usersRef = await usersReference.doc(event.uid).get();
          var actualPostRefUser =
              await usersReference.doc(postData["uid"]).get();
          var usersData = usersRef.data();
          var postUserData = actualPostRefUser.data();
          if (postUserData != null &&
              postUserData is Map &&
              usersData != null &&
              usersData is Map &&
              event.uid != event.postModel.uid) {
            await PushNotification.sendPushNotification("New comment",
                  "${usersData["name"]} post a comment on your forum",
                  postUserData["fcm_token"],event.postId);
              String documentId = await SharedData.getIsLoggedIn("phone");
              CollectionReference notificationListReference =
              await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
                  "notifications");
              var notiList = await notificationListReference.doc(docId).get();
              if(notiList.exists){
                var notiData = notiList.data();
                if(notiData!= null && notiData is Map){
                  var localNotiData = notiData;
                  localNotiData["notifications"].add({
                    "uid_of_User": documentId,
                    "title": event.commentDesc,
                    "time": DateTime.now(),
                    "id":event.postId
                  });
                  await FireStoreDataBaseServices.setDataToUserCollection(
                      "notifications", event.postModel.uid,{
                   "notifications":localNotiData["notifications"]
                  });
                }
              }else{
                await FireStoreDataBaseServices.setDataToUserCollection(
                    "notifications",event.postModel.uid,{
                  "notifications":[
                    {
                      "uid_of_User": documentId,
                      "title": event.commentDesc,
                      "time": DateTime.now(),
                      "id":event.postId
                    }
                  ]
                });
              }
            }
        }
      }
  }
  FutureOr<void> likeAComment(
      LikeAComment event, Emitter<CommentsState> emit) async {
    try {
      CollectionReference postReference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "posts");
      var postDetails = await postReference.doc(event.postId).get();
      if (postDetails.exists) {
        var docId = await SharedData.getIsLoggedIn("phone");
        var postData = postDetails.data();
        if (postData != null && postData is Map) {
          List comments = event.comments;
          int index = 0;
          for (int i = 0; i < comments.length; i++) {
            if (event.commentModel.commentId == comments[i]["comment_id"]) {
              break;
            }
            index++;
          }
          if (event.likeOrNot == false) {
            comments.removeAt(index);
            List likesAdded = event.commentModel.likes;
            likesAdded.add(docId);
            comments.insert(index, {
              "comments_desc": event.commentModel.commentsDesc,
              "likes": likesAdded,
              "name": event.commentModel.name,
              "profile_pic": event.commentModel.profilePic,
              "time": event.commentModel.time,
              "uid": event.commentModel.uid,
              "comment_id": event.commentModel.commentId
            });
            FireStoreDataBaseServices.setDataToUserCollection(
                "posts", event.postId, {
              "comments": comments,
              "uid": event.postModel.uid,
              "forum_name": event.postModel.forumName,
              "forum_title": event.postModel.forumTitle,
              "forum_content": event.postModel.forumContent,
              "like": [],
              "time": event.postModel.time,
              "id": event.postModel.id
            });
          } else {
            comments.removeAt(index);
            List likesAdded = event.commentModel.likes;
            for (int i = 0; i < likesAdded.length; i++) {
              if (docId == likesAdded[i]) {
                likesAdded.removeAt(i);
              }
            }
            comments.insert(index, {
              "comments_desc": event.commentModel.commentsDesc,
              "likes": likesAdded,
              "name": event.commentModel.name,
              "profile_pic": event.commentModel.profilePic,
              "time": event.commentModel.time,
              "uid": event.commentModel.uid,
              "comment_id": event.commentModel.commentId
            });
            FireStoreDataBaseServices.setDataToUserCollection(
                "posts", event.postId, {
              "comments": comments,
              "uid": event.postModel.uid,
              "forum_name": event.postModel.forumName,
              "forum_title": event.postModel.forumTitle,
              "forum_content": event.postModel.forumContent,
              "like": [],
              "time": event.postModel.time,
              "id": event.postModel.id
            });
          }
          emit(CommentsSuccess(
            comments: comments,
          ));
        }
      }
    } catch (e) {
      emit(CommentsError());
    }
  }
}
