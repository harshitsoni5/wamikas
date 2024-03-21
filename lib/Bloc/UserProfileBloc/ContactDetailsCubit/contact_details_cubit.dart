import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Utils/regex.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import 'contact_details_state.dart';

class ContactDetailsCubit extends Cubit<ContactDetailsState> {
  ContactDetailsCubit() : super(ContactDetailsInitial());

  Future updateProfile({
  required String name,
  required String email,
    required String? country,
    required String? city,
    required String? state,
    required String? fullAddress,
    required String? apartment,
  })async{
    emit(ContactDetailsLoading());
    Regex regex =Regex();
    try{
      if(name.isNotEmpty){
       if(email.isNotEmpty){
        if(regex.isValidEmail(email)){
          String documentId = await SharedData.getIsLoggedIn("phone");
          await FireStoreDataBaseServices.addDataOfUserToCollection(
              "users",
              documentId,
              {
                "country":country,
                "state":state,
                "city":city,
                "address":fullAddress,
                "apartment":apartment,
                "name":name,
                "email":email
              }
          );
          emit(ContactDetailsSuccess());
          emit(ContactDetailsInitial());
        }else{
          emit(EmailInvalidState());
        }
       }else{
         emit(EmailEmpty());
       }
      }else{
        emit(NameEmpty());
      }
    }
    catch(e){
      print(e.toString());
      emit(ContactDetailsError());
    }
  }


}
