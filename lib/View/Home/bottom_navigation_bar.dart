import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wamikas/View/More/more.dart';
import 'package:wamikas/View/Serach/search.dart';
import 'package:wamikas/View/UserDetails/user_profile.dart';
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
    const Search(),
    const UserProfile(),
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

  List routes= [
    RouteName.home,
    "RouteName.search",
    RouteName.userProfile,
    "RouteName.settings",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteName.forum,
          );
        },
        child: const CircleAvatar(
          backgroundColor: ColorClass.textColor,
          radius: 35,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: const Color(0xffF0F0F0),
        child: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: isActive
                        ? ColorClass.textColor
                        : const Color(0xff9DB2CE),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    iconsName[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? ColorClass.textColor
                          : const Color(0xff9DB2CE),
                    ),
                  ),
                ],
              ),
            );
          },
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchMargin: 8,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          backgroundColor: Colors.white,
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black
      //             .withOpacity(0.2), // Color and opacity of the shadow
      //         spreadRadius: 5, // Spread radius of the shadow
      //         blurRadius: 10, // Blur radius of the shadow
      //         offset: const Offset(
      //             0, -3), // Offset of the shadow (you can adjust the values)
      //       ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     clipBehavior: Clip.hardEdge,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(30.0),
      //       topRight: Radius.circular(30.0),
      //     ),
      //     child: BottomNavigationBar(
      //       type: BottomNavigationBarType.fixed,
      //       backgroundColor:
      //       darkTheme.darkTheme ? Colors.black38 : Colors.white,
      //       selectedItemColor: ColorClass.redColor,
      //       unselectedItemColor: Colors.grey,
      //       currentIndex: pageIndex,
      //       showSelectedLabels: false,
      //       showUnselectedLabels: false,
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(FontAwesomeIcons.house),
      //           label: "Home",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.favorite),
      //           label: "Wishlist",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(FontAwesomeIcons.bagShopping),
      //           label: "My Orders",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(FontAwesomeIcons.solidUser),
      //           label: "Profile",
      //         )
      //       ],
      //       onTap: (value) {
      //         setState(() {
      //           pageIndex = value;
      //         });
      //       },
      //     ),
      //   ),
      // ),
      body: _selectedPage[_bottomNavIndex],
    );
  }
}
