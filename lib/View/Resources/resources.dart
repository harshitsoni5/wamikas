import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/resources_model.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../Utils/Components/AppBar/user_profile_app_bar.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Tiles/resources_card.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  List<ResourcesModel> localSearch = [];
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
          UserProfileAppBar(size: size, title: "Resources"),
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
                                    localSearch = LocalData.personalGrowth
                                        .where((element) => element.title
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                    for (int i = 0;
                                        i < LocalData.personalFinance.length;
                                        i++) {
                                      if (LocalData.personalFinance[i].title
                                          .contains(value)) {
                                        localSearch
                                            .add(LocalData.personalFinance[i]);
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
                                  onTap: () {
                                    setState(() {
                                      isEmpty=false;
                                      localSearch.clear();
                                      searchController.text="";
                                    });
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
                                  "No search result is found for this resource name ",
                              fontSize: 14,
                              fontColor: Colors.black38,
                            ),
                          )
                        :SingleChildScrollView(
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          localSearch.isNotEmpty
                              ? const SimpleText(
                            text: "Search Result",
                            fontSize: 14,
                            fontColor: Color(0xff570035),
                          )
                              : const SizedBox(),
                          localSearch.isNotEmpty
                              ? ResourcesCard(
                            list: localSearch,
                          )
                              : const SizedBox(),
                          localSearch.isEmpty
                              ? const SimpleText(
                            text: "Personal Finance",
                            fontSize: 14,
                            fontColor: Color(0xff570035),
                          )
                              : const SizedBox(),
                          const SizedBox(
                            height: 5,
                          ),
                          localSearch.isEmpty
                              ? ResourcesCard(
                            list: LocalData.personalFinance,
                          )
                              : const SizedBox(),
                          localSearch.isEmpty
                              ? const SizedBox(
                            height: 25,
                          )
                              : const SizedBox(),
                          localSearch.isEmpty
                              ? const SimpleText(
                            text: "Personal Growth",
                            fontSize: 14,
                            fontColor: Color(0xff570035),
                          )
                              : const SizedBox(),
                          localSearch.isEmpty
                              ? ResourcesCard(
                            list: LocalData.personalGrowth,
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
