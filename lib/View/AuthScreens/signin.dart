import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/Utils/Components/TextField/text_field_container.dart';
import '../../Bloc/AuthBloc/SignUpCubit/signup_cubit.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Routes/route_name.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController phone =TextEditingController();
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SimpleText(text: "Don’t have an account? ",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontColor: Colors.black,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.register);
                },
                child: const SimpleText(
                  text: "SIGN UP",
                  fontSize: 14,
                  fontColor:ColorClass.textColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: SingleChildScrollView(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(height: size.height/5,),
               Column(
                 children: [
                   SvgPicture.asset(
                     "assets/svg/w-logo.svg",
                     height: 100,width: 170,),
                   const SimpleText(
                     text: "Sign in your account",
                     fontSize: 18,
                     fontWeight: FontWeight.w700,
                   ),
                 ],
               ),
               const SizedBox(height: 80,),
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: 25),
                 child: TextFieldContainer(
                     hintText: "9654831317",
                     titleBox: "Phone",
                     controller: phone),
               ),
                const SizedBox(height: 15,),
                BlocConsumer<SignupCubit, SignupState>(
                  listenWhen: (previous, current) => current is SignUpActionState,
                  buildWhen: (previous, current) => current is! SignUpActionState,
                listener: (context, state) {
                  if(state is AuthCodeSentState){
                    Navigator.of(context).pushNamed(
                        RouteName.otpVerification,arguments:{
                      "verificationId" : state.verificationId,
                      "phone":phone.text,
                      "fromLogin":true
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
                  if(state is UserNotExists){
                    Fluttertoast.showToast(
                        msg: "User not exists",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        fontSize: 15.0
                    );
                  }
            
                  if(state is FormNotFilledProperly){
                    Fluttertoast.showToast(
                        msg: "Mobile number is invalid",
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
                  return InkWell(
                  onTap: (){
                    BlocProvider.of<SignupCubit>(context).login(phone.text);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                    width: size.width,
                    decoration: ShapeDecoration(
                      color: ColorClass.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: SimpleText(
                        text: "NEXT",
                        fontColor: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                  ),
                );
              },
            ),
               const SizedBox(height: 15,),
            
             ],
            ),
          ),
        ),
      ),
    );
  }
}
