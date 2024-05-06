import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wamikas/Bloc/HomeBloc/home_bloc.dart';
import 'package:wamikas/Bloc/HomeBloc/home_event.dart';
import 'package:wamikas/Utils/LocalData/local_data.dart';
import '../../../Models/resources_model.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class ResourcesCard extends StatefulWidget {
  final List<ResourcesModel> list;
  const ResourcesCard({
    super.key, required this.list,
  });

  @override
  State<ResourcesCard> createState() => _ResourcesCardState();
}

class _ResourcesCardState extends State<ResourcesCard> {
  List<bool> isLiked = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),

        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          if (isLiked.isEmpty) {
            isLiked = List.generate(widget.list.length, (index){
              if(widget.list[index].bookmark.contains(LocalData.docId)){
                return true;
              }else{
                return false;
              }
            });
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
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
                      widget.list[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 5,
                  child: GestureDetector(
                    onTap: ()async{
                      if (!await launch(
                          Uri.parse(widget.list[index].link).toString())) {
                        throw Exception('Could not launch url');
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleText(
                            text: widget.list[index].title,
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
                              text: "By- ${widget.list[index].by}",
                              fontSize: 13,
                              fontColor: const Color(0xffE52A9C),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            isLiked[index] = !isLiked[index];
                          });
                          BlocProvider.of<HomeBloc>(context).add(
                            BookmarkResources(
                                id: widget.list[index].id,
                                bookmarkOrNot: isLiked[index]));
                        },
                          child:
                              isLiked[index] ?
                              SvgPicture.asset("assets/svg/bookmarked.svg",
                              ):SvgPicture.asset("assets/svg/bookmark.svg"),
                      ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
