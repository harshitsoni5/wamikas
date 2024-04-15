import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_cubit.dart';
import 'package:wamikas/Bloc/AuthBloc/SignUpCubit/signup_state.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Buttons/round_auth_buttons.dart';
import 'package:wamikas/Utils/Regex/regex.dart';
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
  final Regex regex =Regex();
  bool isValidEmail=false;
  bool isEmailEmpty=true;
  bool isPhoneEmpty=true;
  bool isUsernameEmpty=true;

  @override
  void dispose() {
    phone.dispose();
    name.dispose();
    email.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Container(
                 padding: const EdgeInsets.only(right: 20,left: 20,top: 10),
                 child: Column(
                   children: [
                     SvgPicture.asset("assets/svg/w-logo.svg"),
                      SimpleText(
                       text: "Signup",
                       fontSize: 20.sp,
                       fontWeight: FontWeight.w600,
                     ),
                     const SizedBox(height: 20,),
                     Container(
                       margin: const EdgeInsets.symmetric(horizontal: 25),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           TextFieldContainer(
                             hintText: "Enter username",
                             titleBox: "Username",
                             controller: name,
                             maxLength: 16,
                             keyboardType: TextInputType.visiblePassword,
                             onChanged: (val){
                               if(val.isEmpty){
                                 isUsernameEmpty=true;
                               }else{
                                 isUsernameEmpty=false;
                               }
                             },
                           ),
                           TextFieldContainer(
                             hintText: "Enter email",
                             titleBox: "Email",
                             controller: email,
                             maxLength: 32,
                             keyboardType: TextInputType.visiblePassword,
                             onChanged: (val){
                               if(val.isEmpty){
                                 isEmailEmpty=false;
                               }else{
                                 isEmailEmpty=true;
                                 if(regex.isValidEmail(val)){
                                   isValidEmail=true;
                                 }else{
                                   isValidEmail=false;
                                 }
                               }
                             },
                           ),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Padding(
                                 padding: EdgeInsets.only(left: 10),
                                 child: SimpleText(
                                   text: "Enter phone number",
                                   fontSize: 15,
                                   fontColor: Colors.black,
                                   fontWeight: FontWeight.w500,
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(
                                         color: const Color(0xffE8E8E8)
                                     )
                                 ),
                                 child: IntrinsicHeight(
                                   child: Row(
                                     children: [
                                       SvgPicture.asset("assets/svg/india.svg",height: 25,width: 25,),
                                       const SizedBox(width: 8,),
                                       const SimpleText(text: "+91", fontSize: 16,fontWeight: FontWeight.bold,),
                                       const Padding(
                                         padding: EdgeInsets.symmetric(vertical: 4),
                                           child: VerticalDivider()),
                                       Flexible(
                                         child: TextField(
                                           onTapOutside: (event) {
                                             FocusScopeNode currentFocus = FocusScope.of(context);
                                             if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                                               FocusManager.instance.primaryFocus?.unfocus();
                                             }
                                           },
                                           inputFormatters: <TextInputFormatter>[
                                             FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                           ],
                                           onChanged: (val){
                                             if(val.isEmpty){
                                               isPhoneEmpty =true;
                                             }else{
                                               isPhoneEmpty=false;
                                             }
                                           },
                                           keyboardType: TextInputType.number,
                                           maxLength: 10,
                                           controller: phone,
                                           decoration: InputDecoration(
                                               counterText: "",
                                               border: InputBorder.none,
                                               contentPadding: const EdgeInsets.only(left: 10),
                                               hintText: "Enter phone number",
                                               hintStyle: GoogleFonts.poppins(
                                                 color: const Color(0xff888888),
                                                 fontSize: 13.sp,
                                               )
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               const SizedBox(height: 10,)
                             ],
                           ),
                         ],
                       ),
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
                           "verificationId" : state.verificationId,
                           "phone":phone.text,
                           "email":email.text,
                           "username":name.text,
                           "fromLogin":false
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
                   if(state is UserAlreadyExists){
                     Fluttertoast.showToast(
                         msg: "user already exists",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                   if(state is UsernameEmpty){
                     Fluttertoast.showToast(
                         msg: "User name field should not be empty",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                   if(state is EmailEmpty){
                     Fluttertoast.showToast(
                         msg: "Email should not be empty",
                         toastLength: Toast.LENGTH_LONG,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                   if(state is EmailInvalid){
                     Fluttertoast.showToast(
                         msg: "Please enter a valid email",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                   if(state is PhoneEmpty){
                     Fluttertoast.showToast(
                         msg: "Phone number field should not be empty",
                         toastLength: Toast.LENGTH_LONG,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                   if(state is PhoneInvalid){
                     Fluttertoast.showToast(
                         msg: "Please enter a valid phone number",
                         toastLength: Toast.LENGTH_LONG,
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
                        margin: const EdgeInsets.symmetric(horizontal: 45),
                        child: InkWell(
                          onTap: (){
                            BlocProvider.of<SignupCubit>(context).register(
                                isEmailEmpty: isEmailEmpty,
                              isEmailValid: isValidEmail,
                              isPhoneEmpty: isPhoneEmpty,
                              isUsernameEmpty: isUsernameEmpty,
                              phoneNumber: phone.text,
                              username: name.text
                            );
                          },
                            child: RoundAuthButtons(size: size, btnText: "Send OTP"))
                    );
                  },
                ),
                const SizedBox(height: 20,),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleText(
                            text: "By proceeding, you agree to Wamikas",
                            fontSize: 10.sp),
                        SimpleText(text: "Terms of Service.",
                          fontSize: 10.sp,
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
                            fontSize: 10.sp),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleText(
                            text: "our ",
                            fontSize: 10.sp),
                        SimpleText(text: "Privacy Policy ",
                          fontSize: 10.sp,
                          fontColor: ColorClass.textColor,
                          textDecoration: TextDecoration.underline,
                        ),
                        SimpleText(
                            text: "and ",
                            fontSize: 10.sp),
                        SimpleText(text: "Cookie Policy.",
                          fontSize: 10.sp,
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
                     SimpleText(text: "Already have an account? ",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      fontColor: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteName.signIn);
                      },
                      child: SimpleText(
                        text: "Login Now",
                        fontSize: 10.sp,
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

