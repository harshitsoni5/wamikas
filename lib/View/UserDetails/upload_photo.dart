import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import 'package:wamikas/Utils/Components/Buttons/back_button_with_logo.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import 'dart:io';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Routes/route_name.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {

  void _pickedImage(){
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Choose image source'),
        actions: [
          ElevatedButton(
            child: const Text('Camera'),
            onPressed: () async {
              Permission permission = Permission.camera;
              if (await permission.isGranted) {
                Navigator.of(context).pop();
                BlocProvider.of<UploadImageCubit>(context)
                    .uploadPhotoEvent(true);
              } else if (await permission.isDenied) {
                permission = Permission.camera;
                if (await permission.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context)
                      .uploadPhotoEvent(true);
                } else {
                  showPermissionDeniedDialog('Camera');
                }
              } else {
                showPermissionDeniedDialog('Camera');
              }
            },
          ),
          ElevatedButton(
            child: const Text('Gallery'),
            onPressed: () async {
              PermissionStatus status =await Permission.photos.request();
              if ( status.isGranted) {
                Navigator.of(context).pop();
                BlocProvider.of<UploadImageCubit>(context)
                    .uploadPhotoEvent(false);
              } else if ( status.isDenied) {
                status = await Permission.photos.request();
                if ( status.isGranted) {
                  Navigator.of(context).pop();
                  BlocProvider.of<UploadImageCubit>(context)
                      .uploadPhotoEvent(false);
                } else {
                  showPermissionDeniedDialog('Gallery');
                }
              } else {
                showPermissionDeniedDialog('Gallery');
              }
            },
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
    });
  }

  void showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: Text(
              'Permission to access $permissionType is required to use this feature.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const BackButtonWithLogo(),
              SizedBox(
                height: size.height*0.1,
              ),
              Column(
                children: [
                  const SimpleText(
                    text: "Upload Photo",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SimpleText(
                    text:
                        "Please upload a Picture to create\n your profile Pic",
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    width: size.width,
                    child: Column(
                      children: [
                       BlocConsumer<UploadImageCubit, UploadImageState>(
                        listener: (context, state) {
                        },
                        builder: (context, state) {
                         if(state is UploadImageLoading){
                           return const Center(child: CircularProgressIndicator(),);
                         }
                         else if (state is UploadImageSuccess){
                           return Column(
                             children: [
                               SizedBox(
                                 height: size.height*0.45,
                                 child: DottedBorder(
                                   color: const Color(0xffD2D2D2),
                                   dashPattern: const [6, 6, 6, 6],
                                   borderType: BorderType.RRect,
                                   radius: const Radius.circular(12),
                                   padding: const EdgeInsets.all(20),
                                   child: state.path!= null?
                                   ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child: Image.file(
                                         File(state.path!),
                                         width:size.width,fit: BoxFit.fitHeight,))
                                   :ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child: Image.asset(
                                         "assets/images/upload_photo.png",
                                         width:size.width,fit: BoxFit.fitHeight,)),
                                 ),
                               ),
                               const SizedBox(height: 20,),
                               state.path !=null ?
                               Container(
                                   margin: const EdgeInsets.symmetric(horizontal: 30),
                                   child: InkWell(
                                       onTap: (){
                                       Navigator.of(context).pushNamed(RouteName.createJobProfile);
                                       },
                                       child: RoundAuthButtons(size: size, btnText: "Next"))
                               )
                               : InkWell(
                                 onTap:(){
                                   _pickedImage();
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                                   width: size.width,
                                   decoration: ShapeDecoration(
                                     color: ColorClass.primaryColor,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Row(
                                         children: [
                                           SvgPicture.asset("assets/svg/cloud.svg"),
                                           const SizedBox(width: 10,),
                                           const SimpleText(
                                             text: "Browse",
                                             fontColor: Colors.white,
                                             fontSize: 15,
                                             fontFamily: 'Poppins',
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ],
                                       ),
                                       SvgPicture.asset("assets/svg/ep_fwrd.svg"),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           );
                         }
                         return Column(
                           children: [
                             SizedBox(
                               height: size.height*0.45,
                               child: DottedBorder(
                                 color: const Color(0xffD2D2D2),
                                 dashPattern: const [6, 6, 6, 6],
                                 borderType: BorderType.RRect,
                                 radius: const Radius.circular(12),
                                 padding: const EdgeInsets.all(20),
                                 child: ClipRRect(
                                     borderRadius: BorderRadius.circular(10),
                                     child: Image.asset(
                                       "assets/images/upload_photo.png",
                                       width:size.width,fit: BoxFit.fitHeight,)),
                               ),
                             ),
                             const SizedBox(height: 20,),
                             InkWell(
                               onTap: (){
                                 _pickedImage();
                               },
                               child: Container(
                                 padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                                 width: size.width,
                                 decoration: ShapeDecoration(
                                   color: ColorClass.primaryColor,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: [
                                         SvgPicture.asset("assets/svg/cloud.svg"),
                                         const SizedBox(width: 10,),
                                         const SimpleText(
                                           text: "Browse",
                                           fontColor: Colors.white,
                                           fontSize: 15,
                                           fontFamily: 'Poppins',
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ],
                                     ),
                                     SvgPicture.asset("assets/svg/ep_fwrd.svg"),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         );
                        },
                      ),
                        const SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pushNamed(RouteName.bottomBar);
                          },
                          child: const SimpleText(
                            text: "Skip >>",
                            fontSize: 15,
                            fontColor: ColorClass.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
