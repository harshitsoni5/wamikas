import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Buttons/round_finalise_button.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Routes/route_name.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: size.width,
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: size.height,
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/bg_img.png",
                  fit: BoxFit.cover,
                  width: size.width,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                              child: SvgPicture.asset("assets/svg/ep_back.svg")),
                      ),
                      SvgPicture.asset("assets/svg/logo.svg",
                      height: size.height*0.25,
                        width: size.width*0.4,
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushNamed(RouteName.register);
                          },
                          child: RoundFinaliseButton(
                              size: size,
                              btnText: "Signup",
                              isEnable: true),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SimpleText(text: "Already have an account? ",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.black,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(RouteName.signIn);
                            },
                            child: const SimpleText(
                                text: "Login Now",
                                fontSize: 14,
                                fontColor:ColorClass.textColor,
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
