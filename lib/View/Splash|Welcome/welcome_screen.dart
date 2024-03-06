import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Components/Text/on_boarding_image_text.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Routes/route_name.dart';

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
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          children: const [
            OnBoardingText(
              title: "Create Wamikas Profile",
              subTitle: "to Add flair, explore, secure, learn daily.",
              svgPicture: "assets/svg/on_boarding1.svg",
            ),
            OnBoardingText(
              title: "Select Your Interest",
              subTitle: "to get update on Events, Group Discussion and Webinars",
              svgPicture: "assets/svg/on_boarding2.svg",
            ),
            OnBoardingText(
              title: "Share Your Thoughts",
              subTitle: "to get update, Share Emotions, and get advice from others.",
              svgPicture: "assets/svg/on-Boarding3.svg",
            ),
          ],
        ),
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            child: Container(
              height: 125,
              padding: const EdgeInsets.only(bottom: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: pageIndex == 2 ?
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(),
                      SmoothPageIndicator(
                          onDotClicked: (index) {
                            pageController.animateToPage(index,
                                duration: const Duration(microseconds: 500),
                                curve: Curves.easeIn);
                          },
                          controller: pageController,
                          count: 3,
                          effect: const ExpandingDotsEffect(
                            dotColor: Color(0xFFC4DEDC),
                            dotHeight: 8,
                            dotWidth: 8,
                            strokeWidth: 20,
                            activeDotColor: ColorClass.textColor,
                          )),
                      InkWell(
                        onTap: () {
                          SharedData.setIsOnboardDone(true);
                          Navigator.pushNamed(context, RouteName.auth);
                         },
                      child: const SimpleText(
                      text: 'Next >',
                      fontSize: 14,
                      fontColor: ColorClass.textColor,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  )
                    :Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      pageController.jumpToPage(2);
                    },
                    child: const SimpleText(
                      text: "Skip",
                      fontColor: Color(0xFF888888),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SmoothPageIndicator(
                      onDotClicked: (index) {
                        pageController.animateToPage(index,
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      },
                      controller: pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotColor: Color(0xFFC4DEDC),
                        dotHeight: 8,
                        dotWidth: 8,
                        strokeWidth: 20,
                        activeDotColor: ColorClass.textColor,
                      )),
                  InkWell(
                    onTap: () {
                      pageController.nextPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: const SimpleText(
                      text: 'Next >',
                      fontSize: 14,
                      fontColor: ColorClass.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}