import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Models/event_model.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class EventsCard extends StatelessWidget {
  final List<EventModel> data;
  final String titleName;
  final String svg;
  const EventsCard({
    super.key,
    required this.size, required this.data,
    required this.titleName,
    required this.svg
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(svg,
              height: 18,),
            const SizedBox(width: 5,),
            SimpleText(
              text: titleName,
              fontSize: 14.sp,
              fontColor: ColorClass.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: data.map((data) {
                return Container(
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
                      Image.network(
                        data.eventPic,
                        width: size.width*0.6,
                        height: size.height*0.2,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleText(
                              text: data.eventName,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                SvgPicture.asset("assets/svg/calender.svg"),
                                const SizedBox(width: 5,),
                                SimpleText(
                                  text: data.date,
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
                                  text: data.address,
                                  fontSize: 10.sp,
                                  fontColor: const Color(0xff455A64),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8,),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                          if (!await launchUrl(
                              Uri.parse(data.link))) {
                            throw Exception('Could not launch url');
                          }
                        },
                        child: Container(
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
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}
