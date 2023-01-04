import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/ngo_screens/reports/carousel_view.dart';
import '../../../models/report_model/user_report_model.dart';
import 'package:http/http.dart' as http;

class VolunteerReport extends ConsumerStatefulWidget {
  final UserReport report;
  final String email;
  final String ngoEmail;
  final PlacesDTO place;
  const VolunteerReport(
      {required this.ngoEmail,
      required this.email,
      required this.place,
      required this.report,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOReportState();
}

class _NGOReportState extends ConsumerState<VolunteerReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:
                    const Text("Are you sure you want to close this report?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () async {
                      var navCon = Navigator.of(context);
                      final response = await http.post(
                        Uri.parse(
                                "http://localhost:8080/api/volunteer/report/close")
                            .replace(
                          queryParameters: {
                            "id": widget.report.caseId,
                            "volID": widget.email,
                            "ngoID": widget.ngoEmail
                          },
                        ),
                      );
                      if (response.statusCode == 200) {
                        navCon.pop();
                        navCon.pop();
                      }
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
        },
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
            child: Text(
              widget.report.description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
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

  Future<List<Volunteer>> getVolunteers(String ngoId) async {
    final response = await http.get(
        Uri.parse("http://localhost:8080/api/ngo/volunteers")
            .replace(queryParameters: {"email": ngoId}));
    log(response.body.toString());
    var volunteers = jsonDecode(response.body) as List;
    return volunteers.map((e) => Volunteer.fromJson(e)).toList();
  }
}
