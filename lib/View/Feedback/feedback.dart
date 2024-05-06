import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController comments = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    comments.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            UserProfileAppBar(size: size,title: "Feedback",isBack: true,),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldContainer(
                        hintText: "Enter your name",
                        titleBox: "Name",
                        controller: name,
                      ),
                      TextFieldContainer(
                        hintText: "Enter your email",
                        titleBox: "Email",
                        controller: name,
                      ),
                       Padding(
                         padding: const EdgeInsets.only(left: 8),
                         child: SimpleText(text: "Rate your experience",
                          fontSize: 14.sp,
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w500,),
                       ),
                      const SizedBox(height: 10,),
                      EmojiFeedback(
                        animDuration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                        inactiveElementScale: .5,
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFieldContainer(
                        hintText: "Your comments",
                        titleBox: "Add your comments",
                        controller: comments,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: RoundAuthButtons(
                  size: size, btnText: "Submit Now"),
            )
          ],
        ),
      ),
    );
  }
}
