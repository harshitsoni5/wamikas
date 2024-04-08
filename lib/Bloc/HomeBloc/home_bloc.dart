import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../Models/post_model.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomePostLikeEvent>(postLikeEvent);
    on<HomePostCommentEvent>(postComment);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      CollectionReference reference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "users");
      CollectionReference postReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          QuerySnapshot querySnapshot = await postReference.get();
          List allData = querySnapshot.docs
              .map((doc) => doc.data()).toList();
          List<PostModel> listsOfPosts = [];
          for(int i=0; i<allData.length;i++){
            var userData = await reference.doc(allData[i]["uid"]).get();
            if(userData.exists){
              var postedDataProfileDetails= userData.data();
              if(postedDataProfileDetails != null &&
                  postedDataProfileDetails is Map<String, dynamic>){
                listsOfPosts.add(PostModel(
                    uid: allData[i]["uid"],
                    forumName: allData[i]["forum_name"],
                    forumTitle: allData[i]["forum_title"],
                    forumContent: allData[i]["forum_content"],
                    like: allData[i]["like"],
                    comments: allData[i]["comments"],
                    time: allData[i]["time"],
                    name: postedDataProfileDetails["name"],
                    emailId: postedDataProfileDetails["email"],
                  id: allData[i]["id"]
                ));
              }
            }else{
              emit(HomeError());
            }
          }
          emit(HomeSuccess(
              listOfAllPost: listsOfPosts,
              userData:UserProfileModel.fromJson(data)
          ));
        } else {
          emit(HomeError());
        }
      }
      else {
        emit(HomeError());
      }
    } catch (e) {
      emit(HomeError());
    }
  }

  FutureOr<void> postLikeEvent(
      HomePostLikeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      CollectionReference reference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "users");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          QuerySnapshot querySnapshot = await reference.get();
          var allData = querySnapshot.docs
              .map((doc) => PostModel.fromJson(
              (doc.data() as Map<String, dynamic>))).toList();
          emit(HomeSuccess(
              listOfAllPost: allData,
              userData:UserProfileModel.fromJson(data)
          ));
        } else {
          emit(HomeError());
        }
      }
      else {
        emit(HomeError());
      }
    } catch (e) {
      emit(HomeError());
    }
  }

  FutureOr<void> postComment(
      HomePostCommentEvent event, Emitter<HomeState> emit) async {
    try {
      CollectionReference reference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      var docId = await SharedData.getIsLoggedIn("phone");
      QuerySnapshot querySnapshot = await reference.get();
      final allData = querySnapshot.docs
          .map((doc) => PostModel.fromJson(
          (doc.data() as Map<String, dynamic>))).toList();

    } catch (e) {
      emit(HomeError());
    }
  }
}
