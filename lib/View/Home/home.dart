import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wamikas/Bloc/CommentsBloc/comments_bloc.dart';
import 'package:wamikas/Bloc/CommentsBloc/comments_event.dart';
import 'package:wamikas/Bloc/CommentsBloc/comments_state.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/HomeBloc/home_event.dart';
import 'package:wamikas/Bloc/HomeBloc/home_state.dart';
import 'package:wamikas/Models/post_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'package:wamikas/my_flutter_app_icons.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Routes/route_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{
  TextEditingController commentsController =TextEditingController();
  late TabController tabController;
  int _bottomNavIndex = 0;
  int tabIndex=0;
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

  void showBottomSheet({
    required Size size,
    required String postId,
    required UserProfileModel userData,
    required List comments,
    required PostModel postModel,
  }) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              if(state is CommentsSuccess){
                final comments = state.comments;
                return Container(
                  margin:const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  height:size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SimpleText(
                            text: "Most relevant",
                            fontSize: 12.sp,
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data = comments[index];
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: CircleAvatar(
                                          radius: 20,
                                          child:data["profile_pic"] == null?
                                          Image.asset("assets/images/dp.png"):
                                          Image.network(
                                            data["profile_pic"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SimpleText(
                                              text: data["name"],
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SimpleText(
                                              text:
                                              data["comments_desc"],
                                              fontSize: 11.sp,
                                              fontColor: const Color(0xff696969),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6,),
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/svg/like_wami.svg"),
                                      const SizedBox(width: 5),
                                      SimpleText(text: "Like", fontSize: 10.sp),
                                      const Spacer(),
                                      SimpleText(text: "2 hr ago", fontSize: 10.sp),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 15,top: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffDEDEDE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  onSubmitted: (val){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        ReduceBottomSheetSize(
                                            comments: state.comments,
                                            isClicked: false));
                                  },
                                  onTap: (){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        ReduceBottomSheetSize(
                                            comments: state.comments,
                                            isClicked: true));
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Start Typing here",
                                    hintStyle: TextStyle(
                                      color: Color(0xffAFAFAF),
                                      fontSize: 14,
                                    ),
                                  ),
                                  controller: commentsController,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(commentsController.text.isNotEmpty){
                                    BlocProvider.of<CommentsBloc>(context).add(
                                        PostAComment(
                                            postId: postId,
                                            commentDesc:
                                            commentsController.text,
                                            uid: userData.phone,
                                            comments: comments,
                                            userData: userData,
                                            postModel: postModel
                                        ));
                                    commentsController.clear();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  child: SvgPicture.asset("assets/svg/message_icon.svg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }


  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeInitialEvent());
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
        child: BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(state is HomeLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else if(state is HomeSuccess){
      final List<PostModel> posts= state.listOfAllPost;
      final UserProfileModel userData= state.userData;
      return Scaffold(
        floatingActionButton: InkWell(
          onTap:(){
            Navigator.of(context).pushNamed(
              RouteName.forum,
              arguments: userData
            );
          },
          child: const CircleAvatar(
            backgroundColor: ColorClass.textColor,
            radius: 35,
            child: Icon(Icons.add,color: Colors.white,size: 30,),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          color: const Color(0xffF0F0F0),
          child: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(routes[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconList[index],
                        size: 24,
                        color: isActive ? ColorClass.textColor:const Color(0xff9DB2CE),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        iconsName[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? ColorClass.textColor: const Color(0xff9DB2CE),
                        ),
                      ),
                    ],
                  ),
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
                        text: userData.name,
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
                  userData.profilePic==null?
                  SvgPicture.asset(
                    "assets/svg/profile.svg",
                    height: 40,
                    width: 40,
                  ):
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      userData.profilePic!,
                      height: 40,
                      width: 40,
                    ),
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
                          Flexible(
                            child: TextField(
                              onTap:(){
                                Navigator.of(context).pushNamed(
                                    RouteName.forum,
                                    arguments: userData
                                );
                              },
                              readOnly: true,
                              decoration: const InputDecoration(
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
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: posts.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
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
                                                userData.profilePic==null?
                                                SvgPicture.asset(
                                                  "assets/svg/profile.svg",
                                                  height: 40,
                                                  width: 40,
                                                ):
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Image.network(
                                                    userData.profilePic!,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SimpleText(
                                                      text: posts[index].name,
                                                      fontSize: 13.sp,
                                                      textHeight: 0.9,
                                                    ),
                                                    SimpleText(
                                                      text: posts[index].emailId,
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
                                              text: posts[index].forumName,
                                              fontSize: 9.sp,
                                              fontColor: const Color(0xff455A64),
                                            ),
                                            const SizedBox(height: 5,),
                                            SimpleText(
                                              text: posts[index].forumTitle,
                                              fontSize: 18.sp,
                                              textHeight: 0.9,
                                            ),
                                            const SizedBox(height: 2,),
                                            SimpleText(
                                              text: posts[index].forumContent,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w300,
                                              fontColor: const Color(0xff777777),
                                            ),
                                            const Divider(
                                              color: Color(0xffB5B5B5),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    showBottomSheet(
                                                        size: size,
                                                      postId: posts[index].id,
                                                      userData: state.userData,
                                                      comments: posts[index].comments,
                                                      postModel: posts[index]
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/svg/commentss.svg",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                                posts[index].comments.isNotEmpty?
                                                InkWell(
                                                  onTap: (){
                                                    BlocProvider.of<CommentsBloc>(context)
                                                    .add(CommentsInit(
                                                      comments: posts[index].comments,
                                                      userData: state.userData,

                                                    ));
                                                    showBottomSheet(
                                                      size: size,
                                                      postId: posts[index].id,
                                                        userData: state.userData,
                                                      comments: posts[index].comments,
                                                        postModel: posts[index]
                                                    );
                                                  },
                                                  child:  SimpleText(
                                                      text: "${
                                                          posts[index]
                                                              .comments.length
                                                              .toString()
                                                      } Replies",
                                                      fontSize: 16),
                                                ):
                                                const SizedBox(),
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
                                  );
                                }),
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
      );
        } else if (state is HomeError) {
          return Scaffold(
            body: Center(
              child: SimpleText(
                text: 'Oops something went wrong',
                fontSize: 14.sp,
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: SimpleText(
                text: "Please try again after some time ",
                fontSize: 14.sp,
              ),
            ),
          );
        }
      },
    ));
  }
}
