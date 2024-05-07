import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/event_model.dart';
import 'package:wamikas/Models/resources_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../Models/post_model.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<DeletePostEvent>(deletePostEvent);
  }

  FutureOr<void> homeInitialEvent(HomeInitialEvent event,
      Emitter<HomeState> emit) async {
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
      LocalData.docId = docId;
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
          for (int i = 0; i < allData.length; i++) {
            //particular post of a user uid
            var userData = await reference.doc(allData[i]["uid"]).get();
            if (userData.exists) {
              var postedDataProfileDetails = userData.data();
              if (postedDataProfileDetails != null &&
                  postedDataProfileDetails is Map<String, dynamic>) {
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
            } else {
              emit(HomeError());
            }
          }
          //events
          QuerySnapshot eventsSnap = await events.get();
          List allEvents = eventsSnap.docs
              .map((doc) => doc.data()).toList();
          List<EventModel> trendingData = [];
          List<EventModel> featuredData = [];
          List<EventModel> workshopData = [];
          LocalData.workshopEvents.clear();
          LocalData.featuredEvents.clear();
          LocalData.trendingEvents.clear();
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
          LocalData.featuredEvents.addAll(featuredData);
          LocalData.trendingEvents.addAll(trendingData);
          LocalData.workshopEvents.addAll(workshopData);
          // resources
          LocalData.personalFinance.clear();
          LocalData.personalGrowth.clear();
          QuerySnapshot resourcesSnap = await resources.get();
          List allResources = resourcesSnap.docs
              .map((doc) => doc.data()).toList();
          List<ResourcesModel> personalFinance = [];
          List<ResourcesModel> personalGrowth = [];
          for (int i = 0;
          i < allResources[0]["personal_financee"].length; i++) {
            personalFinance.add(ResourcesModel.fromJson(
                allResources[0]["personal_financee"][i]));
          }
          for (int i = 0;
          i < allResources[0]["professional_growth"].length; i++) {
            personalGrowth.add(ResourcesModel.fromJson(
                allResources[0]["professional_growth"][i]));
          }
          LocalData.personalFinance.addAll(personalFinance);
          LocalData.personalGrowth.addAll(personalGrowth);
          emit(HomeSuccess(
              listOfAllPost: listsOfPosts,
              userData: UserProfileModel.fromJson(data),
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
      emit(HomeError());
    }
  }

  FutureOr<void> deletePostEvent(DeletePostEvent event,
      Emitter<HomeState> emit) async {
    try {
      await FireStoreDataBaseServices.deleteDocumentById(
          collectionName: "posts", documentId: event.postId);
      // QuerySnapshot querySnapshot = await postReference.get();
      // //list of posts
      // List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      // List<PostModel> listsOfPosts = [];
      // for (int i = 0; i < allData.length; i++) {
      //   var userData = await postReference.doc(allData[i]["uid"]).get();
      //   if (userData.exists) {
      //     var postedDataProfileDetails = userData.data();
      //     if (postedDataProfileDetails != null &&
      //         postedDataProfileDetails is Map<String, dynamic>) {
      //       listsOfPosts.add(PostModel(
      //           uid: allData[i]["uid"],
      //           forumName: allData[i]["forum_name"],
      //           forumTitle: allData[i]["forum_title"],
      //           forumContent: allData[i]["forum_content"],
      //           like: allData[i]["like"],
      //           comments: allData[i]["comments"],
      //           time: allData[i]["time"],
      //           name: postedDataProfileDetails["name"],
      //           emailId: postedDataProfileDetails["email"],
      //           id: allData[i]["id"],
      //           profilePic: postedDataProfileDetails["profile_pic"]));
      //     }
      //   } else {
      //     emit(HomeError());
      //   }
      // }
      List<PostModel> allPosts = [];
      for (int i = 0; i < event.listsOfPost.length; i++) {
        if (event.listsOfPost[i].id != event.postId) {
          allPosts.add(event.listsOfPost[i]);
        }
      }
      emit(HomeSuccess(
          listOfAllPost: allPosts,
          userData: event.userData,
          workshopData: event.workshopData,
          trendingData: event.trendingData,
          featuredData: event.featuredData,
          personalFinance: event.personalFinance,
          personalGrowth: event.personalGrowth));
      CollectionReference notification =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "notifications");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await notification.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map) {
          int index = 0;
          List notifications = data["notifications"];
          for (int i = 0; i < notifications.length; i++) {
            if (notifications[i]["id"] == event.postId) {
              break;
            }
            index++;
          }
          notifications.removeAt(index);
          await FireStoreDataBaseServices.setDataToUserCollection(
              "notifications", docId, {
            "notifications": notifications
          });
        }
      }
    } catch (e) {
      emit(HomeError());
    }
  }
}
