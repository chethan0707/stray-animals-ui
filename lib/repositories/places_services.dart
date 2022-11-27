import 'dart:convert' as convert;

import 'package:stray_animals_ui/models/place_search.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';

class PlacesService {
  final key = 'AIzaSyCP06vr5gYLJVfqHmEgLuUe8o7Bl8UScIg';
  Future<List<PlaceSearch>> getAutoComplete(
      String search, double lat, double lng) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&location=$lat%2C$lng&radius=500&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getNearByPlaces(
      double lat, double lng, String placeType) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?type=$placeType&location=$lat,$lng&rankby=distance&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
