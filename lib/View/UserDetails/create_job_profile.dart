import 'package:flutter/material.dart';
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


  @override
  void dispose() {
    jobTitle.dispose();
    companyName.dispose();
    selectIndustry.dispose();
    jobDesc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                  TextFieldContainer(
                    hintText: "Select Industry",
                    titleBox: "Industry",
                    controller: companyName,
                  ),
                  TextFieldContainer(
                    hintText: "Describe your Job",
                    titleBox: "Job Description",
                    controller: jobDesc,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}
