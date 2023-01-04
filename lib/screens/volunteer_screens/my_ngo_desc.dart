import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/models/event_model.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/repositories/auth_repository.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/vol_events.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MyNGODesc extends ConsumerStatefulWidget {
  final NGO ngo;
  final String volEmail;
  final Volunteer volunteer;
  const MyNGODesc(
      {required this.volunteer,
      required this.volEmail,
      required this.ngo,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MyNGODescState();
}

class MyNGODescState extends ConsumerState<MyNGODesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My NGO"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[300],
                        title: const Text('Leave NGO'),
                        content: Text(
                            "Are you sure you want to leave ${widget.ngo.name} as volunteer?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              var navPop = Navigator.pop(context, true);
                              var navContext = Navigator.of(context);
                              await http.delete(
                                Uri.parse(
                                        "http://localhost:8080/api/ngo/remove/volunteer")
                                    .replace(
                                  queryParameters: {
                                    "ngoEmail": widget.ngo.email,
                                    "volEmail": widget.volEmail
                                  },
                                ),
                              );
                              var volunteer = await ref
                                  .read(authRepositoryProvider)
                                  .getVolunteerFromDB(widget.volunteer.email!);
                              log(volunteer!.userName!);
                              navContext.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => VolunteerHome(
                                    vol: volunteer,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Leave'),
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.ngo.name,
                style: GoogleFonts.aldrich(fontSize: 22, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VolunteerHome(vol: widget.volunteer),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.height / 25)),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.report,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                        Text(
                          'Reports',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() async {
                    launch('tel://${widget.ngo.phone}');
                  }),
                  child: Container(
                    margin: EdgeInsets.only(
                        right: (MediaQuery.of(context).size.height / 25)),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.deepPurple,
                            size: 40,
                          ),
                          const Text(
                            'Call us',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ngo.phone,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          )
                        ]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    var navCont = Navigator.of(context);
                    var events = await getItems();
                    navCont.push(MaterialPageRoute(
                      builder: (context) => VolunteerEventsScreen(
                        ngoEMail: widget.ngo.email,
                        volEmail: widget.volEmail,
                        events: events,
                      ),
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.height / 25)),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.event,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                        Text(
                          'View events',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MapUtils.openMap(widget.ngo.coordinates.coordinates[0],
                        widget.ngo.coordinates.coordinates[1]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        right: (MediaQuery.of(context).size.height / 25)),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_pin,
                            color: Colors.deepPurple,
                            size: 40,
                          ),
                          Text(
                            'Locate us',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Find us on Google Maps',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        ]),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const AdoptionScreen(),
                    // ),);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        right: (MediaQuery.of(context).size.height / 25)),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.pets,
                            color: Colors.deepPurple,
                            size: 40,
                          ),
                          Text(
                            'Adopt',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        ]),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future<List<Event>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngo/events").replace(
        queryParameters: {"email": widget.ngo.email},
      ),
    );
    var jsonBody = json.decode(response.body);
    var items =
        List<Event>.from(jsonBody.map((model) => Event.fromJson(model)));
    return items;
  }
}
