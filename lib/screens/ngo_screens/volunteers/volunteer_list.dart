import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:http/http.dart' as http;

class VolunteerList extends ConsumerStatefulWidget {
  // final List<Volunteer> volunteers;
  final String ngoEmail;
  const VolunteerList({required this.ngoEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VolunteerListState();
}

class _VolunteerListState extends ConsumerState<VolunteerList> {
  int selectedIndex = 0;
  List<Volunteer> volunteers = <Volunteer>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Volunteers'),
        ),
        body: FutureBuilder(
            future: getVolunteers(widget.ngoEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: Text("No connection"));
                case ConnectionState.done:
                  return volunteers.isNotEmpty
                      ? ListView.builder(
                          itemCount: volunteers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                tileColor: selectedIndex == index
                                    ? Colors.deepPurple[200]
                                    : null,
                                onTap: () {
                                  setState(
                                    () {
                                      selectedIndex = index;
                                    },
                                  );
                                  showCustomDialougue();
                                },
                                title: Text(volunteers[index].userName!),
                                subtitle: Text(volunteers[index].email!),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[300],
                                          title: const Text('Assign Volunteer'),
                                          content: Text(
                                              "Are you sure you want to remove ${volunteers[selectedIndex].userName}?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                              onPressed: () async {
                                                var navPop = Navigator.pop(
                                                    context, true);
                                                await http.delete(Uri.parse(
                                                        "http://localhost:8080/api/ngo/remove/volunteer")
                                                    .replace(queryParameters: {
                                                  "ngoEmail": widget.ngoEmail,
                                                  "volEmail":
                                                      volunteers[index].email!
                                                }));
                                                navPop;
                                              },
                                              child: const Text('Remove'),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No Volunteers"));
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<List<Volunteer>> getVolunteers(String ngoId) async {
    final response = await http.get(
        Uri.parse("http://localhost:8080/api/ngo/volunteers")
            .replace(queryParameters: {"email": ngoId}));
    var volunteersResponse = jsonDecode(response.body) as List;
    volunteers = volunteersResponse
        .map((e) => Volunteer.fromJson(e))
        .toList()
        .cast<Volunteer>();
    return volunteers;
  }

  void showCustomDialougue() {
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
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "http://localhost:8080/file/download/${volunteers[selectedIndex].profileUrl}",
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Email: ${volunteers[selectedIndex].email}",
              ),
              const SizedBox(height: 10),
              Text(
                "Animals Rescued: ${volunteers[selectedIndex].rescueCount.toString()}",
              ),
              const SizedBox(height: 10),
              Text(
                "City: ${volunteers[selectedIndex].city}",
              ),
              const SizedBox(height: 10),
              Text(
                "Phone: ${volunteers[selectedIndex].phone.toString()}",
              ),
            ],
          ),
        );
      },
    );
  }
}
