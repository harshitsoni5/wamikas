import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wamikas/Utils/Color/colors.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/Buttons/back_button_with_logo.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({super.key});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  final TextEditingController country =TextEditingController();
   Position? currentPosition;
   String currentAddress ="";
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      bool isAllowed= await _handleLocationPermission();
      if(!isAllowed){
        _handleLocationPermission();
      }else{
        _getCurrentPosition();
      }
      return false;
    }
    return true;
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        '${place.street}, ${place.subLocality}, ${place.postalCode}';
      });
    }).catchError((e) {
      // Navigator.pop(context);
      debugPrint(e);
    });
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
      _getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      // Navigator.pop(context);
      debugPrint(e);
    });
  }
  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }
  @override
  void dispose() {
    country.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
             Container(
               decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFFFFFFFF), // Top color (white)
                      Color(0xffE3289A), // Bottom color (light pinkish)
                    ],
                    stops: [0.1, 2],
                  ),
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                ),
                child: const Column(
                 children: [
                   BackButtonWithLogo(),
                   SizedBox(height: 10,),
                   SimpleText(
                     text: "Where are you located?",
                     fontSize: 18,
                     fontWeight: FontWeight.bold,),
                   SimpleText(
                     text: "Please Provide your location to find events \nand community near you!",
                     fontSize: 15,
                     textAlign: TextAlign.center,
                     fontWeight: FontWeight.w500,
                     textHeight: 1.2,
                   ),
                 ],
               ),
             ),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child:Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFieldContainer(
                        hintText: "India",
                        titleBox: "Country",
                        controller: country),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFieldContainer(
                        hintText: "Select",
                        titleBox: "State",
                        controller: country),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFieldContainer(
                        hintText: "Select",
                        titleBox: "City",
                        controller: country),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFieldContainer(
                        hintText: "Full Address",
                        titleBox: "Address",
                        controller: country),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFieldContainer(
                        hintText: "Enter Zip or PIN",
                        titleBox: "Zip/Pin",
                        controller: country),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: InkWell(
                          onTap: (){
                          },
                          child: RoundAuthButtons(size: size, btnText: "Next"))
                  ),
                  const SizedBox(height: 10,),
                  const SimpleText(
                    text: "Skip >>",
                    fontSize: 15,
                    fontColor: ColorClass.primaryColor,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}

