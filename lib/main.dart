import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wamikas/Bloc/AuthBloc/OtpVerficationCubit/otp_verification_cubit.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_cubit.dart';
import 'package:wamikas/Bloc/CommentsBloc/comments_bloc.dart';
import 'package:wamikas/Bloc/ForumCreationBloc/forum_cubit.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/CreateJobProfile/create_job_profile_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/JobDescriptionCubit/job_description_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/LocationCubit/location_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:wamikas/firebase_options.dart';
import 'Bloc/UserProfileBloc/InterestsCubit/interests_cubit.dart';
import 'Core/FirebasePushNotificationService/firebase_push_notificatioin_services.dart';
import 'Utils/Routes/route_name.dart';
import 'Utils/Routes/routes.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  print(message.data);
}

Future<void> _handleNotificationResponse(NotificationResponse response) async {
  print("here");
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  PushNotificationServices.firebaseCloudMessaging();
  var initializationSettings =
  PushNotificationServices.localNotificationInitialization();
  PushNotificationServices.saveFcmToken();
  await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse);
  PushNotificationServices.incomingMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage){
    // navigatorKey.currentState?.restorablePushNamed(
    //     RouteName.notificationPost,
    //     arguments: {
    //       "postId" :remoteMessage.data["post_id"]
    //     });
  });
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    // if (message != null) {
    //   navigatorKey.currentState?.restorablePushNamed(
    //       RouteName.splash,arguments: {
    //     "fromBackground":true,
    //     "postId":message.data["post_id"]
    //   });
    // }
  });
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
        BlocProvider<ForumCubit>(
            create: (BuildContext context) =>ForumCubit()),
        BlocProvider<HomeBloc>(
            create: (BuildContext context) =>HomeBloc()),
        BlocProvider<CommentsBloc>(
            create: (BuildContext context) =>CommentsBloc()),
      ],
      child: ScreenUtilInit(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: RouteName.splash,
          onGenerateRoute: Routes.generateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
