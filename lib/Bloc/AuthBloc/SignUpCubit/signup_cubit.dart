import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(AuthInitialState());

  Future sendOtp(String phoneNumber)async{
    emit(AuthLoadingState());
    String? verificationID;
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
}
