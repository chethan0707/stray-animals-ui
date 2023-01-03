import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/screens/adoption_screens/adoption_screen.dart';
import 'package:stray_animals_ui/screens/user_screens/events_screen/user_events_screen.dart';
import 'package:stray_animals_ui/screens/user_screens/user_reports/user_report_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/map_utils.dart';
import '../../models/event_model.dart';
import '../../models/ngo_model.dart';
import 'package:http/http.dart' as http;

class NGODesc extends ConsumerStatefulWidget {
  final String userEmail;
  final NGO ngo;
  const NGODesc({required this.userEmail, required this.ngo, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGODescState();
}

class _NGODescState extends ConsumerState<NGODesc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.ngo.name,
            style: GoogleFonts.aldrich(fontSize: 22, color: Colors.black),
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
                      builder: (context) => UserReportScreen(
                          ngoEmail: widget.ngo.email,
                          userEmail: widget.userEmail),
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
                          'Report stray animals',
                          textAlign: TextAlign.center,
                        )
                      ]),
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
                    builder: (context) => EventsScreen(events: events),
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AdoptionScreen(),
                  ));
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
      ),
    );
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
