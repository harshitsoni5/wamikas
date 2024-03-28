import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Core/FirebaseDataBaseService/firestore_database_services.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'otp_verfication_state.dart';
//9582973777

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit() : super(OtpVerificationInitial());

  Future verifyOtp(
      String otp,
      String verificationId,
      String? username,
      String phoneNumber,
      String? email
      )async {
    emit(OtpVerificationLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        SharedData.setUid(userCredential.user!.uid);
        SharedData.setPhone(phoneNumber);
        CollectionReference collectionReference = FireStoreDataBaseServices.
        createNewCollectionOrAddToExisting("users");
        collectionReference.doc(phoneNumber).
        set({
          "name":username,
          "phone":phoneNumber,
          "email":email
        });
        emit(OtpVerificationSuccess());
        emit(OtpVerificationInitial());
      }
      else {
        SharedData.setUid(userCredential.user!.uid);
        SharedData.setPhone(phoneNumber);
        emit(OtpVerificationUserAlreadyExistsState());
        emit(OtpVerificationInitial());
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == "invalid-verification-code") {
        emit(OtpVerificationFailed());
        emit(OtpVerificationInitial());
      } else {
        emit(OtpVerificationError());
        emit(OtpVerificationInitial());
      }
    }
  }

  Future otpResend({required String phoneNumber})async{
    String? verificationID;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      codeSent: (verificationId, forceResendingToken) {
        verificationID = verificationId;
        emit(OtpResendSuccessState(verificationId: verificationID!));
        emit(OtpVerificationInitial());
      },
      verificationFailed: (error) {
        emit(OtpResendFailed());
        emit(OtpVerificationInitial());
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationID = verificationId;
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
      },
    );
  }
}
