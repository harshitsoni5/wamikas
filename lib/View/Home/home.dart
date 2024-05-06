import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/HomeBloc/home_event.dart';
import 'package:wamikas/Bloc/HomeBloc/home_state.dart';
import 'package:wamikas/Models/post_model.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Components/TabBarChildrens/forums_card.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/AppBar/home_app_bar.dart';
import '../../widgets/home_shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeInitialEvent());
    super.initState();
  }
  Future refresh()async{
    BlocProvider.of<HomeBloc>(context).add(
        HomeInitialEvent());
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
          return const HomeShimmerLoading();
        } else if (state is HomeSuccess) {
          final List<PostModel> posts = state.listOfAllPost;
          final UserProfileModel userData = state.userData;
          return RefreshIndicator(
            onRefresh: refresh,
            child: Column(
              children: [
                HomeAppBar(userData: userData),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 15),
                    color: const Color(0xffF0F0F0),
                    child: ForumCard(
                      userData: userData,
                      size: size,
                      posts: posts,
                      fromProfileScreen: false,
                    ),
                  ),
                ),
              ],
            ),
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


