import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<CommentsInit>(commentsInit);
    on<PostAComment>(postAComment);
    on<ReduceBottomSheetSize>(reduceBottomSheetSize);
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
    try {
      CollectionReference postReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      var postDetails = await postReference.doc(event.postId).get();
      if(postDetails.exists){
        var docId = await SharedData.getIsLoggedIn("phone");
        var postData = postDetails.data();
        var uuid = const Uuid();
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
          "uid": event.uid,
            "comment_id":uuid.v4()
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
    ));
  }
  FutureOr<void> likeAComment(
      LikeAComment event, Emitter<CommentsState> emit) async {
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
          int index=0;
          for (int i=0; i<comments.length;i++){
            if(event.commentModel.commentId == comments[i]["comment_id"]){
              break;
            }
            index++;
          }
          comments.removeAt(index);
          List likesAdded = event.commentModel.likes;
          likesAdded.add(docId);
          comments.insert(index, {
            "comments_desc": event.commentModel.commentsDesc,
            "likes": likesAdded,
            "name": event.commentModel.name,
            "profile_pic":event.commentModel.profilePic,
            "time": event.commentModel.time,
            "uid": event.commentModel.uid,
            "comment_id":event.commentModel.commentId
          });
          FireStoreDataBaseServices.setDataToUserCollection(
              "posts", event.postId, {
            "comments":comments,
            "uid": docId,
            "forum_name": event.postModel.forumName,
            "forum_title": event.postModel.forumTitle,
            "forum_content": event.postModel.forumContent,
            "like": [],
            "time": event.postModel.time,
            "id":event.postModel.id
          });
          emit(
              CommentsSuccess(
                comments: comments,
              )
          );
        }
      }
    } catch (e) {
      emit(CommentsError());
    }
  }
}