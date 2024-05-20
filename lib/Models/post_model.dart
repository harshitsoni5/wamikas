import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String uid;
  final String name;
  final String? profilePic;
  final Timestamp time;
  final String commentsDesc;
  final List<dynamic> likes;
  final String commentId;

  Comment({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.time,
    required this.commentsDesc,
    required this.likes,
    required this.commentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uid: json['uid'],
      name: json['name'],
      profilePic: json['profile_pic'],
      time: json['time'],
      commentsDesc: json['comments_desc'],
      likes: json['likes'] ?? [],
      commentId: json['comment_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profile_pic': profilePic,
      'time': time,
      'comments_desc': commentsDesc,
      'likes': likes,
      'comment_id': commentId,
    };
  }
}


class PostModel {
  final String forumContent;
  final String forumName;
  final String forumTitle;
  final String time;
  final String uid;
  final List<dynamic> comments;
  final List<dynamic> like;
  final String emailId;
  final String name;
  final String id;
  final String? profilePic;

  PostModel({
    required this.forumContent,
    required this.forumName,
    required this.forumTitle,
    required this.time,
    required this.uid,
    required this.comments,
    required this.like,
    required this.emailId,
    required this.name,
    required this.id,
    required this.profilePic,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Convert comments from JSON to List<Comment>
    List<Comment> comments = [];
    if (json['comments'] != null) {
      // Ensure 'comments' field is a list of maps before mapping
      if (json['comments'] is List && (json['comments'] as List).isNotEmpty) {
        comments = (json['comments'] as List).map((commentJson) => Comment.fromJson(commentJson)).toList();
      }
    }

    return PostModel(
      forumContent: json['forum_content'] ?? '',
      forumName: json['forum_name'] ?? '',
      forumTitle: json['forum_title'] ?? '',
      time: json['time'] ?? '',
      uid: json['uid'] ?? '',
      comments: comments,
      like: json['like'] ?? [],
      name: json['name'] ?? '',
      emailId: json['email'] ?? '',
      id: json["id"],
      profilePic: json["profile_pic"]
    );
  }
}
