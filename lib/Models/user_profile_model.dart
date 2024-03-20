import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final String? address;
  final String? city;
  final String? country;
  final String? state;
  final String? zipCode;
  final String? companyName;
  final String? description;
  final String email;
  final String? industry;
  final List<String>? interests;
  final String? jobTitle;
  final String name;
  final String phone;
  final String? profilePic;

  UserProfileModel({
    required this.address,
    required this.city,
    required this.country,
    required this.state,
    required this.zipCode,
    required this.companyName,
    required this.description,
    required this.email,
    required this.industry,
    required this.interests,
    required this.jobTitle,
    required this.name,
    required this.phone,
    required this.profilePic,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        address: json["address"],
        city: json["city"],
        country: json["country"],
        state: json["state"],
        zipCode: json["zipCode"],
        companyName: json["company_name"],
        description: json["description"],
        email: json["email"],
        industry: json["industry"],
        interests: (json["interests"] as List<dynamic>?)?.map<String>((x) => x as String).toList(),
        jobTitle: json["job_title"],
        name: json["name"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "country": country,
        "state": state,
        "zipCode": zipCode,
        "company_name": companyName,
        "description": description,
        "email": email,
        "industry": industry,
        "interests": List<dynamic>.from(interests!.map((x) => x)),
        "job_title": jobTitle,
        "name": name,
        "phone": phone,
        "profile_pic": profilePic,
      };
}
