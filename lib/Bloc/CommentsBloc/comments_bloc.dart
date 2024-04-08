import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<CommentsInit>(commentsInit);
    on<PostAComment>(postAComment);
    on<ReduceBottomSheetSize>(reduceBottomSheetSize);
  }

  FutureOr<void> commentsInit(
      CommentsInit event, Emitter<CommentsState> emit) async {
    emit(CommentsSuccess(
        comments: event.comments,
      isClicked: false
    ));
  }

  FutureOr<void> postAComment(
      PostAComment event, Emitter<CommentsState> emit) async {
    try {
      CollectionReference postReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      var postDetails = await postReference.doc(event.postId).get();
      if(postDetails.exists){
        var docId = await SharedData.getIsLoggedIn("phone");
        var postData = postDetails.data();
        if (postData != null &&
            postData is Map) {
          List comments = event.comments;
          comments.add(
          {
          "comments_desc": event.commentDesc,
          "likes": [],
          "name": event.userData.name,
          "profile_pic":event.userData.profilePic,
          "time": DateTime.now(),
          "uid": event.uid
          }
          );
          await FireStoreDataBaseServices.setDataToUserCollection(
            "posts",
            event.postId,
            {
              "comments":comments,
              "uid": docId,
              "forum_name": event.postModel.forumName,
              "forum_title": event.postModel.forumTitle,
              "forum_content": event.postModel.forumContent,
              "like": [],
              "time": event.postModel.time,
              "id":event.postModel.id
            }
          );
          emit(
            CommentsSuccess(
              comments: comments,
              isClicked: false
            )
          );
        }
      }
    } catch (e) {
      emit(CommentsError());
    }
  }

  FutureOr<void> reduceBottomSheetSize(
      ReduceBottomSheetSize event, Emitter<CommentsState> emit) async {
    emit(CommentsSuccess(
        comments: event.comments,
      isClicked: event.isClicked
    ));
  }
}
