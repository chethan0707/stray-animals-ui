import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/repositories/places_services.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/completed_event.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/open_event.dart';

import '../../../models/event_model.dart';
import 'package:http/http.dart' as http;

import '../../../models/places_dto.dart';

class CompletedEventsVol extends ConsumerStatefulWidget {
  final String ngoEmail;
  final String volEmail;
  const CompletedEventsVol(
      {required this.volEmail, required this.ngoEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      UpcomingEventsVolState();
}

class UpcomingEventsVolState extends ConsumerState<CompletedEventsVol> {
  List<Event> events = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: FutureBuilder(
          future: getItems(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (events.isEmpty) {
                  return const Center(child: Text("No upcoming events! "));
                } else {
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () async {
                            var navContext = Navigator.of(context);
                            PlacesDTO place = await PlacesService()
                                .getPlaceByCoordinates(LatLng(
                                    events[index].coordinates[0],
                                    events[index].coordinates[1]));
                            navContext.push(
                              MaterialPageRoute(
                                  builder: (context) => CompletedEvent(
                                        volEmail: widget.ngoEmail,
                                        ngoEmail: widget.volEmail,
                                        event: events[index],
                                        place: place,
                                      )),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: Colors.deepPurple[200],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    events[index].eventName,
                                    style: GoogleFonts.aldrich(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    events[index].description,
                                    style: GoogleFonts.aldrich(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<List<Event>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngo/events").replace(
        queryParameters: {"email": widget.ngoEmail},
      ),
    );
    var jsonBody = json.decode(response.body);
    var items =
        List<Event>.from(jsonBody.map((model) => Event.fromJson(model)));
    events = items.where((element) => element.status == true).toList();
    return items;
  }
}
