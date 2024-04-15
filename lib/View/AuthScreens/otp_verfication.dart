import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:wamikas/Bloc/AuthBloc/OtpVerficationCubit/otp_verfication_state.dart';
import 'package:wamikas/Bloc/AuthBloc/OtpVerficationCubit/otp_verification_cubit.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  final String? email;
  final String? username;
  final String phone;
  final bool fromLogin;
  const OtpVerification({
    super.key,
    required this.verificationId,
    required this.email,
    required this.username,
    required this.phone,
    required this.fromLogin,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController pin = TextEditingController();
  bool isValidate = false;
  String? verificationId;

  @override
  void initState() {
   verificationId =widget.verificationId;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFFFFFFF), // Top color (white)
                Color(0xffFF9CEA), // Bottom color (light pinkish)
              ],
              stops: [0.5, 1.0],
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset("assets/svg/ep_back.svg"))),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                         SimpleText(
                          text: "+91- ${widget.phone}",
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: const SimpleText(
                            text: "Change Phone number",
                            fontSize: 14,
                            textDecoration: TextDecoration.underline,
                            fontColor: ColorClass.textColor,
                            decorationStyle: ColorClass.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Pinput(
                              controller: pin,
                              length: 6,
                              showCursor: true,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                              ],
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
                            BlocConsumer<OtpVerificationCubit, OtpVerificationState>(
                            listener: (context, state) {
                              if(state is OtpResendSuccessState){
                                verificationId =state.verificationId;
                                Fluttertoast.showToast(
                                    msg: "Otp has been send successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.black,
                                    fontSize: 15.0
                                );
                              }
                            },
                            builder: (context, state) {
                              return InkWell(
                              onTap: () {
                                BlocProvider.of<OtpVerificationCubit>(context).otpResend(
                                    phoneNumber: widget.phone);
                              },
                              child: const SimpleText(
                                text: "Resend OTP",
                                fontSize: 14,
                                fontColor:ColorClass.textColor,
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline,
                                decorationStyle: ColorClass.textColor,
                              ),
                            );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        BlocConsumer<OtpVerificationCubit, OtpVerificationState>(
                          listenWhen: (previous, current) => current is OtpVerificationActionState,
                          buildWhen: (previous, current) => current is! OtpVerificationActionState,
                          listener: (context, state) {
                            if(state is OtpVerificationSuccess){
                             Navigator.of(context).pushNamedAndRemoveUntil(
                                 RouteName.locationDetails, (route) => false);
                            }
                            if(state is OtpVerificationUserAlreadyExistsState){
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteName.bottomBar, (route) => false);
                            }
                            if(state is OtpVerificationFailed){
                              Fluttertoast.showToast(
                                  msg: "Otp does not match",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.black,
                                  fontSize: 15.0
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is OtpVerificationLoading){
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: InkWell(
                              onTap: (){
                                BlocProvider.of<OtpVerificationCubit>(context).
                                verifyOtp(pin.text,verificationId!,
                                  widget.username, widget.phone,
                                  widget.email
                                );
                              },
                                child: RoundAuthButtons(
                                    size: size,
                                    btnText: "Validate"),
                            )
                        );
                        },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
