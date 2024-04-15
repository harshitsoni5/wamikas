import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import '../../Bloc/UserProfileBloc/InterestsCubit/interests_cubit.dart';
import '../../Bloc/UserProfileBloc/InterestsCubit/interests_state.dart';
import '../../Models/user_profile_model.dart';
import '../../Utils/Components/AppBar/back_button_appbar.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';

class InterestAndPreferences extends StatefulWidget {
  final UserProfileModel userData;

  const InterestAndPreferences({super.key, required this.userData});

  @override
  State<InterestAndPreferences> createState() => _InterestAndPreferencesState();
}

class _InterestAndPreferencesState extends State<InterestAndPreferences> {
  final List interests = [
    "Personal Finance",
    "Professional Growth",
    "Work-Life Balance",
    "Entrepreneurship",
    "Tech and Innovation",
    "Women Empowerment",
    "Career Development",
    "Personal Growth and Development"
  ];
  final List eventsOrGroupRec = [
    "Make New Friends",
    "Practice a hobby with others",
    "Build your professional network",
    "Socialize with others"
  ];
  List selectedInterests = [];
  List selectedEventAndRec = [];

  @override
  void initState() {
    if(widget.userData.eventsOrGroupRec != null
        && widget.userData.eventsOrGroupRec!.isNotEmpty){
      for(int i=0;i<widget.userData.eventsOrGroupRec!.length;i++){
        selectedEventAndRec.add(widget.userData.eventsOrGroupRec?[i]);
      }
    }
    if(widget.userData.interests != null
        && widget.userData.interests!.isNotEmpty){
      for(int i=0;i<widget.userData.interests!.length;i++){
        selectedInterests.add(widget.userData.interests?[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    final double topPadding = safeAreaInsets.top;
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Column(
        children: [
          BackButtonAppBar(
            size: size,
            title: "Interest & Preferences",
            topPadding: topPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: interests.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (selectedInterests.contains(interests[index])) {
                              selectedInterests.removeWhere(
                                      (element) => element == interests[index]);
                              setState(() {});
                            } else {
                              selectedInterests.add(interests[index]);
                              setState(() {});
                            }
                          },
                          child: selectedInterests.contains(interests[index])
                              ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xffE12799),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xffFFC8F5), width: 2)),
                            child: Row(
                              children: [
                                Flexible(
                                    child: SimpleText(
                                      text: interests[index],
                                      fontSize:  size.width <390? 11:13,
                                    )),
                                const Spacer(),
                                SvgPicture.asset(
                                  "assets/svg/minus.svg",
                                  height: size.width <390? 35:40,
                                ),
                              ],
                            ),
                          )
                              : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: const Color(0xffE9E9E9))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: SimpleText(
                                      text: interests[index],
                                      fontSize: size.width <390? 11:13,
                                    )),
                                SvgPicture.asset(
                                  "assets/svg/plus.svg",
                                  height: size.width <390? 35:40,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 3),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleText(
                          text: "What are you looking for",
                          fontSize: 16.sp,
                          fontColor: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SimpleText(
                          text:
                          "Select at least one preference for future events and group recommendations.",
                          fontSize: 14.sp,
                          fontColor: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eventsOrGroupRec.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (selectedEventAndRec
                                      .contains(eventsOrGroupRec[index])) {
                                    selectedEventAndRec.removeWhere(
                                            (element) =>
                                        element == eventsOrGroupRec[index]);
                                    setState(() {});
                                  } else {
                                    selectedEventAndRec.add(eventsOrGroupRec[index]);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xffE9E9E9),
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SimpleText(
                                        text: eventsOrGroupRec[index],
                                        fontSize: 14,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: selectedEventAndRec
                                                    .contains(eventsOrGroupRec[index])
                                                    ? ColorClass.userColor
                                                    : const Color(0xffCFCFCF))),
                                        child: selectedEventAndRec
                                            .contains(eventsOrGroupRec[index])
                                            ? const Icon(
                                          Icons.check,
                                          color: ColorClass.userColor,
                                          size: 20,
                                        )
                                            : const SizedBox(
                                          height: 20,
                                          width: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: BlocConsumer<InterestsCubit, InterestsState>(
                      listener: (context, state) {
                        if(state is InterestsSuccess){
                          Fluttertoast.showToast(
                              msg: "Interests updated successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 15.0
                          );
                        }
                        if(state is InterestsNotSelected){
                          Fluttertoast.showToast(
                              msg: "Please select at least one interest",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 15.0
                          );
                        }
                      },
                      builder: (context, state) {
                        if(state is InterestsLoading){
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return InkWell(
                            onTap: () {
                              BlocProvider.of<InterestsCubit>(context).
                              updateInterests(selectedInterests, selectedEventAndRec);
                            },
                            child: RoundAuthButtons(size: size, btnText: "Update"));
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
