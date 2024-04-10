class EventModel {
  final String address;
  final String date;
  final String eventName;
  final String eventPic;
  final String link;

  EventModel({
    required this.address,
    required this.date,
    required this.eventName,
    required this.eventPic,
    required this.link,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      address: json['address'],
      date: json['date'],
      eventName: json['event_name'],
      eventPic: json['event_pic'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'date': date,
      'event_name': eventName,
      'event_pic': eventPic,
      'link': link,
    };
  }
}
