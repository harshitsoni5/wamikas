import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Models/event_model.dart';
import '../../Color/colors.dart';
import '../Text/simple_text.dart';

class EventsCard extends StatelessWidget {
  final List<EventModel> eventsData;
  final String titleName;
  final String? svg;

  const EventsCard({
    super.key,
    required this.size,
    required this.eventsData,
    required this.titleName,
    required this.svg,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            svg == null ?
            const SizedBox():SvgPicture.asset(
              svg!,
              height: 18,
            ),
            const SizedBox(width: 5),
            SimpleText(
              text: titleName,
              fontSize: 14.sp,
              fontColor: ColorClass.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection:eventsData.length ==1 ? Axis.vertical:Axis.horizontal,
          child: Container(
            color: Colors.white,
            child: Wrap(
              spacing: 20,
              children: eventsData.map((data) {
                return Container(
                  height: 270,
                  width: eventsData.length ==1 ? size.width:size.width * 0.75,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                      border: Border.all(
                          color: const Color(0xffE8E8E8)
                      )
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width:eventsData.length ==1 ? size.width:size.width * 0.75,
                        height: size.height * 0.15,
                        child: Image.network(
                          data.eventPic,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SimpleText(
                                  text: data.eventName,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/svg/calender.svg"),
                                    const SizedBox(width: 5),
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
                                    const SizedBox(width: 5),
                                    SimpleText(
                                      text: data.address,
                                      fontSize: 10.sp,
                                      fontColor: const Color(0xff455A64),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (!await launch(
                                  Uri.parse(data.link).toString())) {
                                throw Exception('Could not launch url');
                              }
                            },
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorClass.primaryColor,
                                ),
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: SimpleText(
                                  text: "Register Now!!",
                                  fontColor: ColorClass.primaryColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
