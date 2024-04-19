import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../Text/simple_text.dart';

class BackButtonAppBar extends StatelessWidget {
  final String title;
  final bool isUpdated;
  const BackButtonAppBar({
    super.key,
    required this.size,
    required this.title,
    required this.topPadding,
    required this.isUpdated,
  });
  final double topPadding;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          "assets/svg/semi_circle.svg",
          height: size.height * 0.15,
        ),
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
          padding: EdgeInsets.only(top: topPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        print(isUpdated);
                        if(isUpdated){
                          BlocProvider.of<UserProfileBloc>(
                              context)
                              .add(GetUserDataEvent());
                        }else{
                          BlocProvider.of<UserProfileBloc>(
                              context)
                              .add(GetUserDataWithoutLoading());
                        }
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        "assets/svg/ep_back (2).svg",
                        height: 35,
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  SimpleText(
                    text: title,
                    fontSize:  size.width <400? 20:22,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SvgPicture.asset(
                "assets/svg/w-logo.svg",
                height:  size.width <400? 35:40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
