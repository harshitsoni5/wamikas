import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_cubit.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';
import '../../Utils/Routes/route_name.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  void dispose() {
    phone.dispose();
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset("assets/svg/ep_back.svg")),
                SvgPicture.asset("assets/svg/w-logo.svg"),
                const SimpleText(
                  text: "Signup",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 15,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldContainer(
                        hintText: "username",
                        titleBox: "Username",
                        controller: name,
                      ),
                      TextFieldContainer(
                        hintText: "ex: jon.smith@email.com",
                        titleBox: "Email",
                        controller: email,
                      ),
                      TextFieldContainer(
                        hintText: "0918991938",
                        titleBox: "Phone",
                        controller: phone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                BlocConsumer<SignupCubit, SignupState>(
                  listenWhen: (previous, current) => current is SignUpActionState,
                  buildWhen: (previous, current) => current is! SignUpActionState,
                  listener: (context, state) {
                   if(state is AuthCodeSentState){
                     Navigator.of(context).pushNamed(
                         RouteName.otpVerification,arguments:{
                           "verificationId" : state.verificationId
                     });
                   }
                   if(state is AuthErrorState){
                     Fluttertoast.showToast(
                         msg: "oops something went wrong",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                  },
                  builder: (context, state) {
                    if(state is AuthLoadingState){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                          onTap: (){
                            BlocProvider.of<SignupCubit>(context).sendOtp(phone.text);
                          },
                            child: RoundAuthButtons(size: size, btnText: "Send OTP"))
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
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SimpleText(text: "Already have an account? ",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontColor: Colors.black,
                      textDecoration: TextDecoration.underline,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteName.signIn);
                      },
                      child: const SimpleText(
                        text: "Login Now",
                        fontSize: 14,
                        fontColor: ColorClass.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

