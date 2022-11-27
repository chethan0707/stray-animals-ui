import 'package:stray_animals_ui/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String? vicinity;

  Place({required this.geometry, required this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
        geometry: Geometry.fromJson(parsedJson['geometry']),
        name: parsedJson['formatted_address'],
        vicinity: parsedJson['vicinity']);
  }
}
