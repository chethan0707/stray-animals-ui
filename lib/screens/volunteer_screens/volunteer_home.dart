import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:stray_animals_ui/blocs/application_bloc.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_navbar.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/screens/volunteer_screens/join_ngo.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/reports/vol_closed_reports.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/reports/vol_report_screen.dart';
import '../../models/report_model/user_report_model.dart';
import '../../repositories/places_services.dart';
// import 'package:provider/provider.dart' as p;

class VolunteerHome extends ConsumerStatefulWidget {
  final Volunteer vol;
  const VolunteerHome({required this.vol, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends ConsumerState<VolunteerHome> {
  bool? _status = false;
  List<UserReport> items = [];
  List<UserReport> closed = [];
  List<UserReport> open = [];
  @override
  void initState() {
    // final application = p.Provider.of<ApplicationBloc>(context);
    // application.setCurrentPosition();
    items = [];
    closed = [];
    open = [];
    _status = widget.vol.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: VolunteerNavBar(
          vol: widget.vol,
          context: context,
        ),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    items.clear();
                    closed.clear();
                    open.clear();
                    _status = !_status!;
                    updateVolunteerStatus(
                        widget.vol.email!, _status.toString());
                  });
                },
                child: _status == true
                    ? const Icon(
                        Icons.toggle_on,
                        color: Colors.green,
                        size: 40,
                      )
                    : const Icon(
                        Icons.toggle_off,
                        color: Colors.white,
                        size: 40,
                      ),
              ),
            )
          ],
          title: const Text("Assigned Reports"),
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Open",
                    style: GoogleFonts.aldrich(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Closed",
                    style: GoogleFonts.aldrich(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildTabScreen1(),
                  buildTabScreen2(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateVolunteerStatus(String email, String status) async {
    final response = await http.post(
      Uri.parse("http://localhost:8080/api/volunteer/status/update").replace(
        queryParameters: {
          'email': email,
          'status': status,
        },
      ),
    );
  }

  Future<List<UserReport>> getOpenItems() async {
    open.clear();
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/volunteer/reports").replace(
        queryParameters: {
          'email': widget.vol.email,
        },
      ),
    );
    var jsonBody = json.decode(response.body);
    items = List<UserReport>.from(
        jsonBody.map((model) => UserReport.fromJson(model)));
    for (var i in items) {
      if (i.status == true) {
        continue;
      } else {
        open.add(i);
      }
    }
    return open;
  }

  Future<List<UserReport>> getClosedItems() async {
    closed.clear();
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/volunteer/reports").replace(
        queryParameters: {
          'email': widget.vol.email,
        },
      ),
    );
    var jsonBody = json.decode(response.body);
    items = List<UserReport>.from(
        jsonBody.map((model) => UserReport.fromJson(model)));
    for (var i in items) {
      if (i.status == true) {
        closed.add(i);
      }
    }
    return closed;
  }

  Widget buildTabScreen1() {
    return widget.vol.ngos!.isEmpty
        ? (Center(
            child: ElevatedButton(
              onPressed: () async {
                var navCon = Navigator.of(context);
                var ngos = await getNGOs();

                navCon.push(MaterialPageRoute(
                  builder: (context) =>
                      JoinNGO(ngos: ngos, volunteer: widget.vol),
                ));
              },
              child: Text('Join NGO'),
            ),
          ))
        : RefreshIndicator(
            onRefresh: () async {
              items.clear();
              closed.clear();
              open.clear();
              setState(() {});
            },
            child: FutureBuilder(
              future: getOpenItems(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (open.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            items.clear();
                            closed.clear();
                            open.clear();
                          });
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: const Center(
                              child: Text('No active reports found')),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: open.length,
                        itemBuilder: (context, index) {
                          return open[index].status == false
                              ? Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () async {
                                      var navCont = Navigator.of(context);
                                      var place = await PlacesService()
                                          .getPlaceByCoordinates(LatLng(
                                              open[index].coordinates[0],
                                              open[index].coordinates[1]));
                                      navCont.push(
                                        MaterialPageRoute(
                                          builder: (context) => VolunteerReport(
                                              email: widget.vol.email!,
                                              place: place,
                                              ngoEmail: widget.vol.ngos!,
                                              report: open[index]),
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
                                              open[index].userId,
                                              style: GoogleFonts.aldrich(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            subtitle: open[index].status ==
                                                    false
                                                ? const Text(
                                                    "Status: Active",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : const Text("Status: Rescued"),
                                          ),
                                          ListTile(
                                            title: Text(
                                              open[index].description,
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
          );
  }

  Widget buildTabScreen2() {
    return widget.vol.ngos!.isEmpty
        ? (const Center(
            child: Text(
              "Hello volunteer",
            ),
          ))
        : RefreshIndicator(
            onRefresh: () async {
              items.clear();
              closed.clear();
              open.clear();
              setState(() {});
            },
            child: FutureBuilder(
              future: getClosedItems(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (closed.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            items.clear();
                            closed.clear();
                            open.clear();
                          });
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                              child: Text('No previous reports found')),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: closed.length,
                        itemBuilder: (context, index) {
                          return closed[index].status == true
                              ? Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () async {
                                      var navCont = Navigator.of(context);
                                      var place = await PlacesService()
                                          .getPlaceByCoordinates(LatLng(
                                              closed[index].coordinates[0],
                                              closed[index].coordinates[1]));
                                      navCont.push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VolunteerClosedReport(
                                                  uName: widget.vol.userName!,
                                                  email: widget.vol.email!,
                                                  place: place,
                                                  report: closed[index]),
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
                                              closed[index].userId,
                                              style: GoogleFonts.aldrich(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            subtitle: closed[index].status ==
                                                    false
                                                ? const Text(
                                                    "Status: Active",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : const Text("Status: Rescued"),
                                          ),
                                          ListTile(
                                            title: Text(
                                              closed[index].description,
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
          );
  }

  Future<List<NGO>> getNGOs() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngos").replace(
          // queryParameters: {"email": FirebaseAuth.instance.currentUser!.email},
          ),
    );
    var jsonBody = json.decode(response.body);
    log(jsonBody.toString());
    var ngos = List<NGO>.from(jsonBody.map((model) => NGO.fromJson(model)));
    return ngos;
  }
}
