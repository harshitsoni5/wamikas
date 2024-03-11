import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'otp_verfication_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit() : super(OtpVerificationInitial());

  Future verifyOtp(String otp,String verificationId)async {
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
        emit(OtpVerificationSuccess());
        emit(OtpVerificationInitial());
      } else {
        SharedData.setUid(userCredential.user!.uid);
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
}
