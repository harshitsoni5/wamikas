import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Bloc/UserProfileBloc/InterestsCubit/interests_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/InterestsCubit/interests_state.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Buttons/back_button_with_logo.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Routes/route_name.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List interests =[
    "Personal Finance",
    "Professional Growth",
    "Work-Life Balance",
    "Entrepreneurship",
    "Tech and Innovation",
    "Women Empowerment",
    "Career Development",
    "Personal Growth and Development"
  ];
  List selectedInterests=[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const BackButtonWithLogo(),
            const SimpleText(
              text: "Interests",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 10,
            ),
            const SimpleText(
              text:
              "Select at least one interest for future events \n and group recommendations.",
              fontSize: 15,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: interests.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      if(selectedInterests.contains(interests[index])){
                        selectedInterests.removeWhere((element) => element==interests[index]);
                        setState(() {});
                      }else{
                        selectedInterests.add(interests[index]);
                        setState(() {});
                      }
                    },
                    child:selectedInterests.contains(interests[index])?
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xffE12799),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xffFFC8F5),
                            width: 2
                          )
                      ),
                      child: Row(
                        children: [
                          Flexible(child: SimpleText(text: interests[index], fontSize: 14,)),
                          const SizedBox(width: 5,),
                          SvgPicture.asset("assets/svg/minus.svg",height: 40,),
                        ],
                      ),
                    )
                    :Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xffE9E9E9)
                        )
                      ),
                      child: Row(
                        children: [
                          Flexible(child: SimpleText(text: interests[index], fontSize: 14,)),
                          const SizedBox(width: 5,),
                          SvgPicture.asset("assets/svg/plus.svg",height: 40,),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                  childAspectRatio: 3
              ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocConsumer<InterestsCubit, InterestsState>(
                    listener: (context, state) {
                      if(state is InterestsSuccess){
                        Navigator.of(context).pushNamed(RouteName.userProfile);
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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                            onTap: (){
                              BlocProvider.of<InterestsCubit>(context).
                              interests(selectedInterests);
                            },
                            child: RoundAuthButtons(size: size, btnText: "Create Profile"))
                    );
                    },
                  ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(RouteName.bottomBar);
                      },
                      child: const SimpleText(
                        text: "Skip >>",
                        fontSize: 15,
                        fontColor: ColorClass.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
