import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/vol_event.dart';

import '../../../models/event_model.dart';
import '../../../repositories/places_services.dart';

class VolunteerDescAllEventsScreen extends ConsumerWidget {
  final String volEmail;
  final String ngoEmail;
  final List<Event> events;
  const VolunteerDescAllEventsScreen(
      {required this.ngoEmail,
      required this.volEmail,
      required this.events,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        child: events.isEmpty
            ? const Center(child: Text("No upcoming events! "))
            : ListView.builder(
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
                            builder: (context) => VolunteerEventScreen(
                              ngoEmail: ngoEmail,
                              volEmail: volEmail,
                              event: events[index],
                              place: place,
                            ),
                          ),
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
              ),
      ),
    );
  }
}
