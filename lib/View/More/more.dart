import 'package:flutter/material.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Tiles/settings_tiles.dart';
import '../../Utils/Routes/route_name.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0,top: 5),
            child: Row(
              children: [
                SizedBox(width: 15,),
                SimpleText(
                  text: "Settings",
                  fontSize: 22,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          SettingsTiles(
            tileName: "Privacy Policy",
            onPressed: () {

            },
            isLastTile: true,
            assetName: "assets/svg/logout.svg",
            hideArrow: true,
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Terms Of Use",
            onPressed: () {

            },
            isLastTile: true,
            assetName: "assets/svg/logout.svg",
            hideArrow: true,
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Logout",
            onPressed: () {
              SharedData.clearPref("phone");
              SharedData.clearPref("uid");
              SharedData.clearPref("profile");
              SharedData.clearPref("name");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.signIn, (route) => false);
            },
            isLastTile: true,
            assetName: "assets/svg/logout.svg",
          ),
        ],
      ),
    );
  }
}
