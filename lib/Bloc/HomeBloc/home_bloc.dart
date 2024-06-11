import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wamikas/Models/event_model.dart';
import 'package:wamikas/Models/resources_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import 'package:wamikas/main.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../Models/post_model.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<DeletePostEvent>(deletePostEvent);
    on<BookmarkResources>(bookmarkResources);
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
                DateTime parseDateTime(String time) {
                  return DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(time, true).toLocal();
                }
                listsOfPosts.sort((a, b) => parseDateTime(b.time).compareTo(parseDateTime(a.time)));
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
          LocalData.bookmarked.clear();
          for (int i = 0; i < allResources[0]["personal_financee"].length; i++) {
            if(allResources[0]["personal_financee"][i]["bookmark"].contains(docId)){
              LocalData.bookmarked.add(ResourcesModel.fromJson(allResources[0]["personal_financee"][i]));
            }
            personalFinance.add(ResourcesModel.fromJson(
                allResources[0]["personal_financee"][i]));
          }
          for (int i = 0;
          i < allResources[0]["professional_growth"].length; i++) {
            if(allResources[0]["professional_growth"][i]["bookmark"].contains(docId)){
              LocalData.bookmarked.add(ResourcesModel.fromJson(allResources[0]["professional_growth"][i]));
            }
            personalGrowth.add(ResourcesModel.fromJson(
                allResources[0]["professional_growth"][i]));
          }
          LocalData.personalFinance.addAll(personalFinance);
          LocalData.personalGrowth.addAll(personalGrowth);
          bool isNewNotification = false;
          CollectionReference notificationListReference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "notifications");
          var notiList = await notificationListReference.doc(docId).get();
          if(notiList.exists){
            var notiData = notiList.data();
            if(notiData!= null && notiData is Map){
              List localNotiData = notiData["notifications"];
              int notificationList = await SharedData.getIsLoggedIn("list");
              if(notificationList<localNotiData.length){
                SharedData.notificationList(localNotiData.length);
                isNewNotification=true;
              }else{
                isNewNotification=false;
              }
            }
          }
          emit(HomeSuccess(
              listOfAllPost: listsOfPosts,
              userData: UserProfileModel.fromJson(data),
              featuredData: featuredData,
              trendingData: trendingData,
              workshopData: workshopData,
              personalFinance: personalFinance,
              personalGrowth: personalGrowth,
            isNewNotification: isNewNotification
          ));

        }
        else {
          print("ab yahan par");
          emit(HomeError());
        }
      }
      else {
        print("hello yes");
        emit(HomeError());
      }
    } catch (e) {
      print("haha");
      print(e.toString());
      emit(HomeError());
    }
  }

  FutureOr<void> bookmarkResources(
      BookmarkResources event, Emitter<HomeState> emit) async {
    try{
      var docId = await SharedData.getIsLoggedIn("phone");
      List<ResourcesModel> personalFinance = [];
      List<ResourcesModel> personalGrowth = [];
      personalFinance.addAll(LocalData.personalFinance);
      personalGrowth.addAll(LocalData.personalGrowth);
      for(int i=0; i<personalFinance.length;i++){
        if(event.id== personalFinance[i].id){
          if(event.bookmarkOrNot){
            personalFinance[i].bookmark.add(docId);
            LocalData.bookmarked.add(personalFinance[i]);
          }else{
            personalFinance[i].bookmark.remove(docId);
            for(int j=0;j<LocalData.bookmarked.length;j++){
              if(event.id==LocalData.bookmarked[j].id){
                LocalData.bookmarked.removeAt(j);
              }
            }
          }
          break;
        }
      }
      for(int i=0; i<personalGrowth.length;i++){
        if(event.id== personalGrowth[i].id){
          if(event.bookmarkOrNot){
            personalGrowth[i].bookmark.add(docId);
            LocalData.bookmarked.add(personalGrowth[i]);
          }else{
            personalGrowth[i].bookmark.remove(docId);
            for(int j=0;j<LocalData.bookmarked.length;j++){
              if(event.id==LocalData.bookmarked[j].id){
                LocalData.bookmarked.removeAt(j);
              }
            }
          }
          break;
        }
      }
      LocalData.personalFinance.clear();
      LocalData.personalGrowth.clear();
      LocalData.personalFinance.addAll(personalFinance);
      LocalData.personalGrowth.addAll(personalGrowth);
      List<Map> finance =[];
      List<Map> growth =[];
      for(int i=0;i<personalFinance.length;i++){
        finance.add({
          "title": personalFinance[i].title,
          "by": personalFinance[i].by,
          "image": personalFinance[i].image,
          "link": personalFinance[i].link,
          "bookmark": personalFinance[i].bookmark,
          "id": personalFinance[i].id,
        });
      }
      for(int i=0;i<personalGrowth.length;i++){
        growth.add({
          "title": personalGrowth[i].title,
          "by": personalGrowth[i].by,
          "image": personalGrowth[i].image,
          "link": personalGrowth[i].link,
          "bookmark": personalGrowth[i].bookmark,
          "id": personalGrowth[i].id,
        });
      }
      await FireStoreDataBaseServices.setDataToUserCollection(
          "resources", "OwqESSB2dPDMh8GguQqQ", {
        "personal_financee":finance,
        "professional_growth":growth
      });
    }
    catch(e){
      print(e.toString());
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
      print(event.listsOfPost.length);
      for (int i = 0; i < event.listsOfPost.length; i++) {
        if (event.listsOfPost[i].id != event.postId) {
          allPosts.add(event.listsOfPost[i]);
        }
      }
      print(allPosts.length);
      emit(HomeSuccess(
          listOfAllPost: allPosts,
          userData: event.userData,
          workshopData: event.workshopData,
          trendingData: event.trendingData,
          featuredData: event.featuredData,
          personalFinance: event.personalFinance,
          personalGrowth: event.personalGrowth,
        isNewNotification: event.isNewNotification
      ));
      CollectionReference notification =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "notifications");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await notification.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map) {
          int index = 0;
          bool isThereAreAnyNotification =false;
          List notifications = data["notifications"];
          for (int i = 0; i < notifications.length; i++) {
            if (notifications[i]["id"] == event.postId) {
              isThereAreAnyNotification=true;
              break;
            }
            index++;
          }
          if(isThereAreAnyNotification){
            notifications.removeAt(index);
            await FireStoreDataBaseServices.setDataToUserCollection(
                "notifications", docId, {
              "notifications": notifications
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }
}
