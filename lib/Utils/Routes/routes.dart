import 'package:flutter/material.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import 'package:wamikas/View/AuthScreens/auth_screen.dart';
import 'package:wamikas/View/AuthScreens/signup.dart';
import 'package:wamikas/View/Forum/forum_screeen.dart';
import 'package:wamikas/View/Home/bottom_navigation_bar.dart';
import 'package:wamikas/View/Home/home.dart';
import 'package:wamikas/View/More/more.dart';
import 'package:wamikas/View/Notification/notification.dart';
import 'package:wamikas/View/Notification/notification_post.dart';
import 'package:wamikas/View/Splash%7CWelcome/welcome_screen.dart';
import 'package:wamikas/View/UserDetails/contact_details.dart';
import 'package:wamikas/View/UserDetails/create_job_profile.dart';
import 'package:wamikas/View/UserDetails/edit_profile.dart';
import 'package:wamikas/View/UserDetails/interests.dart';
import 'package:wamikas/View/UserDetails/interst_and_prefrences.dart';
import 'package:wamikas/View/UserDetails/job_description.dart';
import 'package:wamikas/View/UserDetails/location_deatils.dart';
import 'package:wamikas/View/UserDetails/upload_photo.dart';
import 'package:wamikas/View/UserDetails/user_profile.dart';
import '../../View/AuthScreens/otp_verfication.dart';
import '../../View/AuthScreens/signin.dart';
import '../../View/Serach/search.dart';
import '../../View/Splash|Welcome/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
        case RouteName.bottomBar:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
        case RouteName.search:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Search());
        case RouteName.notification:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NotificationScreen());
        case RouteName.notificationPost:
       if(argument is String){
         return MaterialPageRoute(
             builder: (BuildContext context) => NotificationPost(
               postId: argument,
             ));
       }else{
         return MaterialPageRoute(
             builder: (BuildContext context) => const NotificationPost(postId: '',
             ));
       }
        case RouteName.more:
        return MaterialPageRoute(
            builder: (BuildContext context) => const More());
        case RouteName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUp());
        case RouteName.interests:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Interests());
        case RouteName.userProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserProfile());
        case RouteName.forum:
      if(argument is UserProfileModel){
        return MaterialPageRoute(
            builder: (BuildContext context) =>  ForumScreen(
              userData: argument,
            ));
      }else{
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const ForumScreen(
              userData: null,
            ));
      }
        case RouteName.editProfile:
          if(argument is UserProfileModel){
            return MaterialPageRoute(
                builder: (BuildContext context) =>  EditProfile(
                  userData: argument,));
          }
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
          case RouteName.jobDescription:
          if(argument is UserProfileModel){
            return MaterialPageRoute(
                builder: (BuildContext context) =>  JobProfileDescription(
                  userData: argument,));
          }
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
          case RouteName.contactDetails:
          if(argument is UserProfileModel){
            return MaterialPageRoute(
                builder: (BuildContext context) =>  ContactDetails(
                  userData: argument,));
          }
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
          case RouteName.interestAndPref:
          if(argument is UserProfileModel){
            return MaterialPageRoute(
                builder: (BuildContext context) =>  InterestAndPreferences(
                  userData: argument,));
          }
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
        case RouteName.createJobProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateJobProfile());
        case RouteName.locationDetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LocationDetails());
        case RouteName.uploadPhoto:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadPhoto());
        case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
        case RouteName.auth:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AuthScreen());
        case RouteName.welcome:
        return MaterialPageRoute(
            builder: (BuildContext context) => const WelcomeScreen());
        case RouteName.signIn:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignIn());
        case RouteName.otpVerification:
          if(argument is Map){
            return MaterialPageRoute(
                builder: (BuildContext context) =>   OtpVerification(
                  verificationId: argument["verificationId"],
                  username: argument["username"],
                  email: argument["email"],
                  phone: argument["phone"],
                  fromLogin: argument["fromLogin"],
                )
            );
          }
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
