import 'package:flutter/material.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 15,),
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                SizedBox(width: 15,),
                SimpleText(
                  text: "Search",
                  fontSize: 22,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 15,top: 10,left: 15,right: 15),
            decoration: BoxDecoration(
                color:const Color(0xffF4F4F4),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color(0xffDEDEDE)
                )
            ),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    onSubmitted: (val){
                    },
                    onTap: (){
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here",
                      hintStyle: TextStyle(
                        color: Color(0xffAFAFAF),
                        fontSize: 14,
                      ),
                    ),
                    controller: searchController,
                  ),
                ),
                searchController.text.isNotEmpty ?InkWell(
                  onTap: (){
                    searchController.clear();
                    setState(() {});
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xffE52A9C),
                    radius: 20,
                    child: Icon(Icons.close,color: Color(0xffF4F4F4),)
                  ),
                ):const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
