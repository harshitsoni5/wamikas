import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../Models/post_model.dart';
import '../../../Models/resources_model.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<GetUserDataEvent>(getUserDataEvent);
    on<GetUserDataWithoutLoading>(getUserDataWithoutLoading);
  }

  FutureOr<void> getUserDataEvent(
      GetUserDataEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      CollectionReference reference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "users");
      CollectionReference postReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      CollectionReference resources =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "resources");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          QuerySnapshot querySnapshot = await postReference.get();
          List allData = querySnapshot.docs
              .map((doc) => doc.data()).toList();
          List<PostModel> listsOfPosts = [];
          for(int i=0;i<allData.length;i++){
            if(data["phone"] == allData[i]["uid"]){
              listsOfPosts.add(PostModel(
                  uid: allData[i]["uid"],
                  forumName: allData[i]["forum_name"],
                  forumTitle: allData[i]["forum_title"],
                  forumContent: allData[i]["forum_content"],
                  like: allData[i]["like"],
                  comments: allData[i]["comments"],
                  time: allData[i]["time"],
                  name: data["name"],
                  emailId: data["email"],
                  id: allData[i]["id"],
                profilePic: data["profile_pic"]
              ));
            }
          }
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
          int profilePercentage = 0;
          if (data.containsKey("state")) {
            profilePercentage += 25;
          }
          if (data.containsKey("profile_pic") &&
              data["profile_pic"].toString().isNotEmpty) {
            profilePercentage += 25;
          }
          if (data.containsKey("job_title") &&
              data["job_title"].toString().isNotEmpty) {
            profilePercentage += 25;
          }
          if (data.containsKey("interests")) {
            profilePercentage += 25;
          }
          emit(UserProfileSuccess(
              userData: UserProfileModel.fromJson(data),
              profilePercentage: profilePercentage,
              listOfForums: listsOfPosts,
            personalGrowth: personalGrowth,
            personalFinance: personalFinance
          ));
        } else {
          emit(UserProfileError());
        }
      } else {
        emit(UserProfileError());
      }
    } catch (e) {
      print(e.toString());
      emit(UserProfileError());
    }
  }

  FutureOr<void> getUserDataWithoutLoading(
      GetUserDataWithoutLoading event, Emitter<UserProfileState> emit) async {
      CollectionReference reference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "users");
      CollectionReference postReference =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "posts");
      CollectionReference resources =
      await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
          "resources");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          QuerySnapshot querySnapshot = await postReference.get();
          List allData = querySnapshot.docs
              .map((doc) => doc.data()).toList();
          List<PostModel> listsOfPosts = [];
          for(int i=0;i<allData.length;i++){
            if(data["phone"] == allData[i]["uid"]){
              listsOfPosts.add(PostModel(
                  uid: allData[i]["uid"],
                  forumName: allData[i]["forum_name"],
                  forumTitle: allData[i]["forum_title"],
                  forumContent: allData[i]["forum_content"],
                  like: allData[i]["like"],
                  comments: allData[i]["comments"],
                  time: allData[i]["time"],
                  name: data["name"],
                  emailId: data["email"],
                  id: allData[i]["id"],
                profilePic: data["profile_pic"]
              ));
            }
          }
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
          int profilePercentage = 0;
          if (data.containsKey("state")) {
            profilePercentage += 25;
          }
          if (data.containsKey("profile_pic") &&
              data["profile_pic"].toString().isNotEmpty) {
            profilePercentage += 25;
          }
          if (data.containsKey("job_title") &&
              data["job_title"].toString().isNotEmpty) {
            profilePercentage += 25;
          }
          if (data.containsKey("interests")) {
            profilePercentage += 25;
          }
          print("here");
          emit(UserProfileSuccess(
              userData: UserProfileModel.fromJson(data),
              profilePercentage: profilePercentage,
              listOfForums: listsOfPosts,
            personalGrowth: personalGrowth,
            personalFinance: personalFinance
          ));
        } else {
          emit(UserProfileError());
        }
      } else {
        emit(UserProfileError());
      }
  }
}
