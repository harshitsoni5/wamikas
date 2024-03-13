import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import 'create_job_profile_state.dart';

class CreateJobProfileCubit extends Cubit<CreateJobProfileState> {
  CreateJobProfileCubit() : super(CreateJobProfileInitial());

  Future createJobProfile(String jobTitle,
      String companyName,
      String industry,
      String description)async{
    emit(CreateJobProfileLoading());
    try{
     if(jobTitle.isNotEmpty
         && companyName.isNotEmpty
         && industry.isNotEmpty
         && description.isNotEmpty){
       String documentId = await SharedData.getIsLoggedIn("phone");
       await FireStoreDataBaseServices.addDataOfUserToCollection(
           "users",
           documentId,
           {
             "job_title":jobTitle,
             "company_name":companyName,
             "industry":industry,
             "description":description
           }
       );
       emit(CreateJobProfileSuccess());
     }
     else{
       emit(CreateJobProfileFormNotFilledState());
       emit(CreateJobProfileInitial());
     }
    }
    catch(e){
      print(e.toString());
      emit(CreateJobProfileError());
      emit(CreateJobProfileInitial());
    }
  }
}
