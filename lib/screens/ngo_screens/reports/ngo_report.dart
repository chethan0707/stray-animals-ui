import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/components/map_utils.dart';
import 'package:stray_animals_ui/components/photo_view_component.dart';
import 'package:stray_animals_ui/models/places_dto.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/ngo_screens/reports/assign_volunteer.dart';
import 'package:stray_animals_ui/screens/ngo_screens/reports/carousel_view.dart';
import '../../../models/report_model/user_report_model.dart';
import 'package:http/http.dart' as http;

class NGOReport extends ConsumerStatefulWidget {
  final UserReport report;
  final PlacesDTO place;
  final Volunteer? volunteer;
  const NGOReport(
      {required this.volunteer,
      required this.place,
      required this.report,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOReportState();
}

class _NGOReportState extends ConsumerState<NGOReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.done),
      // ),
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
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
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
          ),
          widget.report.volunteer!.isEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[400]),
                  onPressed: () async {
                    var navCon = Navigator.of(context);
                    var vol = await getVolunteers(widget.report.ngoId);
                    navCon.push(
                      MaterialPageRoute(
                        builder: (context) => AssignVolunteerScreen(
                          reportId: widget.report.caseId,
                          volunteers: vol,
                        ),
                      ),
                    );
                  },
                  child: const Text("Assign volunteer"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 400,
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => PhotoViewComp(
                                                url: widget
                                                    .volunteer!.profileUrl!),
                                          ));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            "http://localhost:8080/file/download/${widget.volunteer!.email}",
                                            height: 150,
                                            width: 150,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Email: ${widget.volunteer!.email}",
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Animals Rescued: ${widget.volunteer!.rescueCount.toString()}",
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "City: ${widget.volunteer!.city}",
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Phone: ${widget.volunteer!.phone.toString()}",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: widget.report.status == true
                          ? Text("Rescued by: ${widget.volunteer!.userName}")
                          : const Text("Volunteer assigned")),
                ),
        ],
      ),
    );
  }

  Future<List<Volunteer>> getVolunteers(String ngoId) async {
    final response = await http.get(
        Uri.parse("http://localhost:8080/api/ngo/volunteers")
            .replace(queryParameters: {"email": ngoId}));

    var volunteers = jsonDecode(response.body) as List;
    return volunteers.map((e) => Volunteer.fromJson(e)).toList();
  }
}
