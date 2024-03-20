import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Text/simple_text.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  final UserProfileModel userData;
  const EditProfile({
    super.key,
    required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  "assets/svg/rectangle_design.svg",
                  height: size.height * 0.35,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/ep_back (2).svg",
                                      height: 35,
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                                const SimpleText(
                                  text: "Edit Profile",
                                  fontSize: 24,
                                  fontColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              "assets/svg/w-logo.svg",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      border: Border.all(
                                          color: const Color(0xffFF9CEA),
                                          width: 12
                                      )
                                  ),
                                  child: BlocBuilder<UploadImageCubit, UploadImageState>(
                                    builder: (context, state) {
                                      if(state is UploadImageLoading){
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      else if(state is UploadImageSuccess){
                                        return Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(80),
                                            child: Image.file(
                                              File(state.path!),
                                              fit: BoxFit.cover,
                                              width: 140,
                                              height: 140,
                                            ),
                                          ),
                                        );
                                      }else{
                                        return widget.userData.profilePic == null ?
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(80),
                                            child: SvgPicture.asset(
                                              "assets/svg/profile.svg",
                                            ),
                                          ),
                                        ):
                                        Center(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(80),
                                              child: Image.network(
                                                widget.userData.profilePic!,
                                                fit: BoxFit.cover,
                                                width: 140,
                                                height: 140,
                                              )
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 45,
                                  child: InkWell(
                                    onTap: (){
                                      BlocProvider.of<UploadImageCubit>(context).
                                      uploadPhotoEvent(false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: ColorClass.primaryColor,
                                          border: Border.all(
                                              color: const Color(0xffFF9CEA),
                                              width: 6
                                          )
                                      ),
                                      child: SvgPicture.asset
                                        ("assets/svg/plus_profile.svg",),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SimpleText(
                                    text: widget.userData.name,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  Row(
                                    children: [
                                      widget.userData.jobTitle !=null ?
                                      SimpleText(
                                        text: widget.userData.jobTitle!,
                                        fontSize: 16.sp,
                                        fontColor: const Color(0xff6C6C6C),
                                        fontWeight: FontWeight.w300,
                                      ):
                                      SimpleText(
                                        text: "Not Specified",
                                        fontSize: 16.sp,
                                        fontColor: const Color(0xff6C6C6C),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      const SizedBox(width: 5,),
                                      const Icon(Icons.edit),
                                    ],
                                  ),
                                  SimpleText(
                                    text: widget.userData.phone,
                                    fontSize: 15,
                                    fontColor: const Color(0xff6C6C6C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SimpleText(
                                    text: widget.userData.email,
                                    fontSize: 15,
                                    fontColor: const Color(0xff6C6C6C),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: 4,
                    color: ColorClass.primaryColor,
                  ),
                  Flexible(
                    child: Container(
                      color: const Color(0xffFFF0FA),
                      padding: const EdgeInsets.only(left: 10, right: 2),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleText(
                            text: 'Attention',
                            fontSize: 16,
                            fontColor: ColorClass.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          SimpleText(
                            text: "Your profile is currently 85% complete. "
                                "Please update missing information to ensure"
                                " that your profile is fully optimized"
                                " and performs well",
                            fontSize: 14,
                            fontColor: ColorClass.primaryColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            EditProfileTiles(
              tileName: "Contact Details",
              onPressed: () {
                Navigator.of(context).pushNamed(
                    RouteName.contactDetails,
                    arguments: widget.userData);
              },
              isLastTile: false,
              assetName: "assets/svg/iconamoon_profile-light.svg",
            ),
            EditProfileTiles(
              tileName: "Job Profile & Description",
              onPressed: () {
                Navigator.of(context).pushNamed(
                    RouteName.jobDescription,
                    arguments: widget.userData);
              },
              isLastTile: false,
              assetName: "assets/svg/bag.svg",
            ),
            EditProfileTiles(
              tileName: "Interests and Preferences",
              onPressed: () {},
              isLastTile: false,
              assetName: "assets/svg/tabler_hand-love-you.svg",
              widget: const Padding(
                padding: EdgeInsets.only(left: 10,top: 2),
                child: SimpleText(
                  text: "Not Selected",
                  fontSize: 10,
                  fontColor: Color(0xffF72532),
                ),
              ),
            ),
            EditProfileTiles(
              tileName: "Logout",
              onPressed: () {},
              isLastTile: true,
              assetName: "assets/svg/logout.svg",
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileTiles extends StatelessWidget {
  final String tileName;
  final VoidCallback onPressed;
  final bool isLastTile;
  final Widget? widget;
  final String assetName;
  const EditProfileTiles({
    super.key,
    required this.tileName,
    required this.onPressed,
    required this.isLastTile,
    required this.assetName,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: onPressed,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(assetName)
                ),
                SimpleText(text: tileName, fontSize: 14.sp),
                widget ?? const SizedBox(),
                const Spacer(),
                SvgPicture.asset("assets/svg/forward.svg"),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isLastTile ? const SizedBox() : const Divider(
            color: Color(0xffCFCFCF),)
        ],
      ),
    );
  }
}
