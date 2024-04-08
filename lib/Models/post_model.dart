class Comment {
  final String uid;
  final String name;
  final String profilePic;
  final String time;
  final String commentsDesc;
  final List<dynamic> likes;

  Comment({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.time,
    required this.commentsDesc,
    required this.likes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uid: json['uid'],
      name: json['name'],
      profilePic: json['profile_pic'],
      time: json['time'],
      commentsDesc: json['comments_desc'],
      likes: json['likes'] ?? [], // Handle case when 'likes' is null
    );
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
      id: json["id"]
    );
  }
}


// // Example JSON data
// final json = {
//   "comments": [
//     {
//       "comments_desc": "hello how are you",
//       "likes": [],
//       "name": "Harshit Soni",
//       "profile_pic":
//       "https://firebasestorage.googleapis.com/v0/b/wamikas-c82b2.appspot.com/o/profile%20pic%2Fimage1711015940993?alt=media&token=c807aa08-5152-439d-b6ec-582621644b99",
//       "time": "sssjjssjs",
//       "uid": "fafafaa"
//     }
//   ],
//   "forum_content": "new post guys iiiii",
//   "forum_name": "Personal Finance",
//   "forum_title": "Hello",
//   "like": [],
//   "time": "2024-04-08 11:45:47.980395",
//   "uid": "9116852018"
// };
