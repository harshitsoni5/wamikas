import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Utils/Routes/route_name.dart';
import 'Utils/Routes/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyD33SyZDJ3qymDSY2I9YCjouSNuvGsenY8", // paste your api key here
      appId:
      "1:186413252291:android:2ad7bc68ed5d7420fdec76", //paste your app id here
      messagingSenderId: "186413252291", //paste your messagingSenderId here
      projectId: "wamikas1", //paste your project id here
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RouteName.otpVerification,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
