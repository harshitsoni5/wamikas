import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:wamikas/Models/event_model.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/TabBarChildrens/evnts_card.dart';
import '../../Utils/Components/Text/simple_text.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<EventModel> localSearch = [];
  bool isEmpty = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          UserProfileAppBar(size: size, title: "Upcoming Events"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffE8E8E8))),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    isEmpty = false;
                                    // if (localSearch.isNotEmpty &&
                                    //     value.isEmpty) {
                                    //   setState(() {
                                    //     isEmpty = false;
                                    //   });
                                    // } else {
                                    //   setState(() {
                                    //     isEmpty = true;
                                    //   });
                                    // }
                                    localSearch.clear();
                                  } else {
                                    localSearch = LocalData.featuredEvents
                                        .where((element) => element.eventName
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                    for (int i = 0;
                                        i < LocalData.trendingEvents.length;
                                        i++) {
                                      if (LocalData.trendingEvents[i].eventName
                                          .contains(value)) {
                                        localSearch
                                            .add(LocalData.trendingEvents[i]);
                                      }
                                    }
                                    for (int i = 0;
                                        i < LocalData.workshopEvents.length;
                                        i++) {
                                      if (LocalData.workshopEvents[i].eventName
                                          .contains(value)) {
                                        localSearch
                                            .add(LocalData.workshopEvents[i]);
                                      }
                                    }
                                    if (localSearch.isNotEmpty) {
                                      setState(() {
                                        isEmpty = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEmpty = true;
                                      });
                                    }
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "concert, comedy show etc...",
                                  hintStyle: TextStyle(
                                      color: Color(0xffC8C8C8), fontSize: 14)),
                            ),
                          ),
                          searchController.text.isEmpty
                              ? SvgPicture.asset("assets/svg/search.svg")
                              : InkWell(
                            onTap: (){
                              setState(() {
                                localSearch.clear();
                                isEmpty = false;
                              });
                              searchController.text="";
                            },
                            child: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 80),
                            child: const SimpleText(
                              text:
                                  "No search result is found for this event name ",
                              fontSize: 14,
                              fontColor: Colors.black38,
                            ),
                          )
                        : Column(
                            children: [
                              localSearch.isNotEmpty
                                  ? EventsCard(
                                      size: size,
                                      eventsData: localSearch,
                                      svg: null,
                                      titleName: "Search Result",
                                    )
                                  : const SizedBox(),
                              localSearch.isEmpty
                                  ? EventsCard(
                                      size: size,
                                      eventsData: LocalData.trendingEvents,
                                      svg: "assets/svg/flame.svg",
                                      titleName: "Trending Events",
                                    )
                                  : const SizedBox(),
                              localSearch.isEmpty
                                  ? EventsCard(
                                      size: size,
                                      eventsData: LocalData.featuredEvents,
                                      svg: "assets/svg/bookmark.svg",
                                      titleName: "Featured events",
                                    )
                                  : const SizedBox(),
                              localSearch.isEmpty
                                  ? EventsCard(
                                      size: size,
                                      eventsData: LocalData.workshopEvents,
                                      svg: "assets/svg/bookmark.svg",
                                      titleName: "Workshops",
                                    )
                                  : const SizedBox(),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
