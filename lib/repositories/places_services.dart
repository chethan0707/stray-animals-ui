import 'dart:convert' as convert;
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/place_search.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/models/places_dto.dart';

import '../models/place.dart';

class PlacesService {
  final key = 'AIzaSyCP06vr5gYLJVfqHmEgLuUe8o7Bl8UScIg';
  Future<List<PlaceSearch>> getAutoComplete(
      String search, double lat, double lng) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&location=$lat%2C$lng&radius=1000&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    log(jsonResults.length.toString());
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

  Future<PlacesDTO> getPlaceByCoordinates(LatLng lalng) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=mongolian&inputtype=textquery&locationbias=circle%3A2000%40${lalng.latitude}%2C${lalng.longitude}&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['candidates'] as List;
    var jsonR = PlacesDTO.fromJson(jsonResult[0]);

    return PlacesDTO.fromJson(jsonResult[0]);
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
