import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  InterestsCubit() : super(InterestsInitial());

  Future interests(List interests)async{
    emit(InterestsLoading());
    try{
      if(interests.isEmpty){
        emit(InterestsNotSelected());
      }else{
        String documentId = await SharedData.getIsLoggedIn("phone");
        await FireStoreDataBaseServices.addDataOfUserToCollection(
            "users",
            documentId,
            {
              "interests":interests
            }
        );
        emit(InterestsSuccess());
      }
    }
    catch(e){
      emit(InterestsError());
    }
  }
}
