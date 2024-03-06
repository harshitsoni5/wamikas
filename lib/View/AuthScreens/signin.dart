import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/Utils/Components/TextField/text_field_container.dart';
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
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
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
              Container(
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
             const SizedBox(height: 15,),

           ],
          ),
        ),
      ),
    );
  }
}
