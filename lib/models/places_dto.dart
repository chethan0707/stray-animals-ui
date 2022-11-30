class PlacesDTO {
  PlacesDTO({
    required this.formattedAddress,
    required this.geometry,
    required this.name,
    required this.openingHours,
    required this.rating,
  });
  late final String formattedAddress;
  late final Geometry geometry;
  late final String name;
  late final OpeningHours openingHours;
  late final double rating;

  PlacesDTO.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formatted_address'];
    geometry = Geometry.fromJson(json['geometry']);
    name = json['name'];
    openingHours = OpeningHours.fromJson(json['opening_hours']);
    rating = json['rating'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formatted_address'] = formattedAddress;
    data['geometry'] = geometry.toJson();
    data['name'] = name;
    data['opening_hours'] = openingHours.toJson();
    data['rating'] = rating;
    return data;
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });
  late final Location location;
  late final Viewport viewport;

  Geometry.fromJson(Map<String, dynamic> json) {
    location = Location.fromJson(json['location']);
    viewport = Viewport.fromJson(json['viewport']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location'] = location.toJson();
    data['viewport'] = viewport.toJson();
    return data;
  }
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });
  late final Northeast northeast;
  late final Southwest southwest;

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = Northeast.fromJson(json['northeast']);
    southwest = Southwest.fromJson(json['southwest']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['northeast'] = northeast.toJson();
    data['southwest'] = southwest.toJson();
    return data;
  }
}

class Northeast {
  Northeast({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Southwest {
  Southwest({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Southwest.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class OpeningHours {
  OpeningHours({
    required this.openNow,
  });
  late final bool openNow;

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['open_now'] = openNow;
    return data;
  }
}
