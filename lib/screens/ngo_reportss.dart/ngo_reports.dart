import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/repositories/places_services.dart';
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
            child: Text(widget.report.description),
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
          Text("Location: ${widget.place.formattedAddress}"),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: () async {
                PlacesService().getPlaceByCoordinates(LatLng(
                    widget.report.coordinates[0],
                    widget.report.coordinates[0]));
              },
              icon: const Icon(Icons.ac_unit_sharp),
              label: const Text("click me"))
        ],
      ),
    );
  }
}
