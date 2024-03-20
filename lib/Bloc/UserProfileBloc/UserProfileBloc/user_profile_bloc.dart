import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<GetUserDataEvent>(getUserDataEvent);
  }

  FutureOr<void> getUserDataEvent(
      GetUserDataEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      CollectionReference reference =
          await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
              "users");
      var docId = await SharedData.getIsLoggedIn("phone");
      var snapshot = await reference.doc(docId).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String,dynamic>) {
          emit(UserProfileSuccess(
              userData:
                  UserProfileModel.fromJson(data)));
        } else {
          emit(UserProfileError());
        }
      } else {
        emit(UserProfileError());
      }
    } catch (e) {
      emit(UserProfileError());
    }
  }
}
