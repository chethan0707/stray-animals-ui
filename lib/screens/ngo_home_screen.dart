import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stray_animals_ui/models/report_model/user_report_model.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/repositories/places_services.dart';
import 'package:stray_animals_ui/screens/ngo_reportss.dart/ngo_reports.dart';
import '../components/ngo_nav_bar.dart';
import '../models/ngo_model.dart';

class NGOHome extends ConsumerStatefulWidget {
  final NGO ngo;
  const NGOHome({super.key, required this.ngo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOHomeState();
}

class _NGOHomeState extends ConsumerState<NGOHome> {
  List<UserReport> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavBar(ngo: widget.ngo),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Active reports",
          style: GoogleFonts.aldrich(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: FutureBuilder(
          future: getItems(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (items.isEmpty) {
                  return const Center(child: Text('No active reports found'));
                } else {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return items[index].status == false
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: InkWell(
                                onTap: () async {
                                  var navCont = Navigator.of(context);
                                  var place = await PlacesService()
                                      .getPlaceByCoordinates(LatLng(
                                          items[index].coordinates[0],
                                          items[index].coordinates[1]));
                                  navCont.push(
                                    MaterialPageRoute(
                                      builder: (context) => NGOReport(
                                          place: place, report: items[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.deepPurple[200],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          items[index].userId,
                                          style: GoogleFonts.aldrich(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        subtitle: items[index].status == false
                                            ? const Text(
                                                "Status: Active",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : const Text("Status: Rescued"),
                                      ),
                                      ListTile(
                                        title: Text(
                                          items[index].description,
                                          style: GoogleFonts.aldrich(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            );
                    },
                  );
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<List<UserReport>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngo/reports/get").replace(
        queryParameters: {"email": widget.ngo.email},
      ),
    );
    var jsonBody = json.decode(response.body);
    items = List<UserReport>.from(
        jsonBody.map((model) => UserReport.fromJson(model)));

    return items;
  }
}
