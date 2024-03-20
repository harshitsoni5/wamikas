import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import 'dart:io';
import '../../Utils/Components/TextField/text_field_container.dart';

class ContactDetails extends StatefulWidget {
  final UserProfileModel userData;
  const ContactDetails({super.key, required this.userData});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController apartment = TextEditingController();
  final TextEditingController fullAddress = TextEditingController();
  final TextEditingController userState = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();

  @override
  void initState() {
    name.text = widget.userData.name;
    email.text = widget.userData.email;
    phone.text = widget.userData.phone;
    if(widget.userData.country !=null){
      country.text= widget.userData.country!;
    }
    if(widget.userData.state !=null){
      userState.text= widget.userData.state!;
    }
    if(widget.userData.city !=null){
      city.text= widget.userData.city!;
    }
    if(widget.userData.address !=null){
      fullAddress.text= widget.userData.address!;
    }
    super.initState();
  }
  @override
  void dispose() {
    email.dispose();
    name.dispose();
    apartment.dispose();
    fullAddress.dispose();
    userState.dispose();
    city.dispose();
    country.dispose();
    phone.dispose();
    super.dispose();
  }
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
           Container(
             margin: const EdgeInsets.symmetric(horizontal: 30),
             child: Column(
               children: [
                 TextFieldContainer(
                   hintText: "Username",
                   titleBox: "Name",
                   controller: name,
                   maxLength: 32,
                 ),
                 TextFieldContainer(
                   hintText: "Enter email",
                   titleBox: "Email",
                   controller: email,
                   maxLength: 32,
                 ),
                 TextFieldContainer(
                   hintText: "Enter phone number",
                   titleBox: "Phone",
                   controller: phone,
                   readOnlyTrue: true,
                   maxLength: 10,
                 ),
                 TextFieldContainer(
                   hintText: "Country",
                   titleBox: "Country",
                   controller: country,
                   maxLength: 32,
                 ),
                 TextFieldContainer(
                   hintText: "State",
                   titleBox: "State",
                   controller: userState,
                   maxLength: 32,
                 ),
                 TextFieldContainer(
                   hintText: "City",
                   titleBox: "City",
                   controller: city,
                 ),
                 TextFieldContainer(
                   titleBox: "Apartment's/House no.",
                   hintText: "House no.",
                   controller: apartment,
                 ),
                 TextFieldContainer(
                   hintText: "Address",
                   titleBox: "Full Address",
                   controller: fullAddress,
                 ),
                 const SizedBox(height: 20,),
                 Container(
                   margin: const EdgeInsets.only(bottom: 40),
                     child: BlocConsumer<ContactDetailsCubit, ContactDetailsState>(
                       listenWhen: (previous, current) => current is ContactDetailsActionState,
                       buildWhen: (previous, current) => current is! ContactDetailsActionState,
                      listener: (context, state) {
                       if(state is NameEmpty){
                         Fluttertoast.showToast(
                             msg: "User name field should not be empty",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             textColor: Colors.black,
                             fontSize: 15.0
                         );
                       }
                       else if(state is EmailEmpty){
                         Fluttertoast.showToast(
                             msg: "Phone number field should not be empty",
                             toastLength: Toast.LENGTH_LONG,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             textColor: Colors.black,
                             fontSize: 15.0
                         );
                       }
                      else if(state is EmailInvalidState){
                         Fluttertoast.showToast(
                             msg: "Please enter a valid email",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             textColor: Colors.black,
                             fontSize: 15.0
                         );
                       }
                       else if(state is ContactDetailsSuccess){
                         Fluttertoast.showToast(
                             msg: "Profile successfully updated",
                             toastLength: Toast.LENGTH_LONG,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             textColor: Colors.black,
                             fontSize: 15.0
                         );
                       }
                       else{
                         Fluttertoast.showToast(
                             msg: "Oops something went wrong",
                             toastLength: Toast.LENGTH_LONG,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             textColor: Colors.black,
                             fontSize: 15.0
                         );
                       }
                      },
                      builder: (context, state) {
                        if(state is ContactDetailsLoading){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return InkWell(
                         onTap: (){
                           BlocProvider.of<ContactDetailsCubit>(context).
                           updateProfile(
                               name: name.text,
                               email: email.text, 
                               country: country.text,
                               city: city.text,
                               state: userState.text,
                               fullAddress: fullAddress.text,
                               apartment: apartment.text);
                         },
                         child: RoundAuthButtons(size: size, btnText: "Update"));
                        },
                      )
                 )
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}
