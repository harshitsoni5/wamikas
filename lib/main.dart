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
import 'package:wamikas/Bloc/FeedBackCubit/feedback_cubit.dart';
import 'package:wamikas/Bloc/ForumCreationBloc/forum_cubit.dart';
import 'package:wamikas/Bloc/ForumUserCubit/forum_user_cubit.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/CreateJobProfile/create_job_profile_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/JobDescriptionCubit/job_description_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/LocationCubit/location_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'package:wamikas/firebase_options.dart';
import 'Bloc/NotficationPost/notification_post_cubit.dart';
import 'Bloc/NotificationBloc/notification_cubit.dart';
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
  bool? isNotificationOn = await SharedFcmToken.getFcmToken("notification");
  isNotificationOn ??= false;
  isNotificationOn ? await PushNotificationServices.firebaseCloudMessaging():null;
  var initializationSettings =
 isNotificationOn? PushNotificationServices.localNotificationInitialization():null;
  PushNotificationServices.saveFcmToken();
  isNotificationOn ? await notificationsPlugin.initialize(
      initializationSettings!,
      onDidReceiveNotificationResponse: _handleNotificationResponse):null;
  PushNotificationServices.incomingMessage();
  isNotificationOn ? FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler):null;
  isNotificationOn ? FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage){
    print(remoteMessage);
    navigatorKey.currentState?.restorablePushNamed(
        RouteName.notificationPost,
        arguments:remoteMessage.data["post_id"]);
  }):null;
  isNotificationOn ? FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      navigatorKey.currentState?.restorablePushNamed(
          RouteName.splash,arguments: {
        "fromBackground":true,
        "postId":message.data["post_id"]
      });
    }
  }):null;
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
        BlocProvider<NotificationCubit>(
            create: (BuildContext context) =>NotificationCubit()),
        BlocProvider<ForumUserCubit>(
            create: (BuildContext context) =>ForumUserCubit()),
        BlocProvider<NotificationPostCubit>(
            create: (BuildContext context) =>NotificationPostCubit()),
        BlocProvider<FeedbackCubit>(
            create: (BuildContext context) =>FeedbackCubit()),
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

// privacy icon
// comments edit or like removed and delete
//shimmer effect in events and resources
