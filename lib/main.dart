import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wamikas/Bloc/AuthBloc/OtpVerficationCubit/otp_verification_cubit.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/CreateJobProfile/create_job_profile_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/JobDescriptionCubit/job_description_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/LocationCubit/location_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import 'Bloc/UserProfileBloc/InterestsCubit/interests_cubit.dart';
import 'Utils/Routes/route_name.dart';
import 'Utils/Routes/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAlDmwOlgjGVXxLXGE8SbvHs9wu_VcdcSM",
      appId: "1:350187485615:android:f9d20580d8392e6286d75a",
      messagingSenderId: "350187485615",
      projectId: "wamikas-c82b2",
      storageBucket: "wamikas-c82b2.appspot.com",
    ),
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupCubit>(
            create: (BuildContext context) =>SignupCubit()),
        BlocProvider<OtpVerificationCubit>(
            create: (BuildContext context) =>OtpVerificationCubit()),
        BlocProvider<LocationCubit>(
            create: (BuildContext context) =>LocationCubit()),
        BlocProvider<UploadImageCubit>(
            create: (BuildContext context) =>UploadImageCubit()),
        BlocProvider<CreateJobProfileCubit>(
            create: (BuildContext context) =>CreateJobProfileCubit()),
        BlocProvider<InterestsCubit>(
            create: (BuildContext context) =>InterestsCubit()),
        BlocProvider<UserProfileBloc>(
            create: (BuildContext context) =>UserProfileBloc()),
        BlocProvider<ContactDetailsCubit>(
            create: (BuildContext context) =>ContactDetailsCubit()),
        BlocProvider<JobDescriptionCubit>(
            create: (BuildContext context) =>JobDescriptionCubit()),
      ],
      child: ScreenUtilInit(
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: RouteName.home,
          onGenerateRoute: Routes.generateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
