import 'package:flutter/material.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import 'package:wamikas/View/AuthScreens/auth_screen.dart';
import 'package:wamikas/View/AuthScreens/signup.dart';
import 'package:wamikas/View/Splash%7CWelcome/welcome_screen.dart';
import '../../View/AuthScreens/otp_verfication.dart';
import '../../View/AuthScreens/signin.dart';
import '../../View/Splash|Welcome/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case RouteName.home:
        // return MaterialPageRoute(
        //     builder: (BuildContext context) => const Home());
        case RouteName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUp());
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
          return MaterialPageRoute(
              builder: (BuildContext context) =>  const OtpVerification());
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
