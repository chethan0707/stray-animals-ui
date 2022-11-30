class Event {
  Event({
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.time,
    required this.coordinates,
    required this.description,
    required this.images,
    required this.status,
    required this.volunteersRequiredCount,
    required this.volunteers,
  });
  late final String eventId;
  late final String eventName;
  late final String date;
  late final String time;
  late final List<double> coordinates;
  late final String description;
  late final List<String> images;
  late final bool status;
  late final int volunteersRequiredCount;
  late final List<String> volunteers;

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventName = json['eventName'];
    date = json['date'];
    time = json['time'];
    coordinates = List.castFrom<dynamic, double>(json['coordinates']);
    description = json['description'];
    images = List.castFrom<dynamic, String>(json['images']);
    status = json['status'];
    volunteersRequiredCount = json['volunteersRequiredCount'];
    volunteers = List.castFrom<dynamic, String>(json['volunteers']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['eventId'] = eventId;
    _data['eventName'] = eventName;
    _data['date'] = date;
    _data['time'] = time;
    _data['coordinates'] = coordinates;
    _data['description'] = description;
    _data['images'] = images;
    _data['status'] = status;
    _data['volunteersRequiredCount'] = volunteersRequiredCount;
    _data['volunteers'] = volunteers;
    return _data;
  }
}
