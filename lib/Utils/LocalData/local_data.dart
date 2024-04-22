import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wamikas/Models/event_model.dart';
import 'package:wamikas/Models/resources_model.dart';

class LocalData{

  static List<ResourcesModel> personalFinance = [];
  static List<ResourcesModel> personalGrowth = [];
  static List<ResourcesModel> bookmarked = [];
  static List<EventModel> trendingEvents = [];
  static List<EventModel> featuredEvents = [];
  static List<EventModel> workshopEvents = [];
  static String docId ="";

 static String getTimeAgo(String dateString) {
    final postTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    }
    else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}/${postTime.year}";
    }
  }
  static String getTime(var timestamp) {
    final postTime;
    if(timestamp is Timestamp){
      postTime = timestamp.toDate();
    }else{
      postTime = DateTime.parse(timestamp.toString());
    }
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${postTime.day}/${postTime.month}/${postTime.year}";
    }
  }
}