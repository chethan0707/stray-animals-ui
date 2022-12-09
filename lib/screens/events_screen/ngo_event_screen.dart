import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/components/photo_view_component.dart';
import 'package:stray_animals_ui/models/places_dto.dart';

import '../../models/event_model.dart';

class NGOEventScreen extends ConsumerStatefulWidget {
  final Event event;
  final PlacesDTO place;
  const NGOEventScreen({required this.event, required this.place, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOEventScreenState();
}

class _NGOEventScreenState extends ConsumerState<NGOEventScreen> {
  PageController pageController = PageController();

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
          style: GoogleFonts.aldrich(letterSpacing: 2),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          )
        ],
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
              )),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Row(
              children: [
                Text(
                  widget.event.description,
                  style: GoogleFonts.aldrich(fontSize: 18),
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
              child: Text(
                "${widget.event.volunteers.length} / ${widget.event.volunteersRequiredCount} ",
                style: GoogleFonts.aldrich(fontSize: 18),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            locationDialougue(context);
          },
          child: const Icon(Icons.location_on)),
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
      padding: EdgeInsets.all(20),
      btnOkText: "Open in maps",
      btnOkOnPress: () {
        MapUtils.openMap(
            widget.event.coordinates[0], widget.event.coordinates[1]);
      },
    )..show();
    ;
  }
}
