import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController pin = TextEditingController();
  bool isValidate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                      child: SvgPicture.asset("assets/svg/ep_back.svg"))),
              SvgPicture.asset("assets/svg/logo.svg",height: 100,),
              const SizedBox(height: 5,),
              const SimpleText(
                text: "Validate OTP",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontColor: Colors.black,
              ),
              const SizedBox(height: 5,),
              const SimpleText(
                text: "We have just sent ant OTP to your\n phone number",
                fontSize: 16,
                textAlign: TextAlign.center,
                fontColor: Colors.black,
                fontWeight:FontWeight.w500,
              ),
              const SimpleText(
                text: "+91- 96XXXX1317",
                fontSize: 16,
                textAlign: TextAlign.center,
                fontColor: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                height: 10,
              ),
              const SimpleText(
                text: "Change Phone number",
                fontSize: 14,
                textDecoration: TextDecoration.underline,
                fontColor: ColorClass.textColor,
                decorationStyle: ColorClass.textColor,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Pinput(
                    controller: pin,
                    length: 6,
                    showCursor: true,
                    onChanged: (value) {
                      if (value.length == 6) {
                        setState(() {
                          isValidate = true;
                        });
                      } else {
                        isValidate = false;
                      }
                    },
                    defaultPinTheme: PinTheme(
                      width: size.width,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: isValidate == true
                                ? const Color(0xff4EB3CA)
                                : const Color(0xffE8E8E8)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SimpleText(text: "Didn’t Received OTP ",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.black,
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: const SimpleText(
                      text: "Resend OTP",
                      fontSize: 14,
                      fontColor:ColorClass.textColor,
                      fontWeight: FontWeight.bold,
                      textDecoration: TextDecoration.underline,
                      decorationStyle: ColorClass.textColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: RoundAuthButtons(size: size, btnText: "Validate")
              ),
              const SizedBox(height: 20,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleText(
                          text: "By proceeding, you agree to Wamikas",
                          fontSize: 12),
                      SimpleText(text: "Terms of Service.",
                        fontSize: 12,
                        fontColor: ColorClass.textColor,
                        textDecoration: TextDecoration.underline,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleText(
                          text: "We will manage information about you as described in",
                          fontSize: 12),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleText(
                          text: "our ",
                          fontSize: 12),
                      SimpleText(text: "Privacy Policy ",
                        fontSize: 12,
                        fontColor: ColorClass.textColor,
                        textDecoration: TextDecoration.underline,
                      ),
                      SimpleText(
                          text: "and ",
                          fontSize: 12),
                      SimpleText(text: "Cookie Policy.",
                        fontSize: 12,
                        fontColor: ColorClass.textColor,
                        textDecoration: TextDecoration.underline,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
