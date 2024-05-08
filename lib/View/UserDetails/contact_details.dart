import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ContactDetailsCubit/contact_details_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/Utils/Components/Profile/profile_photo_details.dart';
import 'package:wamikas/View/UserDetails/user_profile.dart';
import '../../Bloc/UserProfileBloc/ImageCubit/upload_image_cubit.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_bloc.dart';
import '../../Bloc/UserProfileBloc/UserProfileBloc/user_profile_event.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
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
  late String username;
  late String emailId;
  bool isUpdatedTrue=false;
  @override
  void initState() {
    username = widget.userData.name;
    emailId=widget.userData.email;
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
  void _pickedImage(Size size){
    showDialog<ImageSource>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height:size.height*0.26,
          width:size.width-30,
          padding: const EdgeInsets.only(bottom: 15,left: 20,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.close,color: Colors.white,),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const SimpleText(
                text: 'Choose image source',
                fontSize: 18,
                fontColor: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CameraButtons(
                    title: "Camera",
                    onPressed: () async {
                      PermissionStatus permission = await Permission.camera.status;
                      if (permission.isGranted) {
                        Navigator.of(context).pop();
                        BlocProvider.of<UploadImageCubit>(context)
                            .uploadPhotoEvent(true);
                      } else if (permission.isDenied) {
                        // If permission is denied, request permission again
                        permission = await Permission.camera.request();
                        if (permission.isGranted) {
                          Navigator.of(context).pop();
                          BlocProvider.of<UploadImageCubit>(context)
                              .uploadPhotoEvent(true);
                        } else {
                          showPermissionDeniedDialog('Camera');
                        }
                      } else {
                        // If permission is neither granted nor denied, request permission
                        permission = await Permission.camera.request();
                        if (permission.isGranted) {
                          Navigator.of(context).pop();
                          BlocProvider.of<UploadImageCubit>(context)
                              .uploadPhotoEvent(true);
                        } else {
                          showPermissionDeniedDialog('Camera');
                        }
                      }
                    },
                    svg: "assets/svg/camera.svg",
                    size: size,
                  ),
                  const SizedBox(width: 20,),
                  CameraButtons(
                    size: size,
                    title: "Gallery",
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
                    svg: "assets/svg/gallery.svg",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
    });
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            if(isUpdatedTrue){
                              BlocProvider.of<UserProfileBloc>(
                                  context)
                                  .add(GetUserDataEvent());
                            }
                            BlocProvider.of<UserProfileBloc>(
                                context)
                                .add(GetUserDataWithoutLoading());
                          },
                          child: SvgPicture.asset(
                            "assets/svg/ep_back (2).svg",
                            height: 35,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      SimpleText(
                        text: "Edit Profile",
                        fontSize:  size.width <400? 20:22,
                        fontColor: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/svg/w-logo.svg",
                    height: size.width <390? 35:40,
                  ),
                ],
              ),
            ),
            ProfilePhotoWithDetails(
                data: widget.userData,
                isPenNeeded: false,
                onPressed: () {
                  _pickedImage(size);
                },isEditProfile: true,),
            Expanded(
             child: Container(
               margin: const EdgeInsets.symmetric(horizontal: 30),
               child: SingleChildScrollView(
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
                          child: BlocConsumer<ContactDetailsCubit,
                              ContactDetailsState>(
                            listenWhen: (previous, current) =>
                                current is ContactDetailsActionState,
                            buildWhen: (previous, current) =>
                                current is! ContactDetailsActionState,
                            listener: (context, state) {
                           if(state is NameEmpty){
                             Fluttertoast.showToast(
                                 msg: "User name field should not be empty",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.SNACKBAR,
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 backgroundColor: CupertinoColors.white,
                                 fontSize: 15.0
                             );
                           }
                           else if(state is EmailEmpty){
                             Fluttertoast.showToast(
                                 msg: "Phone number field should not be empty",
                                 toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.SNACKBAR,
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 backgroundColor: CupertinoColors.white,
                                 fontSize: 15.0
                             );
                           }
                          else if(state is EmailInvalidState){
                             Fluttertoast.showToast(
                                 msg: "Please enter a valid email",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.SNACKBAR,
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 backgroundColor: CupertinoColors.white,
                                 fontSize: 15.0
                             );
                           }
                           else if(state is ContactDetailsSuccess){
                             setState(() {
                               emailId = email.text;
                               username = name.text;
                               isUpdatedTrue=true;
                             });
                             Fluttertoast.showToast(
                                 msg: "Profile successfully updated",
                                 toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.SNACKBAR,
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 backgroundColor: CupertinoColors.white,
                                 fontSize: 15.0
                             );
                           }
                           else{
                             Fluttertoast.showToast(
                                 msg: "Oops something went wrong",
                                 toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.SNACKBAR,
                                 timeInSecForIosWeb: 1,
                                 textColor: Colors.black,
                                 backgroundColor: CupertinoColors.white,
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
                             child: RoundAuthButtons(
                                 size: size, btnText: "Update"));
                            },
                          )
                     )
                   ],
                 ),
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}
