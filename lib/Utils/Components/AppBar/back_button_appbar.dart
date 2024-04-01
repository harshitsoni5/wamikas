import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../Text/simple_text.dart';

class BackButtonAppBar extends StatelessWidget {
  final String title;
  const BackButtonAppBar({
    super.key,
    required this.size,
    required this.title,
  });

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
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: size.height*0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<UserProfileBloc>(context).
                        add(GetUserDataEvent());
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
                    fontSize: 24,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SvgPicture.asset(
                "assets/svg/w-logo.svg",
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
