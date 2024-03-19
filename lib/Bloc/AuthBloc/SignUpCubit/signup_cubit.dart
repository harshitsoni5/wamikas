import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';
import 'package:wamikas/Core/FirebaseDataBaseService/firestore_database_services.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(AuthInitialState());

  Future register({
    required String phoneNumber,
    required String username,
    required bool isEmailEmpty,
    required bool isEmailValid,
    required bool isPhoneEmpty,
    required bool isUsernameEmpty,
  })async{
    emit(AuthLoadingState());
    String? verificationID;
    if(isUsernameEmpty==false){
     if(isEmailEmpty){
      if(isEmailValid){
       if(isPhoneEmpty==false){
         if(phoneNumber.length ==10){
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
               },
             );
           }
         }else{
           emit(PhoneInvalid());
           emit(AuthInitialState());
         }
       }
       else{
         emit(PhoneEmpty());
         emit(AuthInitialState());
       }
      }else{
        emit(EmailInvalid());
        emit(AuthInitialState());
      }
     }else{
       emit(EmailEmpty());
       emit(AuthInitialState());
     }
    }else{
      emit(UsernameEmpty());
      emit(AuthInitialState());
    }
  }

  Future login({required String phoneNumber,required bool isValidPhone})async{
    emit(AuthLoadingState());
    String? verificationID;
    if(isValidPhone){
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
      }
      else{
        emit(PhoneInvalid());
        emit(AuthInitialState());
      }
    }else{
      emit(PhoneEmpty());
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
