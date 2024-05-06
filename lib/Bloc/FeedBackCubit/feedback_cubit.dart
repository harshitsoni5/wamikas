import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  Future saveFeedback({
    required String name,
    required String email,
    required String experience,
    required String comments,
  })async{
    emit(FeedbackLoading());
    try{
      if(name.isNotEmpty){
        if(email.isNotEmpty){
          if(experience.isNotEmpty){
            await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
                "feedback");
            String documentId = await SharedData.getIsLoggedIn("phone");
            await FireStoreDataBaseServices.setDataToUserCollection(
                "feedback", documentId, {
              "uid": documentId,
              "name":name,
              "email":email,
              "experience":experience,
              "comments":comments
            });
            emit(FeedBackSuccess());
            emit(FeedbackInitial());
          }else{
            emit(FeedbackExperience());
            emit(FeedbackInitial());
          }
        }else{
          emit(FeedbackEmailEmpty());
          emit(FeedbackInitial());
        }
      }else{
        emit(FeedBackName());
        emit(FeedbackInitial());
      }
    }
    catch(e){
      print(e.toString());
      emit(FeedbackError());
    }
  }
}
