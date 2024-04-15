import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final String? address;
  final String? apartment;
  final String? city;
  final String? companyName;
  final String? country;
  final String? description;
  final String? education;
  final String email;
  final List<String>? eventsOrGroupRec;
  final String? industry;
  final List? interests;
  final String? jobLocation;
  final String? jobTitle;
  final String name;
  final String phone;
  final String? profilePic;
  final String? skills;
  final String? state;
  final String? fcmToken;

  UserProfileModel({
    required this.address,
    required this.apartment,
    required this.city,
    required this.companyName,
    required this.country,
    required this.description,
    required this.education,
    required this.email,
    required this.eventsOrGroupRec,
    required this.industry,
    required this.interests,
    required this.jobLocation,
    required this.jobTitle,
    required this.name,
    required this.phone,
    required this.profilePic,
    required this.skills,
    required this.state,
    required this.fcmToken
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        fcmToken: json["fcm_token"],
        address: json["address"],
        apartment: json["apartment"],
        city: json["city"],
        companyName: json["company_name"],
        country: json["country"],
        description: json["description"],
        education: json["education"],
        email: json["email"],
        eventsOrGroupRec: (json["events_or_group_rec"] as List<dynamic>?)
            ?.map<String>((x) => x as String)
            .toList(),
        industry: json["industry"],
        interests: (json["interests"] as List<dynamic>?)
            ?.map<String>((x) => x as String)
            .toList(),
        jobLocation: json["job_location"],
        jobTitle: json["job_title"],
        name: json["name"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        skills: json["skills"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "apartment": apartment,
        "city": city,
        "company_name": companyName,
        "country": country,
        "description": description,
        "education": education,
        "email": email,
        "events_or_group_rec":
            List<dynamic>.from(eventsOrGroupRec!.map((x) => x)),
        "industry": industry,
        "interests": List<dynamic>.from(interests!.map((x) => x)),
        "job_location": jobLocation,
        "job_title": jobTitle,
        "name": name,
        "phone": phone,
        "profile_pic": profilePic,
        "skills": skills,
        "state": state,
    "fcm_token":fcmToken
      };
}
