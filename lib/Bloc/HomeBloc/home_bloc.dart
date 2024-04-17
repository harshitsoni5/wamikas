import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/event_model.dart';
import 'package:wamikas/Models/resources_model.dart';
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
    on<SearchTopicsEvent>(searchTopicsEvent);
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
      CollectionReference events =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "events");
      CollectionReference resources =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "resources");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          //forums
          QuerySnapshot querySnapshot = await postReference.get();
          //list of posts
          List allData = querySnapshot.docs
              .map((doc) => doc.data()).toList();
          List<PostModel> listsOfPosts = [];
          for(int i=0; i<allData.length;i++){
            //particular post of a user uid
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
                  id: allData[i]["id"],
                  profilePic: postedDataProfileDetails["profile_pic"]
                ));
              }
            }else{
              emit(HomeError());
            }
          }


          //events
          QuerySnapshot eventsSnap = await events.get();
          List allEvents = eventsSnap.docs
              .map((doc) => doc.data()).toList();
          List<EventModel> trendingData =[];
          List<EventModel> featuredData =[];
          List<EventModel> workshopData =[];
          for (int i = 0; i < allEvents[0]["trendings"].length; i++) {
            trendingData.add(EventModel.fromJson(allEvents[0]["trendings"][i]));
          }
          for (int i = 0; i < allEvents[0]["featured_events"].length; i++) {
            featuredData
                .add(EventModel.fromJson(allEvents[0]["featured_events"][i]));
          }
          for (int i = 0; i < allEvents[0]["workshops"].length; i++) {
            workshopData.add(EventModel.fromJson(allEvents[0]["workshops"][i]));
          }

          // resources
          QuerySnapshot resourcesSnap = await resources.get();
          List allResources = resourcesSnap.docs
              .map((doc) => doc.data()).toList();
          List<ResourcesModel> personalFinance =[];
          List<ResourcesModel> personalGrowth =[];
          for (int i = 0; i < allResources[0]["personal_financee"].length; i++) {
            personalFinance.add(ResourcesModel.fromJson(allResources[0]["personal_financee"][i]));
          }
          for (int i = 0; i < allResources[0]["professional_growth"].length; i++) {
            personalGrowth.add(ResourcesModel.fromJson(allResources[0]["professional_growth"][i]));
          }
          emit(HomeSuccess(
              listOfAllPost: listsOfPosts,
              userData:UserProfileModel.fromJson(data),
            featuredData: featuredData,
            trendingData: trendingData,
            workshopData: workshopData,
            personalFinance: personalFinance,
            personalGrowth: personalGrowth
          ));
        }
        else {
          emit(HomeError());
        }
      }
      else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
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
          // emit(HomeSuccess(
          //     listOfAllPost: allData,
          //     userData:UserProfileModel.fromJson(data)
          // ));
        }
        else {
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

  FutureOr<void> searchTopicsEvent(
      SearchTopicsEvent event, Emitter<HomeState> emit) async {
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
