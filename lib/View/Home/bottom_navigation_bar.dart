import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wamikas/View/Events/event.dart';
import 'package:wamikas/View/Forum/forum_screeen.dart';
import 'package:wamikas/View/More/more.dart';
import 'package:wamikas/View/Resources/resources.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Routes/route_name.dart';
import '../../my_flutter_app_icons.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _selectedPage = [
    const HomeScreen(),
    const Events(),
    const ForumScreen(userData: null),
    const Resources(),
    const More(),
  ];
  int _bottomNavIndex = 0;

  List<IconData> iconList = [
    MyFlutterApp.home,
    MyFlutterApp.explore,
    Icons.person,
    MyFlutterApp.more
  ];

  List iconsName =[
    "Home",
    "Search",
    "Profile",
    "More",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton:InkWell(
      //   onTap: () {
      //     Navigator.of(context).pushNamed(
      //       RouteName.forum,
      //     );
      //   },
      //   child: const CircleAvatar(
      //     backgroundColor: ColorClass.textColor,
      //     radius: 35,
      //     child: Icon(
      //       Icons.add,
      //       color: Colors.white,
      //       size: 30,
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.miniCenterDocked,
      // backgroundColor: Colors.white,
      // bottomNavigationBar: Container(
      //   color: const Color(0xffF0F0F0),
      //   child: AnimatedBottomNavigationBar.builder(
      //     itemCount: iconList.length,
      //     tabBuilder: (int index, bool isActive) {
      //       return Padding(
      //         padding: const EdgeInsets.only(top: 8.0),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Icon(
      //               iconList[index],
      //               size: 24,
      //               color: isActive
      //                   ? ColorClass.textColor
      //                   : const Color(0xff9DB2CE),
      //             ),
      //             const SizedBox(height: 2),
      //             Text(
      //               iconsName[index],
      //               style: TextStyle(
      //                 fontSize: 12,
      //                 color: isActive
      //                     ? ColorClass.textColor
      //                     : const Color(0xff9DB2CE),
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //     activeIndex: _bottomNavIndex,
      //     gapLocation: GapLocation.center,
      //     notchMargin: 8,
      //     notchSmoothness: NotchSmoothness.verySmoothEdge,
      //     onTap: (index) => setState(() => _bottomNavIndex = index),
      //     backgroundColor: Colors.white,
      //   ),
      // ),
      bottomNavigationBar: SizedBox(
        height: size.height<595?size.height*0.12:size.height*0.085,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:Colors.white,
          selectedItemColor: ColorClass.textColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _bottomNavIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/clarity_home-line.svg",
              color: _bottomNavIndex==0?ColorClass.textColor: Colors.grey,
                height: 25,),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/carbon_event.svg",
                color: _bottomNavIndex==1?ColorClass.textColor:null,
                height: 25,),
              label: "Events",
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: CircleAvatar(
                  backgroundColor: ColorClass.textColor,
                  radius: 18,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/icon-park-outline_medical-files.svg",
                color: _bottomNavIndex==3?ColorClass.textColor:null,
              height: 25,),
              label: "Resources",
            ),
            BottomNavigationBarItem(
              icon:  SvgPicture.asset("assets/svg/icon-park-outline_more-app.svg",
                color: _bottomNavIndex==4?ColorClass.textColor:null,
                height: 25,),
              label: "More",
            )
          ],
          onTap: (value) {
            setState(() {
              if(value==2){
                Navigator.of(context).pushNamed(
                  RouteName.forum,
                );
              }else{
                _bottomNavIndex = value;
              }
            });
          },
        ),
      ),
      body: _selectedPage[_bottomNavIndex],
    );
  }
}
