import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/report_model/user_report_model.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/screens/user_screens/user_reports/open_report.dart';

import '../../../models/volunteer.dart';
import '../../../repositories/places_services.dart';

class OpenReportsList extends ConsumerStatefulWidget {
  final String userEmail;

  const OpenReportsList({required this.userEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenReportsListState();
}

class _OpenReportsListState extends ConsumerState<OpenReportsList> {
  List<UserReport> newReports = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserReports(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return newReports.isEmpty
              ? const Center(
                  child: Text(
                    "No previous reports found",
                  ),
                )
              : ListView.builder(
                  itemCount: newReports.length,
                  itemBuilder: (context, index) {
                    return newReports[index].status == false
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.deepPurple[200],
                              title: Text(newReports[index].description),
                              subtitle: Text(
                                  "Status: ${newReports[index].status ? "Closed" : "Open"}"),
                              onTap: () async {
                                var navCont = Navigator.of(context);
                                var place = await PlacesService()
                                    .getPlaceByCoordinates(LatLng(
                                        newReports[index].coordinates[0],
                                        newReports[index].coordinates[1]));
                                var volunteer;
                                newReports[index].volunteer == null ||
                                        newReports[index].volunteer!.isEmpty
                                    ? volunteer == null
                                    : volunteer = await getVolunteer();
                                navCont.push(
                                  MaterialPageRoute(
                                    builder: (context) => OpenReport(
                                      volunteer: volunteer,
                                      place: place,
                                      report: newReports[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox();
                  },
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<UserReport>> getUserReports() async {
    var response = await http
        .get(Uri.parse("http://localhost:8080/api/user/reports").replace(
      queryParameters: {
        "userEmail": widget.userEmail,
      },
    ));

    var jsonBody = json.decode(response.body);
    var items = List<UserReport>.from(
        jsonBody.map((model) => UserReport.fromJson(model)));
    newReports = items.where((element) => element.status == false).toList();
    return items;
  }

  Future<Volunteer> getVolunteer() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/volunteer/get").replace(
        queryParameters: {"email": newReports[0].volunteer},
      ),
    );
    var jsonBody = json.decode(response.body);
    return Volunteer.fromJson(jsonBody);
  }
}
