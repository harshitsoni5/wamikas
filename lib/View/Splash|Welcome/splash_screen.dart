import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat();
    Timer(
        const Duration(seconds: 2),
            () {
          SharedData.getIsLoggedIn('IsOnboardDone').then((value) async {
            if (value == true) {
              String? docId= await SharedData.getIsLoggedIn("phone");
              if(docId != null && docId.isNotEmpty){
                Navigator.pushReplacementNamed(context, RouteName.bottomBar);
              }else{
                Navigator.pushReplacementNamed(context, RouteName.signIn);
              }
            }
            else {
              Navigator.pushReplacementNamed(context, RouteName.welcome);
            }
          }
          );
        });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // Top color (white)
              Color(0xffFF9CEA), // Bottom color (light pinkish)
            ],
            stops: [0.2, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: size.width*0.6,
                  height:  size.height*0.4,
                  child: SvgPicture.asset(
                      "assets/svg/logo.svg")),
              // Container(
              //   width: size.width*0.3,
              //   margin: const EdgeInsets.symmetric(horizontal: 50),
              //   child: LinearProgressIndicator(
              //     borderRadius: BorderRadius.circular(40),
              //     color: ColorClass.textColor,
              //     value: controller.value,
              //     semanticsLabel: 'Linear progress indicator',
              //   ),
              // ),
              // const SimpleText(
              //   text: 'LOADING....',
              //   textAlign: TextAlign.center,
              //   fontColor: Colors.black,
              //   fontSize: 10,
              //   fontFamily: 'Poppins',
              //   fontWeight: FontWeight.w500,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
