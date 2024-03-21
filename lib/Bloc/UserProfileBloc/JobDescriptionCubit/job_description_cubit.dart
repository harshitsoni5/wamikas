import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import 'job_description_state.dart';

class JobDescriptionCubit extends Cubit<JobDescriptionState> {
  JobDescriptionCubit() : super(JobDescriptionInitial());

  Future updateJobDescription({
  required String jobTitle,
  required String company,
  required String industry,
  required String location,
  required String skills,
  required String education,
  required String jobDesc,
  })async{
    emit(JobDescLoadingState());
    try{
      if(jobTitle.isNotEmpty &&
          company.isNotEmpty &&
          industry.isNotEmpty &&
          location.isNotEmpty &&
          skills.isNotEmpty &&
          education.isNotEmpty &&
          jobDesc.isNotEmpty
      ){
        String documentId = await SharedData.getIsLoggedIn("phone");
        await FireStoreDataBaseServices.addDataOfUserToCollection(
            "users",
            documentId,
            {
              "job_title":jobTitle,
              "company_name":company,
              "industry":industry,
              "description":jobDesc,
              "job_location":location,
              "skills":skills,
              "education":education
            }
        );
        emit(JobDescSuccessState());
        emit(JobDescriptionInitial());
      }
      else{
        emit(JobDescNotFilledState());
        emit(JobDescriptionInitial());
      }
    }
    catch(e){
      emit(JobDescErrorState());
      emit(JobDescriptionInitial());
    }
  }
}
