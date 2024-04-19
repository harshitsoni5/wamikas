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
    on<BookmarkResources>(bookmarkResources);
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
          List<ResourcesModel> personalFinance =[];
          List<ResourcesModel> personalGrowth =[];
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
}
