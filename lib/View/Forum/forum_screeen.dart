import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:wamikas/Bloc/ForumCreationBloc/forum_cubit.dart';
import 'package:wamikas/Bloc/ForumCreationBloc/forum_state.dart';
import 'package:wamikas/Bloc/ForumUserCubit/forum_user_cubit.dart';
import 'package:wamikas/Bloc/ForumUserCubit/forum_user_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../Bloc/HomeBloc/home_bloc.dart';
import '../../Bloc/HomeBloc/home_event.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class ForumScreen extends StatefulWidget {
  final UserProfileModel? userData;
  const ForumScreen({super.key, required this.userData});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController selectForum = TextEditingController();
  final TextEditingController postTitle = TextEditingController();
  final TextEditingController description = TextEditingController();
  bool headlinesMissing = false;
  bool descriptionMissing = false;
  List<String> forums = [
    'Personal Finance',
    'Professional Growth',
    'Work-Life Balance',
    'Career Development',
    'Miscellaneous',
  ];
  var uuid = const Uuid();
  String name ="";

  @override
  void initState() {
    BlocProvider.of<ForumUserCubit>(context).getUserData(widget.userData);
    selectForum.text ="Personal Finance";
    super.initState();
  }

  @override
  void dispose() {
  selectForum.dispose();
  postTitle.dispose();
  description.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: size.height*0.13,
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocConsumer<ForumCubit, ForumState>(
                listener: (context, state) {
                  if(state is ForumNotSelected){
                  }
                  if(state is ForumHeadlinesMissing){
                    setState(() {
                      headlinesMissing=true;
                    });
                  }
                  if(state is ForumDescriptionMissing){
                    setState(() {
                      descriptionMissing=true;
                    });
                  }
                  if(state is ForumSuccess){
                    Fluttertoast.showToast(
                        msg: "Forum created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.black,
                        backgroundColor: CupertinoColors.white,
                        fontSize: 15.0
                    );
                    postTitle.clear();
                    description.clear();
                    setState(() {
                      headlinesMissing =false;
                      descriptionMissing=false;
                    });
                  }
                },
                builder: (context, state) {
                  if(state is ForumLoading){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                      onTap: () {
                        BlocProvider.of<ForumCubit>(context).createForum(
                            forumName: selectForum.text,
                            forumTitle: postTitle.text,
                            postId: uuid.v1(),
                            dateAndTime: DateTime.now().toString(),
                            forumDescription: description.text,
                            name: name
                        );
                      },
                      child: RoundAuthButtons(
                          size: size, btnText: "Post Now"));
                },
              ),
            ],
          ),
        ),
        body:SingleChildScrollView(
          child:  Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<ForumUserCubit, ForumUserState>(
              builder: (context, state) {
                if(state is ForumUserSuccess){
                  name=state.name;
                  return Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      BlocProvider.of<HomeBloc>(context).add(
                                          HomeInitialEvent());
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/ep_back (2).svg",
                                      height: 35,
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                                const SimpleText(
                                  text: "Create post",
                                  fontSize: 24,
                                  fontColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: CircleAvatar(
                                    radius: 25,
                                    child:state.profilePic ==null?
                                    SvgPicture.asset("assets/svg/profile.svg",):
                                    Image.network(state.profilePic!),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SimpleText(
                                  text: state.name,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                // Flexible(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       SimpleText(
                                //         text: state.name,
                                //         fontSize: 14.sp,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //       // widget.userData?.jobTitle!=null?
                                //       // SimpleText(
                                //       //   text:state.jobTitle!,
                                //       //   fontSize: 12.sp,
                                //       //   fontColor: const Color(0xff6C6C6C),
                                //       // ):
                                //       // const SizedBox(),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SimpleText(
                                  text: "Select Forum",
                                  fontSize: 14.sp,
                                  fontColor: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xffE8E8E8)
                                  )
                              ),
                              child: DropdownButtonFormField<String>(

                                icon: SvgPicture.asset("assets/svg/down_arrow.svg"),
                                value: selectForum.text.isEmpty
                                    ? null
                                    : selectForum.text,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    selectForum.text = newValue;
                                  }
                                },
                                items: forums.map<DropdownMenuItem<String>>(
                                      (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                ).toList(),

                                decoration: InputDecoration(
                                    hintText: "Select Forum",


                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xff888888),
                                      fontSize: 13.sp,
                                    )
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFieldContainer(
                              hintText: "Enter headline here",
                              titleBox: "Post Headlines",
                              controller: postTitle,
                            ),
                            headlinesMissing?
                            Align(
                              alignment: Alignment.centerRight,
                              child: SimpleText(
                                text: "Headline is missing",
                                fontSize: 12.sp,
                                fontColor: Colors.red,
                              ),
                            ):
                            const SizedBox(),
                            const SizedBox(height: 15,),
                            TextFieldContainer(
                              hintText: "Description",
                              titleBox: "What’s on your mind",
                              controller: description,
                              keyboardType:  TextInputType.text,
                              maxLines: 8,
                            ),
                            descriptionMissing?
                            Align(
                              alignment: Alignment.centerRight,
                              child: SimpleText(
                                text: "Description is missing",
                                fontSize: 12.sp,
                                fontColor: Colors.red,
                              ),
                            ):
                            const SizedBox(),
                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
