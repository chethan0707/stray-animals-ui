import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as p;
import 'package:stray_animals_ui/blocs/application_bloc.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:stray_animals_ui/screens/user_home.dart';
import '../models/place.dart';

class NearestPetClinics extends ConsumerStatefulWidget {
  final User user;
  const NearestPetClinics({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NearestPetClinicsState();
}

class _NearestPetClinicsState extends ConsumerState<NearestPetClinics> {
  final Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundSubscription;
  @override
  void initState() {
    final applicationBloc =
        p.Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        goToPlace(place);
      }
    });

    boundSubscription = applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        p.Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription.cancel();
    boundSubscription.cancel();
    applicationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final application = p.Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: (application.currentLocation == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: GestureDetector(
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserHome(user: widget.user),
                              ),
                            );
                          },
                        ),),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search near by places",
                      style: GoogleFonts.aldrich(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.deepPurple,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent[500] ??
                                Colors.deepPurpleAccent,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent[50] ??
                                Colors.deepPurple,
                            width: 3)),
                    border: InputBorder.none,
                    hintText: "Search pet clinics",
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.deepPurple,
                    ),
                  ),
                  onChanged: (value) => application.searchPlaces(
                      value,
                      application.currentLocation!.latitude,
                      application.currentLocation!.longitude),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 500,
                    child: GoogleMap(
                      markers: Set<Marker>.of(application.markers),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: CameraPosition(
                        zoom: 13,
                        target: LatLng(
                          application.currentLocation!.latitude,
                          application.currentLocation!.longitude,
                        ),
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                    ),
                  ),
                  if (application.searchResults != null &&
                      application.searchResults.isNotEmpty)
                    Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        backgroundBlendMode: BlendMode.darken,
                      ),
                    ),
                  Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: application.searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            LatLng latlng =
                                await application.setSelectedLocation(
                                    application.searchResults[index].placeId);
                            MapUtils.openMap(latlng.latitude, latlng.longitude);
                          },
                          title: Text(
                            application.searchResults[index].description,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Filter Nearest',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Pet Store'),
                      onSelected: (value) =>
                          application.togglePlaceType('pet_store', value),
                      selected: application.placeType == 'pet_store',
                      selectedColor: Colors.deepPurpleAccent,
                    ),
                    FilterChip(
                      label: const Text('Zoo'),
                      onSelected: (value) =>
                          application.togglePlaceType('zoo', value),
                      selected: application.placeType == 'zoo',
                      selectedColor: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ),
            ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final GoogleMapController controller = await _mapController.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 15,
                target: LatLng(application.currentLocation!.latitude,
                    application.currentLocation!.longitude),
              ),
            ),
          );
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }

  Future<void> goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              place.geometry.location.lat,
              place.geometry.location.lng,
            ),
            zoom: 13),
      ),
    );
  }
}
