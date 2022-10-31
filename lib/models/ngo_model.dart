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
  });
  late final String id;
  late final String email;
  late final String name;
  late final String city;
  late final Address address;
  late final String phone;
  late final String role;
  late final Coordinates coordinates;
  late final List<String> volunteers;

  NGO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    city = json['city'];
    address = Address.fromJson(json['address']);
    phone = json['phone'];
    role = json['role'];
    coordinates = Coordinates.fromJson(json['coordinates']);
    volunteers = List.castFrom<dynamic, String>(json['volunteers']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['name'] = name;
    _data['city'] = city;
    _data['address'] = address.toJson();
    _data['phone'] = phone;
    _data['role'] = role;
    _data['coordinates'] = coordinates.toJson();
    _data['volunteers'] = volunteers;
    return _data;
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
