import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wamikas/Bloc/NotificationBloc/notification_cubit.dart';
import 'package:wamikas/Bloc/NotificationBloc/notification_state.dart';
import 'package:wamikas/Models/notification_model.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import '../../Utils/Components/Text/simple_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    BlocProvider.of<NotificationCubit>(context).getAllNotification();
    super.initState();
  }
  
  String getTime(var timestamp) {
    final postTime;
    if(timestamp is Timestamp){
      postTime = timestamp.toDate();
    }else{
      postTime = DateTime.parse(timestamp.toString());
    }
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset("assets/svg/ep_back (2).svg")),
                  const SizedBox(width: 15,),
                  const SimpleText(
                    text: "Notifications",
                    fontSize: 22,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if(state is NotificationLoading){
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                else if(state is NotificationSuccess){
                  List<NotificationModel> lists = state.listOfNotification;
                  return lists.isEmpty ? const Expanded(child: Center(
                    child: SimpleText(
                      text: "No Notifications yet",
                      fontSize: 16,
                      fontColor: Colors.black38,
                    ),
                  )):Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: lists.length,
                      itemBuilder: (context,index) {
                        return InkWell(
                          onTap: (){
                                    Navigator.of(context).pushNamed(
                                        RouteName.notificationPost,
                                        arguments: lists[index].id);
                                  },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                            child: Row(
                              children: [
                                lists[index].profilePic == null
                                    ? SvgPicture.asset(
                                  "assets/svg/profile.svg",
                                  height: 40,
                                  width: 40,
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                  child: Image.network(
                                    lists[index].profilePic!,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SimpleText(text: lists[index].name, fontSize: 15,
                                        fontColor: const Color(0xffE52A9C),),
                                      const SizedBox(height: 3,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: SimpleText(
                                              text: "commented on your post: ${lists[index].title}",
                                              fontSize: 14,
                                              fontColor: Colors.black,
                                              textHeight: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: SimpleText(
                                              text: getTime(lists[index].time),
                                              fontSize: 15,
                                              fontColor: Colors.grey,
                                            ),
                                          )
                                        ],
                                      )
                                    ],),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  );
                }
                else{
                  return const Expanded(
                    child: Center(
                      child: SimpleText(
                        text: "Oops something went wrong",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
