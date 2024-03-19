import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wamikas/Bloc/UserProfileBloc/CreateJobProfile/create_job_profile_state.dart';
import 'package:wamikas/Utils/Routes/route_name.dart';
import 'package:wamikas/View/UserDetails/user_profile.dart';
import '../../Bloc/UserProfileBloc/CreateJobProfile/create_job_profile_cubit.dart';
import '../../Utils/Color/colors.dart';
import '../../Utils/Components/Buttons/back_button_with_logo.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class CreateJobProfile extends StatefulWidget {
  const CreateJobProfile({super.key});

  @override
  State<CreateJobProfile> createState() => _CreateJobProfileState();
}

class _CreateJobProfileState extends State<CreateJobProfile> {
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController selectIndustry = TextEditingController();
  final TextEditingController jobDesc = TextEditingController();
  final TextEditingController industry = TextEditingController();
  List<String> sectors = [
    'Agriculture and Farming',
    'Automotive',
    'Aviation and Aerospace',
    'Banking and Finance',
    'BioTechnology',
    'Business Services',
    'Chemical Sector',
    'Construction and Infrastructure',
    'Consumer Electronics',
    'Data and Analytics',
    'DeepTech',
    'Defense and Military',
    'Education and Training',
    'Electronic Manufacturing',
    'Energy Sector',
    'Environment tech',
    'Food & Beverage',
    'Food Tech',
    'Gig Economy',
    'HealthCare & pharmaceuticals',
    'HealthTech',
    'Hospitality and Tourism',
    'Import & Export Sector',
    'Industrial Manufacturing',
    'Information Technology',
    'Insurance',
    'Internet and E-commerce',
    'Journalism and Publishing',
    'Legal and Law Enforcement',
    'Life Science',
    'Management and Consulting',
    'Manufacturing',
    'Media and Entertainment',
    'Medical Devices',
    'Mining and Metals',
    'Nonprofit and Philanthropy',
    'Oil Refining Sector',
    'Online dating and matchmaking Tech',
    'Personal Care Products and Fashion Tech',
    'Ride Hailing Services',
    'Robotics and Automation',
    'Saas Sector',
    'SeaFood Sector',
    'Service Industry',
    'Sports and Recreation',
    'TechWear',
    'Telecommunication',
    'Textiles and Apparel',
    'Transportation and Logistics Tech',
    'Veterinary activities',
    'Waste Management and Recycling',
    'Water and Sanitation',
    'Wholesale Trade & retail',
  ];


  @override
  void dispose() {
    jobTitle.dispose();
    companyName.dispose();
    selectIndustry.dispose();
    jobDesc.dispose();
    industry.dispose();
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
              const BackButtonWithLogo(),
              const SimpleText(
                text: "Create Job Profile",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              const SimpleText(
                text:
                "Please provide your educational and \n Professional information",
                fontSize: 15,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFieldContainer(
                      hintText: "Designation",
                      titleBox: "Job Title",
                      controller: jobTitle,
                    ),
                    TextFieldContainer(
                      hintText: "ex. Amazon",
                      titleBox: "Company Name",
                      controller: companyName,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SimpleText(
                          text: "Industry",
                          fontSize: 15,
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xffE8E8E8)
                        )
                      ),
                      child: DropdownButtonFormField<String>(
                        icon: SvgPicture.asset("assets/svg/down_arrow.svg"),
                        value: industry.text.isEmpty
                            ? null
                            : industry.text,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            industry.text = newValue;
                          }
                        },
                        items: sectors
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        ).toList(),
                        decoration: InputDecoration(
                          hintText: "Select Industry",
                          border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xff888888),
                              fontSize: 12,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFieldContainer(
                      hintText: "Describe your Job",
                      titleBox: "Job Description",
                      controller: jobDesc,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
                BlocConsumer<CreateJobProfileCubit, CreateJobProfileState>(
                  listenWhen: (previous, current) => current is CreateJobProfileActionState,
                  buildWhen: (previous, current) => current is! CreateJobProfileActionState,
                  listener: (context, state) {
                   if(state is CreateJobProfileSuccess){
                     Navigator.of(context).pushNamed(RouteName.interests);
                   }
                   if(state is CreateJobProfileFormNotFilledState){
                     Fluttertoast.showToast(
                         msg: "Please fill out the details properly",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         textColor: Colors.black,
                         fontSize: 15.0
                     );
                   }
                  },
                  builder: (context, state) {
                    if(state is CreateJobProfileLoading){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: InkWell(
                      onTap: (){
                        BlocProvider.of<CreateJobProfileCubit>(context).
                        createJobProfile(
                            jobTitle.text,
                            companyName.text,
                            industry.text,
                            jobDesc.text);
                      },
                      child: RoundAuthButtons(size: size, btnText: "Next"))
              );
              },
            ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(RouteName.userProfile);
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
      ),
    );
  }
}
