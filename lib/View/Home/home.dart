import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/HomeBloc/home_event.dart';
import 'package:wamikas/Bloc/HomeBloc/home_state.dart';
import 'package:wamikas/Models/post_model.dart';
import 'package:wamikas/Models/resources_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Components/TabBarChildrens/forums_card.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/AppBar/home_app_bar.dart';
import '../../Utils/Components/TabBarChildrens/evnts_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{
  late TabController tabController;
  int tabIndex=0;
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
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HomeSuccess) {
          final List<PostModel> posts = state.listOfAllPost;
          final UserProfileModel userData = state.userData;
          return Column(
            children: [
              HomeAppBar(userData: userData,),
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
                              ForumCard(
                                userData: userData,
                                size: size,
                                posts: posts,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
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
                                            const Flexible(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                    "concert, comedy show etc...",
                                                    hintStyle: TextStyle(
                                                        color: Color(0xffC8C8C8),
                                                        fontSize: 14)),
                                              ),
                                            ),
                                            SvgPicture.asset("assets/svg/search.svg")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15,),
                                      EventsCard(
                                        size: size,
                                        eventsData: state.trendingData,
                                        svg: "assets/svg/flame.svg",
                                        titleName: "Trending Events",
                                      ),
                                      EventsCard(
                                        size: size,
                                        eventsData: state.featuredData,
                                        svg: "assets/svg/bookmark.svg",
                                        titleName: "Featured events",
                                      ),
                                      EventsCard(
                                        size: size,
                                        eventsData: state.workshopData,
                                        svg: "assets/svg/bookmark.svg",
                                        titleName: "Workshops",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
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
                                            const Flexible(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                    "concert, comedy show etc...",
                                                    hintStyle: TextStyle(
                                                        color: Color(0xffC8C8C8),
                                                        fontSize: 14)),
                                              ),
                                            ),
                                            SvgPicture.asset("assets/svg/search.svg")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15,),
                                      const SimpleText(
                                        text: "Personal Finance",
                                        fontSize: 14,
                                        fontColor: Color(0xff570035),
                                      ),
                                      const SizedBox(height: 5,),
                                      Resources(
                                        list: state.personalFinance,
                                      ),
                                      const SizedBox(height: 25,),
                                      const SimpleText(
                                        text: "Personal Growth",
                                        fontSize: 14,
                                        fontColor: Color(0xff570035),
                                      ),
                                      Resources(
                                        list: state.personalGrowth,
                                      ),
                                      const SizedBox(height: 5,),
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
                ),
              )
            ],
          );
        } else if (state is HomeError) {
          return Center(
            child: SimpleText(
              text: 'Oops something went wrong',
              fontSize: 14.sp,
            ),
          );
        } else {
          return Center(
            child: SimpleText(
              text: "Please try again after some time ",
              fontSize: 14.sp,
            ),
          );
        }
      },
    ));
  }
}

class Resources extends StatelessWidget {
  final List<ResourcesModel> list;
  const Resources({
    super.key, required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
        itemBuilder: (context, index) {
      return GestureDetector(
        onTap: ()async{
          if (!await launch(
          Uri.parse(list[index].link).toString())) {
          throw Exception('Could not launch url');
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xffCFCFCF),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    list[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     SimpleText(
                        text: list[index].title,
                        fontSize: 13),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/ph_video-light.svg",
                          height: 15,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                         SimpleText(
                          text: "By- ${list[index].by}",
                          fontSize: 13,
                          fontColor: const Color(0xffE52A9C),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset("assets/svg/bookmark.svg")),
              )
            ],
          ),
        ),
      );
    });
  }
}

