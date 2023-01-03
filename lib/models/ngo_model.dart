import 'package:stray_animals_ui/models/report_model/user_report_model.dart';

class NGO {
  NGO({
    required this.id,
    required this.email,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.role,
    required this.coordinates,
    required this.volunteers,
    required this.reports,
  });
  late final int rescueCount;
  late final String id;
  late final String email;
  late final String name;
  late final String city;
  late final Address address;
  late final String phone;
  late final String role;
  late final Coordinates coordinates;
  late final List<String> volunteers;
  late final List<UserReport> reports;
  late final List<String> events;
  NGO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rescueCount = json['rescueCount'];
    email = json['email'];
    name = json['name'];
    city = json['city'];
    address = Address.fromJson(json['address']);
    phone = json['phone'];
    role = json['role'];
    coordinates = Coordinates.fromJson(json['coordinates']);
    volunteers = List.castFrom<dynamic, String>(json['volunteers']);
    reports = (json['userReports'] as List)
        .map((e) => UserReport.fromJson(e))
        .toList();
    events = List.castFrom<dynamic, String>(json['events']);
  
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['rescueCount'] = rescueCount;
    data['email'] = email;
    data['name'] = name;
    data['city'] = city;
    data['address'] = address.toJson();
    data['phone'] = phone;
    data['role'] = role;
    data['coordinates'] = coordinates.toJson();
    data['volunteers'] = volunteers;
    data['userReports'] = reports.map((e) => e.toJson()).toList();
    data['events'] = events;
    return data;
  }
}

class Address {
  Address({
    required this.zipCode,
    required this.state,
  });
  late final String zipCode;
  late final String state;

  Address.fromJson(Map<String, dynamic> json) {
    zipCode = json['zipCode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['zipCode'] = zipCode;
    _data['state'] = state;
    return _data;
  }
}

class Coordinates {
  Coordinates({
    required this.x,
    required this.y,
    required this.type,
    required this.coordinates,
  });
  late final double x;
  late final double y;
  late final String type;
  late final List<double> coordinates;

  Coordinates.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    type = json['type'];
    coordinates = List.castFrom<dynamic, double>(json['coordinates']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['x'] = x;
    _data['y'] = y;
    _data['type'] = type;
    _data['coordinates'] = coordinates;
    return _data;
  }
}
