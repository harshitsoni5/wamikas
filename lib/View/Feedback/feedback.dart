import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Bloc/FeedBackCubit/feedback_cubit.dart';
import 'package:wamikas/Bloc/FeedBackCubit/feedback_state.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
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
  String experience ="";
  bool fullName =false;
  bool emailEmpty =false;
  bool experienceEmpty =false;
  bool commentsEmpty =false;
  bool isLoading=false;
  @override
  void initState() {
   setState(() {
     isLoading=true;
   });
   getNameAndEmail();
   super.initState();
  }

  getNameAndEmail()async{
    String namePref =await SharedData.getIsLoggedIn("name");
    name.text=namePref;
    String emailPref =await SharedData.getIsLoggedIn("email");
    email.text=emailPref;
   setState(() {
     isLoading=false;
   });
  }
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
        bottomNavigationBar: Visibility(
          visible: !isLoading,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height*0.13,
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocConsumer<FeedbackCubit, FeedbackState>(
                listener: (context, state) {
                  if(state is FeedBackName){
                    setState(() {
                      fullName=true;
                    });
                  }
                  if(state is FeedbackEmailEmpty){
                    setState(() {
                      fullName=false;
                      emailEmpty=true;
                    });
                  }
                  if(state is EmptyComment){
                   setState(() {
                     fullName=false;
                     emailEmpty=false;
                     experienceEmpty=false;
                     commentsEmpty=true;
                   });
                  }
                  if(state is FeedbackExperience){
                    setState(() {
                      fullName=false;
                      emailEmpty=false;
                      experienceEmpty=true;
                    });
                  } if(state is FeedBackSuccess){
                   setState(() {
                     emailEmpty=false;
                     fullName=false;
                     experienceEmpty=false;
                   });
                    Fluttertoast.showToast(
                        msg: "Feedback sent successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        backgroundColor: CupertinoColors.white,
                        fontSize: 15.0
                    );
                    comments.clear();
                  }
                  if(state is FeedbackError){
                    Fluttertoast.showToast(
                        msg: "oops some error occurred",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        backgroundColor: CupertinoColors.white,
                        fontSize: 15.0
                    );
                  }
                },
                builder: (context, state) {
                  if(state is FeedbackLoading){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    onTap: (){
                      BlocProvider.of<FeedbackCubit>(context).saveFeedback(
                          name: name.text,
                          comments: comments.text,
                          email: email.text,
                          experience: experience
                      );
                    },
                    child: RoundAuthButtons(
                        size: size, btnText: "Submit Now"),
                  );
                },
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            UserProfileAppBar(
              size: size,
              title: "Feedback",
              isBack: true,
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 20,),
           isLoading? const Expanded(child: Center(
             child: CircularProgressIndicator(),
           )):Expanded(
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
                      fullName? Align(
                        alignment: Alignment.centerRight,
                        child: SimpleText(
                          text: "Please enter your name",
                          fontSize: 11.sp,
                          fontColor: Colors.red,
                        ),
                      ):const SizedBox(),
                      TextFieldContainer(
                        hintText: "Enter your email",
                        titleBox: "Email",
                        controller: email,
                      ),
                      emailEmpty? Align(
                        alignment: Alignment.centerRight,
                        child: SimpleText(
                          text: "Please enter email id",
                          fontSize: 11.sp,
                          fontColor: Colors.red,
                        ),
                      ):const SizedBox(),
                       Padding(
                         padding: const EdgeInsets.only(left: 8),
                         child: SimpleText(text: "Rate your experience",
                          fontSize: 14.sp,
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w500,),
                       ),
                     experienceEmpty? Align(
                        alignment: Alignment.centerRight,
                        child: SimpleText(
                          text: "Please rate your experience",
                          fontSize: 11.sp,
                          fontColor: Colors.red,
                        ),
                      ):const SizedBox(),
                      const SizedBox(height: 10,),
                      EmojiFeedback(
                        inactiveElementBlendColor: Colors.white,
                        animDuration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                        inactiveElementScale: .5,
                        onChanged: (value) {
                          if(value ==1){
                            experience ="Terrible";
                          }
                          else if(value==2){
                            experience="Bad";
                          }
                          else if(value==3){
                            experience="Good";
                          }
                          else if(value==4){
                            experience="Very Good";
                          }else{
                            experience="Awesome";
                          }
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFieldContainer(
                        hintText: "Your comments",
                        titleBox: "Add your comments",
                        controller: comments,
                        maxLines: 5,
                      ),
                      commentsEmpty? Align(
                        alignment: Alignment.centerRight,
                        child: SimpleText(
                          text: "Please enter your comment",
                          fontSize: 11.sp,
                          fontColor: Colors.red,
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}