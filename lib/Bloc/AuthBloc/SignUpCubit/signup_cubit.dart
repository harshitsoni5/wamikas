import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';
import 'package:wamikas/Core/FirebaseDataBaseService/firestore_database_services.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(AuthInitialState());

  Future register(String phoneNumber,String username)async{
    emit(AuthLoadingState());
    String? verificationID;
    if(phoneNumber.length==10 && username.isNotEmpty ){
      bool userExists = await checkIfUserExists(phoneNumber);
      if(userExists){
        emit(UserAlreadyExists());
        emit(AuthInitialState());
      }
      else{
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91$phoneNumber",
          codeSent: (verificationId, forceResendingToken) {
            verificationID = verificationId;
            emit(AuthCodeSentState(verificationId: verificationID!));
            emit(AuthInitialState());
          },
          verificationFailed: (error) {
            emit(AuthErrorState(error.message.toString()));
            emit(AuthInitialState());
          },
          codeAutoRetrievalTimeout: (verificationId) {
            verificationID = verificationId;
          },
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            print("helle");
          },
        );
      }
    }else{
      emit(FormNotFilledProperly());
      emit(AuthInitialState());
    }
  }

  Future login(String phoneNumber)async{
    emit(AuthLoadingState());
    String? verificationID;
    if(phoneNumber.length==10){
      bool userExists = await checkIfUserExists(phoneNumber);
      if(userExists){
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91$phoneNumber",
          codeSent: (verificationId, forceResendingToken) {
            verificationID = verificationId;
            emit(AuthCodeSentState(verificationId: verificationID!));
            emit(AuthInitialState());
          },
          verificationFailed: (error) {
            emit(AuthErrorState(error.message.toString()));
            emit(AuthInitialState());
          },
          codeAutoRetrievalTimeout: (verificationId) {
            verificationID = verificationId;
          },
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            print("helle");
          },
        );
      }
      else{
        emit(UserNotExists());
        emit(AuthInitialState());
      }
    }else{
      emit(FormNotFilledProperly());
      emit(AuthInitialState());
    }
  }

  Future<bool> checkIfUserExists(String phoneNumber) async {
    CollectionReference reference= await
    FireStoreDataBaseServices.createNewCollectionOrAddToExisting("users");
    var snapshot = await reference.doc(phoneNumber).get();
    return snapshot.exists;
  }
}
