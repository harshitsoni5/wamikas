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
  List<ResourcesModel> localSearch =[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          UserProfileAppBar(size: size,title: "Resources"),
          Expanded(
            child: Container(
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
                          color: const Color(0xffE8E8E8)
                        )
                      ),
                      child: Row(
                        children: [
                           Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
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
                                  }
                                });
                              },
                              decoration: const InputDecoration(
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
                   localSearch.isNotEmpty? const SimpleText(
                      text: "Search Result",
                      fontSize: 14,
                      fontColor: Color(0xff570035),
                    ):const SizedBox(),
                    localSearch.isNotEmpty?ResourcesCard(
                      list: localSearch,
                    ):const SizedBox(),
                    localSearch.isEmpty? const SimpleText(
                      text: "Personal Finance",
                      fontSize: 14,
                      fontColor: Color(0xff570035),
                    ):const SizedBox(),
                    const SizedBox(height: 5,),
                    localSearch.isEmpty? ResourcesCard(
                      list: LocalData.personalFinance,
                    ):const SizedBox(),
                   localSearch.isEmpty? const SizedBox(height: 25,):SizedBox(),
                    localSearch.isEmpty? const SimpleText(
                      text: "Personal Growth",
                      fontSize: 14,
                      fontColor: Color(0xff570035),
                    ):const SizedBox(),
                    localSearch.isEmpty? ResourcesCard(
                      list: LocalData.personalGrowth,
                    ):const SizedBox(),
                    const SizedBox(height: 5,),
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
