import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wamikas/Bloc/UserProfileBloc/JobDescriptionCubit/job_description_cubit.dart';
import 'package:wamikas/Bloc/UserProfileBloc/JobDescriptionCubit/job_description_state.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import '../../Utils/Components/AppBar/back_button_appbar.dart';
import '../../Utils/Components/Buttons/round_auth_buttons.dart';
import '../../Utils/Components/Text/simple_text.dart';
import '../../Utils/Components/TextField/text_field_container.dart';

class JobProfileDescription extends StatefulWidget {
  final UserProfileModel userData;
  const JobProfileDescription({
    super.key,
    required this.userData
  });

  @override
  State<JobProfileDescription> createState() => _JobProfileDescriptionState();
}

class _JobProfileDescriptionState extends State<JobProfileDescription> {
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController selectIndustry = TextEditingController();
  final TextEditingController jobDesc = TextEditingController();
  final TextEditingController skills = TextEditingController();
  final TextEditingController education = TextEditingController();
  final TextEditingController location = TextEditingController();
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
  void initState() {
    if(widget.userData.jobTitle != null){
      jobTitle.text=widget.userData.jobTitle!;
      companyName.text=widget.userData.companyName!;
      selectIndustry.text=widget.userData.industry!;
      jobDesc.text=widget.userData.description!;
    }
    if(widget.userData.jobLocation != null){
      location.text=widget.userData.jobLocation!;
    }
    if(widget.userData.skills != null){
      skills.text=widget.userData.skills!;
    }
    if(widget.userData.education != null){
      education.text=widget.userData.education!;
    }
    super.initState();
  }
  @override
  void dispose() {
    jobTitle.dispose();
    companyName.dispose();
    selectIndustry.dispose();
    jobDesc.dispose();
    education.dispose();
    skills.dispose();
    location.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackButtonAppBar(size: size,title: "Job Profile",),
            const SizedBox(height: 15,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      value: selectIndustry.text.isEmpty
                          ? null
                          : selectIndustry.text,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectIndustry.text = newValue;
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
                            fontSize: 13.sp,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFieldContainer(
                    hintText: "Please enter Location",
                    titleBox: "Location",
                    controller: location,
                  ),
                  TextFieldContainer(
                    hintText: "Please enter your skills",
                    titleBox: "Skills",
                    controller: skills,
                  ),
                  TextFieldContainer(
                    hintText: "Education",
                    titleBox: "Education",
                    controller: education,
                  ),
                  const SizedBox(height: 10,),
                  TextFieldContainer(
                    hintText: "Describe your Job",
                    titleBox: "Job Description",
                    controller: jobDesc,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: BlocConsumer<JobDescriptionCubit, JobDescriptionState>(
                      listener: (context, state) {
                        if(state is JobDescNotFilledState){
                          Fluttertoast.showToast(
                              msg: "Please fill out all the details properly",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 15.0
                          );
                        }
                        if(state is JobDescSuccessState){
                          Fluttertoast.showToast(
                              msg: "Job profile updated successfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 15.0
                          );
                        }
                        if(state is JobDescErrorState){
                          Fluttertoast.showToast(
                              msg: "Oops something went wrong please try again later",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 15.0
                          );
                        }
                      },
                      builder: (context, state) {
                        if(state is JobDescLoadingState){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return InkWell(
                         onTap: (){
                         BlocProvider.of<JobDescriptionCubit>(context).
                           updateJobDescription(
                          jobTitle: jobTitle.text,
                          company: companyName.text,
                          industry: selectIndustry.text,
                          location: location.text,
                          skills: skills.text, 
                          education: education.text,
                          jobDesc: jobDesc.text);
                        },
                        child: RoundAuthButtons(size: size, btnText: "Update"));
                        },
                      ),
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

