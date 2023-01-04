import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/components/photo_view_component.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/ngo_screens/events/ngo_event_edit.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/screens/ngo_screens/events/view_volunteers.dart';
import '../../../models/event_model.dart';

class NGOEventScreen extends ConsumerStatefulWidget {
  final String ngoEmail;
  final Event event;
  final PlacesDTO place;
  const NGOEventScreen(
      {required this.ngoEmail,
      required this.event,
      required this.place,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOEventScreenState();
}

class _NGOEventScreenState extends ConsumerState<NGOEventScreen> {
  PageController pageController = PageController();
  List<Volunteer> volunteers = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.eventName,
          style: GoogleFonts.aldrich(
            letterSpacing: 2,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Event Date ",
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.indigo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Row(
              children: [
                Text(
                  widget.event.date,
                  style: GoogleFonts.aldrich(fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget.event.time} pm",
                  style: GoogleFonts.aldrich(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Description",
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.indigo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.event.description,
                    style: GoogleFonts.aldrich(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Volunteers registered",
                style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.indigo),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Expanded(
              child: Row(
                children: [
                  Text(
                    "${widget.event.volunteers.length} / ${widget.event.volunteersRequiredCount} ",
                    style: GoogleFonts.aldrich(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  widget.event.volunteers.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            var navCon = Navigator.of(context);
                            var vols = await getVolunteers();
                            navCon.push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewVolunteers(volunteers: vols),
                            ));
                          },
                          child: const Text(
                            "View volunteers",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          widget.event.images.isEmpty
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Text("No images selected"),
                )
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: widget.event.images.length,
                    itemBuilder: (BuildContext context, int index) {
                      log(widget.event.images.length.toString());
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PhotoViewComp(url: widget.event.images[index]),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.network(
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            "http://localhost:8080/file/download/${widget.event.images[index]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       locationDialougue(context);
      //     },
      //     child: const Icon(Icons.location_on)),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 75,
        type: ExpandableFabType.up,
        children: [
          FloatingActionButton.small(
            heroTag: "btn3",
            child: const Icon(Icons.location_on),
            onPressed: () {
              locationDialougue(context);
            },
          ),
          widget.event.status == false
              ? FloatingActionButton.small(
                  heroTag: "btn1",
                  child: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditEvent(
                        event: widget.event,
                        ngoEmail: widget.ngoEmail,
                      ),
                    ));
                  },
                )
              : Container(),
          widget.event.status == false
              ? FloatingActionButton.small(
                  heroTag: "btn2",
                  child: const Icon(Icons.done),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[300],
                          title: const Text('Close event'),
                          content: Text(
                              "Are you sure you want to mark ${widget.event.eventName} as volunteer?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                addEvent(ScaffoldMessenger.of(context));
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Confirm'),
                            )
                          ],
                        );
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  AwesomeDialog locationDialougue(BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Center(
        child: Expanded(
          child: Text(
            widget.place.formattedAddress,
          ),
        ),
      ),
      padding: const EdgeInsets.all(20),
      btnOkText: "Open in maps",
      btnOkOnPress: () {
        MapUtils.openMap(
            widget.event.coordinates[0], widget.event.coordinates[1]);
      },
    )..show();
  }

  Future<bool> addEvent(ScaffoldMessengerState context) async {
    var url = "http://localhost:8080/api/ngo/event/update";
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(url),
          body: jsonEncode({
            "event": {
              "eventId": widget.event.eventId,
              "description": widget.event.description,
              "eventName": widget.event.eventName,
              "date": widget.event.date,
              "time": widget.event.time,
              "coordinates": [12.34, 76.678],
              "images": widget.event.images,
              "status": true,
              "volunteersRequiredCount": widget.event.volunteersRequiredCount,
              "volunteers": widget.event.volunteers
            },
            "ngoEmail": widget.ngoEmail
          }),
          headers: {'Content-type': 'application/json'});
      if (response.statusCode == 200) {
        return true;
      } else {
        context.showSnackBar(
          SnackBar(
            content: Text(
              response.body.toString(),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      context.showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      log(e.toString());
      return false;
    }
  }

  Future<List<Volunteer>> getVolunteers() async {
    try {
      var client = http.Client();
      var response = await client.post(
        Uri.parse(
          "http://localhost:8080/api/ngo/event/volunteers",
        ),
        body: jsonEncode({
          "emails": widget.event.volunteers,
        }),
        headers: {'Content-type': 'application/json'},
      );
      log(response.body.toString());
      var jsonResponse = jsonDecode(response.body) as List;
      volunteers = jsonResponse.map((e) => Volunteer.fromJson(e)).toList();
      return volunteers;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
