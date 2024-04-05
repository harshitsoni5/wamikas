import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  final String uid;
  final String forumName;
  final String forumTitle;
  final List<dynamic> like;
  final List<dynamic> comments;
  final String time;

  PostModel({
    required this.uid,
    required this.forumName,
    required this.forumTitle,
    required this.like,
    required this.comments,
    required this.time,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uid: json["uid"],
    forumName: json["forum_name"],
    forumTitle: json["forum_title"],
    like: List<dynamic>.from(json["like"].map((x) => x)),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "forum_name": forumName,
    "forum_title": forumTitle,
    "like": List<dynamic>.from(like.map((x) => x)),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "time": time,
  };
}
