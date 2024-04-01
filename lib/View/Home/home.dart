import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/my_flutter_app_icons.dart';
import '../../Utils/Color/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{
  late TabController tabController;
  int _bottomNavIndex = 0;
  int tabIndex=0;
  List<IconData> iconList = [
    MyFlutterApp.home,
    MyFlutterApp.explore,
    MyFlutterApp.jobs,
    MyFlutterApp.more
  ];
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if(tabController.indexIsChanging){
        tabIndex=tabController.index;
        setState(() {});
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const CircleAvatar(
          backgroundColor: ColorClass.textColor,
          radius: 35,
          child: Icon(Icons.add,color: Colors.white,size: 30,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          color: const Color(0xffF0F0F0),
          child: AnimatedBottomNavigationBar(
            icons: iconList,
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            notchMargin: 8,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            onTap: (index) => setState(() => _bottomNavIndex = index),
            backgroundColor: Colors.white,
            activeColor: ColorClass.textColor,
            inactiveColor: const Color(0xff9DB2CE),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    "assets/svg/logo.svg",
                    height: 44.h,
                    width: 55.w,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SimpleText(
                        text: "Welcome",
                        fontSize: 11.sp,
                        textHeight: 0.8,
                      ),
                      SimpleText(
                        text: "Anuradha!",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/message.svg",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          "assets/svg/notification.svg",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
           Container(
             margin: const EdgeInsets.symmetric(horizontal: 20),
             child: Row(
               children: [
                 SvgPicture.asset(
                   "assets/svg/profile.svg",
                   height: 40,
                   width: 40,
                 ),
                 Flexible(
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     margin: const EdgeInsets.symmetric(horizontal: 15),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: const Color(0xffE8E8E8),
                     ),
                     child: Row(
                       children: [
                         const Flexible(
                           child: TextField(
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: "What’s on your mind",
                                 hintStyle: TextStyle(
                                     color: Color(0xff888888)
                                 )
                             ),
                           ),
                         ),
                         SvgPicture.asset(
                           "assets/svg/search.svg",
                           color: Colors.black,
                         )
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
           const SizedBox(height: 10,),
           Expanded(
             child: Container(
               color: const Color(0xffF0F0F0),
               child: Column(
                 children: [
                   TabBar(
                     controller: tabController,
                     indicatorColor: ColorClass.textColor,
                     labelStyle: const TextStyle(color: ColorClass.textColor),
                     unselectedLabelColor: const Color(0xffB5B5B5),
                     tabs: <Widget>[
                       Tab(
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             tabIndex ==0 ?
                             SvgPicture.asset("assets/svg/forum.svg"):
                             SvgPicture.asset("assets/svg/forum.svg",
                               color: const Color(0xffB5B5B5),),
                             const SizedBox(
                               width: 5,
                             ),
                             SimpleText(
                               text: 'Forum',
                               fontSize: 12.sp,
                             ),
                           ],
                         ),
                       ),
                       Tab(
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             tabIndex == 1 ?
                             SvgPicture.asset("assets/svg/selected_event.svg",):
                             SvgPicture.asset("assets/svg/events.svg"),
                             const SizedBox(
                               width: 5,
                             ),
                             SimpleText(
                               text: 'Events',
                               fontSize: 12.sp,
                             ),
                           ],
                         ),
                       ),
                       Tab(
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             tabIndex ==2 ?
                             SvgPicture.asset("assets/svg/resources.svg",
                             color: ColorClass.textColor,)
                                 :SvgPicture.asset("assets/svg/resources.svg"),
                             const SizedBox(
                               width: 5,
                             ),
                             SimpleText(
                               text: 'Resources',
                               fontSize: 12.sp,
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 10,),
                   DefaultTabController(
                     length: 2,
                     child: Expanded(
                       child: TabBarView(
                         physics: const NeverScrollableScrollPhysics(),
                         controller: tabController,
                         children: [
                           Column(
                             children: [
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                 margin: const EdgeInsets.symmetric(horizontal: 15),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(8),
                                     color: Colors.white,
                                     border: Border.all(
                                         color: const Color(0xff544c4c33),
                                         width: 2
                                     )
                                 ),
                                 child: Row(
                                   children: [
                                     Flexible(
                                       child: TextField(
                                         decoration: InputDecoration(
                                             border: InputBorder.none,
                                             hintText: "Search topics",
                                             hintStyle: TextStyle(
                                                 color: const Color(0xffC8C8C8),
                                                 fontSize: 14.sp
                                             )
                                         ),
                                       ),
                                     ),
                                     SvgPicture.asset("assets/svg/search.svg")
                                   ],
                                 ),
                               ),
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                 margin: const EdgeInsets.symmetric(
                                     horizontal: 15, vertical: 10),
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.circular(8),
                                     border: Border.all(
                                         color: const Color(0xff544c4c33),
                                         width: 2
                                     )
                                 ),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Row(
                                       children: [
                                         SvgPicture.asset(
                                           "assets/svg/profile.svg",
                                           height: 40,
                                           width: 40,
                                         ),
                                         const SizedBox(
                                           width: 10,
                                         ),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             SimpleText(
                                               text: "Shaziya Ahmad",
                                               fontSize: 13.sp,
                                               textHeight: 0.9,
                                             ),
                                             SimpleText(
                                               text: "ahmad.shaziya@gmail.com",
                                               fontSize: 12.sp,
                                               fontColor: ColorClass.textColor,
                                             ),
                                           ],
                                         ),
                                         const Spacer(),
                                        const Icon(
                                            Icons.more_vert
                                        ),
                                       ],
                                     ),
                                     const SizedBox(height: 5,),
                                     SimpleText(
                                         text: "Forum-Free Photoshop tutorials",
                                         fontSize: 9.sp,
                                       fontColor: const Color(0xff455A64),
                                     ),
                                     SimpleText(
                                         text: "Topic-Remove Reflections",
                                         fontSize: 18.sp),
                                     const SizedBox(height: 10,),
                                     Container(
                                       padding: const EdgeInsets.all(5),
                                       decoration:  BoxDecoration(
                                         color: const Color(0xffEFEFEF),
                                         borderRadius: BorderRadius.circular(8)
                                       ),
                                       child: SimpleText(
                                         text: 'Threads#free',
                                         fontSize: 9.sp,
                                       ),
                                     ),
                                     const Divider(
                                       color: Color(0xffB5B5B5),
                                     ),
                                     Row(
                                       children: [
                                         SvgPicture.asset(
                                             "assets/svg/commentss.svg",
                                           height: 15,
                                           width: 15,
                                         ),
                                         const SizedBox(width: 5,),
                                         const SimpleText(
                                             text: "12 Replies",
                                             fontSize: 16),
                                         const Spacer(),
                                         const SimpleText(
                                             text: "1 min ago",
                                             fontSize: 16),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           Container(
                             margin: const EdgeInsets.symmetric(horizontal: 20),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 15,vertical: 5),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(8),
                                       color: Colors.white,
                                       border: Border.all(
                                           color: const Color(0xff544c4c33),
                                           width: 2
                                       )
                                   ),
                                   child: Row(
                                     children: [
                                      Flexible(
                                        child: TextField(
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "concert, comedy show etc...",
                                              hintStyle: TextStyle(
                                                  color: const Color(0xffC8C8C8),
                                                  fontSize: 14.sp)),
                                        ),
                                      ),
                                      SvgPicture.asset("assets/svg/search.svg")
                                     ],
                                   ),
                                 ),
                                 const SizedBox(height: 15,),
                                 Row(
                                   children: [
                                     SvgPicture.asset("assets/svg/flame.svg",
                                     height: 18,),
                                    const SizedBox(width: 5,),
                                    SimpleText(
                                        text: "Trending Events",
                                        fontSize: 14.sp,
                                      fontColor: ColorClass.primaryColor,
                                    ),
                                  ],
                                 ),
                                 const SizedBox(height: 10,),
                                 Container(
                                   width: size.width*0.6,
                                   padding: const EdgeInsets.only(bottom: 10),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     color: Colors.white
                                   ),
                                   child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                       Image.asset(
                                         "assets/images/events.png",
                                         width: size.width*0.6,
                                         fit: BoxFit.cover,
                                       ),
                                       Container(
                                         padding: const EdgeInsets.only(left: 10),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             SimpleText(
                                               text: "The Grub Fest - Spring Fling",
                                               fontSize: 14.sp,
                                               fontWeight: FontWeight.w500,),
                                             const SizedBox(height: 15,),
                                             Row(
                                               children: [
                                                 SvgPicture.asset("assets/svg/calender.svg"),
                                                 const SizedBox(width: 5,),
                                                 SimpleText(
                                                   text: "March 30-31st | 2PM Onwards",
                                                   fontSize: 10.sp,
                                                   fontColor: const Color(0xff455A64),
                                                 ),
                                               ],
                                             ),
                                             Row(
                                               children: [
                                                 SvgPicture.asset("assets/svg/map.svg"),
                                                 const SizedBox(width: 5,),
                                                 SimpleText(
                                                   text: "JLN Stadium, Gate No. 14, Delhi",
                                                   fontSize: 10.sp,
                                                   fontColor: const Color(0xff455A64),
                                                 ),
                                               ],
                                             ),
                                             const SizedBox(height: 8,),
                                           ],
                                         ),
                                       ),
                                       Container(
                                           margin: const EdgeInsets.symmetric(horizontal: 10),
                                           decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.circular(10),
                                               border: Border.all(
                                                   color: ColorClass.primaryColor
                                               )
                                           ),
                                           padding: const EdgeInsets.symmetric(vertical: 5),
                                           child: Center(
                                             child: SimpleText(
                                               text: "Register Now!!",
                                               fontColor:ColorClass.primaryColor,
                                               fontSize: 14.sp,
                                             ),
                                           )
                                       )
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           Container(
                             margin: const EdgeInsets.symmetric(horizontal: 20),
                             child: Column(
                               children: [
                                 Row(
                                   children: [
                                     SvgPicture.asset(
                                       "assets/svg/profile.svg",
                                       height: 20,
                                       width: 20,
                                     ),
                                     const SizedBox(
                                       width: 10,
                                     ),
                                     SimpleText(
                                       text: "w/graphic_design",
                                       fontSize: 14.sp,
                                       fontColor: ColorClass.userColor,
                                     )
                                   ],
                                 )
                               ],
                             ),
                           )
                         ],
                       ),
                     ),
                   )
                 ],
               ),
             ),
           )
          ],
        ),
      )
    );
  }
}
