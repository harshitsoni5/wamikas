import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../SharedPrefernce/shared_pref.dart';
import '../../Color/colors.dart';
import '../../Routes/route_name.dart';
import '../Text/simple_text.dart';

class OnBoardingText extends StatelessWidget {
  final String title;
  final String subTitle;
  final String svgPicture;
  final PageController pageController;
  final int pageIndex;
  final Size size;
  const OnBoardingText({
    super.key,
    required this.title,
    required this.subTitle,
    required this.svgPicture,
    required this.pageController,
    required this.pageIndex,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svg/logo.svg",height: 100,width: 100,),
          const SizedBox(height: 25,),
          SimpleText(
            textAlign: TextAlign.center,
            text: title,
            fontColor: const Color(0xFF0E0D0D),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,),
          SimpleText(
            text:subTitle,
            textAlign: TextAlign.center,
            fontColor: const Color(0xFF606060),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,),
          const SizedBox(height: 25,),
          SizedBox(
            height: size.height*0.38,
            width: size.width,
            child: SvgPicture.asset(svgPicture,fit: BoxFit.contain,),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            child: Container(
              height: 80,
              padding: const EdgeInsets.only(bottom: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: pageIndex == 2
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    child:  const SimpleText(
                      text: 'Next',
                      fontSize: 18,
                      fontColor: ColorClass.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      SharedData.setIsOnboardDone(true);
                      Navigator.pushNamed(context, RouteName.auth);
                    },
                    child:  const SimpleText(
                      text: "Skip",
                      fontColor: Colors.white,
                      fontSize: 18,
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
                    child:  const SimpleText(
                      text: 'Next',
                      fontSize: 18,
                      fontColor: ColorClass.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
