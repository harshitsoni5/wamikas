import 'dart:convert';

ResourcesModel resourcesModelFromJson(String str) => ResourcesModel.fromJson(json.decode(str));

String resourcesModelToJson(ResourcesModel data) => json.encode(data.toJson());

class ResourcesModel {
  final String title;
  final String by;
  final String image;
  final String link;
  final List<String> bookmark;

  ResourcesModel({
    required this.title,
    required this.by,
    required this.image,
    required this.link,
    required this.bookmark,
  });

  factory ResourcesModel.fromJson(Map<String, dynamic> json) => ResourcesModel(
    title: json["title"],
    by: json["by"],
    image: json["image"],
    link: json["link"],
    bookmark: List<String>.from(json["bookmark"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "by": by,
    "image": image,
    "link": link,
    "bookmark": List<dynamic>.from(bookmark.map((x) => x)),
  };
}
