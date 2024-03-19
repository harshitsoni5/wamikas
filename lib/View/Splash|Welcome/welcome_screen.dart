import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Utils/Components/Text/on_boarding_image_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final double paddingFromDown = 80;
  final double paddingFromTop = 100;
  final pageController = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration:   const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF), // Top color (white)
                Color.fromARGB(140,227,40,154), // Bottom color (light pinkish)
              ],
              stops: [0.7, 1.0],
            ),
          ),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            children:  [
              OnBoardingText(
                title: "Create Wamikas Profile",
                subTitle: "to Add flair, explore, secure, learn daily.".toLowerCase(),
                svgPicture: "assets/svg/on_boarding1.svg",
                pageController: pageController,
                pageIndex: pageIndex,
                size: size,
              ),
              OnBoardingText(
                title: "Select Your Interest",
                subTitle:
                    "to get update on Events, Group Discussion and Webinars".toLowerCase(),
                svgPicture: "assets/svg/on_boarding2.svg",
                pageController: pageController,
                pageIndex: pageIndex,
                size: size,
              ),
              OnBoardingText(
                title: "Share Your Thoughts",
                subTitle:
                    "to get update, Share Emotions, and get advice from others.".toLowerCase(),
                svgPicture: "assets/svg/on_boarding3.svg",
                pageController: pageController,
                pageIndex: pageIndex,
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
