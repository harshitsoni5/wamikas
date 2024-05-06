import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../Core/FirebasePushNotificationService/firebase_push_notificatioin_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Tiles/settings_tiles.dart';
import '../../Utils/Routes/route_name.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {

  bool _notificationEnabled = false;

  @override
  void initState() {
    loadNotification();
    super.initState();
  }

  void loadNotification()async{
    bool notification =await SharedFcmToken.getFcmToken("notification");
    setState(() {
      _notificationEnabled =notification;
    });
  }

  // void loadNotificationStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _notificationEnabled = prefs.getBool('notification_enabled') ?? false;
  //   });
  // }


  // void requestNotificationPermission() async {
  //   PermissionStatus status = await Permission.notification.request();
  //   if (status == PermissionStatus.granted) {
  //     saveNotificationStatus(true);
  //   } else {
  //     setState(() {
  //       _notificationEnabled = false;
  //     });
  //     saveNotificationStatus(false);
  //   }
  // }

  Future<void> showLogoutDialog(BuildContext context, Size size) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
              height: size.height * 0.17,
              width: size.width - 30,
              padding:
              const EdgeInsets.only(bottom: 15, left: 20, right: 20, top: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SimpleText(
                    text: "Log Out",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SimpleText(
                    text: 'Are you sure you want to logout ?',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontColor: Colors.blueGrey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const SimpleText(
                            text: "Cancel",
                            fontSize: 15,
                            fontColor: ColorClass.primaryColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            SharedData.clearPref("phone");
                            SharedData.clearPref("uid");
                            SharedData.clearPref("profile");
                            SharedData.clearPref("name");
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteName.signIn, (route) => false);
                          },
                          child: const SimpleText(
                            text: "Ok",
                            fontSize: 15,
                            fontColor: ColorClass.primaryColor,
                          ))
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          UserProfileAppBar(size: size,title: "Settings"),
          const SizedBox(height: 20,),
          Column(
        children: [
          SettingsTiles(
            tileName: "My Account",
            onPressed: () {
              Navigator.of(context).pushNamed(RouteName.userProfile);
            },
            isLastTile: true,
            assetName: "assets/svg/user_dp.svg",
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Privacy Policy",
            onPressed: () {

            },
            isLastTile: true,
            assetName: "assets/svg/privacy_policy.svg",
            hideArrow: true,
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Terms Of Use",
            onPressed: () {

            },
            isLastTile: true,
            assetName: "assets/svg/terms_of_use.svg",
            hideArrow: true,
          ),
          const SizedBox(height: 15,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                  },
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SvgPicture.asset("assets/svg/notification_outline.svg",height: 22,width: 22,)
                      ),
                      const SizedBox(width: 10,),
                      SimpleText(
                        text: "Notifications",
                        fontSize: 14.5.sp,
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      Switch(
                        activeColor: ColorClass.textColor,
                        value: _notificationEnabled,
                        onChanged: (value) {
                          if(value && _notificationEnabled){
                          }
                          else if (value==false && _notificationEnabled==false){

                          }
                         else if(value){
                           SharedFcmToken.setNotification(true);
                         }else{
                            PushNotificationServices.firebaseCloudMessaging();
                           SharedFcmToken.setNotification(false);
                         }
                          setState(() {
                            _notificationEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Feedback",
            onPressed: () {

            },
            isLastTile: true,
            assetName: "assets/svg/Feedback.svg",
            hideArrow: true,
          ),
          const SizedBox(height: 15,),
          SettingsTiles(
            tileName: "Logout",
            onPressed: () {
            showLogoutDialog(context, size);
            },
            isLastTile: true,
            assetName: "assets/svg/logout.svg",
          ),
        ],
      ),
        ],
      ),
    );
  }
}
