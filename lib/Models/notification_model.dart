import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  final String id;
  final Timestamp time;
  final String title;
  final String uidOfUser;
  final String name;
  final String? profilePic;

  NotificationModel({
    required this.id,
    required this.time,
    required this.title,
    required this.uidOfUser,
    required this.name,
    required this.profilePic,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json["id"],
          time: json["time"],
          title: json["title"],
          uidOfUser: json["uid_of_User"],
          profilePic: json["profile_pic"],
          name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "title": title,
        "uid_of_User": uidOfUser,
        "name": name,
        "profile_pic": profilePic
      };
}
