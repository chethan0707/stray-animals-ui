import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/screens/ngo_reportss.dart/carousel_view.dart';
import '../../models/report_model/user_report_model.dart';

class NGOReport extends ConsumerStatefulWidget {
  final UserReport report;
  final PlacesDTO place;
  const NGOReport({required this.place, required this.report, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOReportState();
}

class _NGOReportState extends ConsumerState<NGOReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.done),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Report",
          style: GoogleFonts.aldrich(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(widget.report.description,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 20,
          ),
          CarouseWithIndicator(
            images: widget.report.urls,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text("Location: ${widget.place.formattedAddress}"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[400]),
            onPressed: () async {
              // PlacesService().getPlaceByCoordinates(LatLng(
              //     widget.report.coordinates[0], widget.report.coordinates[0]));
            },
            child: const Text("Assign volunteer"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[400],
            ),
            onPressed: () async {
              MapUtils.openMap(
                  widget.report.coordinates[0], widget.report.coordinates[1]);
            },
            child: Text(
              "Get directions from google maps",
              style: GoogleFonts.aldrich(),
            ),
          )
        ],
      ),
    );
  }
}
