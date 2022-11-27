import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/geometry.dart';
import 'package:stray_animals_ui/models/location.dart';
import 'package:stray_animals_ui/models/place_search.dart';
import 'package:stray_animals_ui/repositories/geolocator_services.dart';
import 'package:stray_animals_ui/repositories/marker_services.dart';
import 'package:stray_animals_ui/repositories/places_services.dart';

import '../models/place.dart';

class ApplicationBloc extends ChangeNotifier {
  final geoLocatorService = GeoLocatorService();
  final placesService = PlacesService();
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation =
      StreamController<Place>.broadcast();
  StreamController<LatLngBounds> bounds =
      StreamController<LatLngBounds>.broadcast();
  String placeType = "";
  MarkerService markerService = MarkerService();
  List<Marker> markers = [];
  late Place selectedLocationStatic;
  ApplicationBloc() {
    setCurrentPosition();
  }
  setCurrentPosition() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: "",
      geometry: Geometry(
        location: Location(
            lat: currentLocation!.latitude, lng: currentLocation!.longitude),
      ),
    );
    markers = [];
    var locationNear =
        markerService.createMarkerFromPlace(selectedLocationStatic);
    markers.add(locationNear);

    var _bounds = markerService.bounds(Set<Marker>.of(markers));
    bounds.add(_bounds!);

    notifyListeners();
  }

  searchPlaces(String searchTerm, double lat, double lng) async {
    searchResults = await placesService.getAutoComplete(searchTerm, lat, lng);
    notifyListeners();
  }

  Future<LatLng> setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;

    searchResults = [];
    notifyListeners();
    return LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = "";
    }
    if (placeType.isNotEmpty) {
      var places = await placesService.getNearByPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);

      markers = [];
      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0]);
        markers.add(newMarker);
      }

      var locationNear =
          markerService.createMarkerFromPlace(selectedLocationStatic);
      markers.add(locationNear);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds!);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}

final applicationBlocController =
    ChangeNotifierProvider<ApplicationBloc>((ref) {
  return ApplicationBloc();
});
