import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../Utils/Components/Text/simple_text.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentsController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Row(
            children: [
              SimpleText(
                text: "Most relevant",
                fontSize: 12.sp,),
              const SizedBox(width: 5,),
              const Icon(Icons.keyboard_arrow_down)
            ],
          ),
          const SizedBox(height: 20,),
          ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CircleAvatar(
                            radius: 20,
                            child: Image.asset("assets/images/dp.png",),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SimpleText(text: "Abhishek Kumar Jha",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SimpleText(
                                text:
                                "Nice thoughts dear, but i would suggest to prepare your self and be confident. My best wishes for you.connect me any time for any support.",
                                fontSize: 11.sp,
                                fontColor: const Color(0xff696969),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/like_wami.svg"),
                        const SizedBox(width: 5,),
                        SimpleText(text: "Like", fontSize: 10.sp),
                        const Spacer(),
                        SimpleText(text: "2 hr ago", fontSize: 10.sp),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              }
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    color: const Color(0xffDEDEDE),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Start Typing here",
                          hintStyle: TextStyle(
                              color: Color(0xffAFAFAF), fontSize: 14)),
                      controller: commentsController,
                    )),
                    CircleAvatar(
                      radius: 25,
                      child:
                      SvgPicture.asset("assets/svg/message_icon.svg"),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
