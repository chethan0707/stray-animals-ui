import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../models/volunteer.dart';

class AssignVolunteerScreen extends ConsumerStatefulWidget {
  final List<Volunteer> volunteers;
  final String reportId;
  const AssignVolunteerScreen(
      {required this.reportId, required this.volunteers, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignVolunteerScreenState();
}

class _AssignVolunteerScreenState extends ConsumerState<AssignVolunteerScreen> {
  var availableVolunteers = <Volunteer>[];
  var volunteersUnavailable = <Volunteer>[];
  @override
  void initState() {
    super.initState();
    for (var volunteer in widget.volunteers) {
      if (volunteer.status == true) {
        availableVolunteers.add(volunteer);
      } else {
        volunteersUnavailable.add(volunteer);
      }
    }
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Assign Volunteer'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: availableVolunteers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text('${availableVolunteers[index].userName}'),
                    tileColor:
                        selectedIndex == index ? Colors.deepPurple[200] : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      showCustomDialog(context);
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[300],
                          title: const Text('Assign Volunteer'),
                          content: Text(
                              "Are you sure you want to assign ${availableVolunteers[selectedIndex].userName}?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                assignVolunteer(
                                  availableVolunteers[selectedIndex].email!,
                                  widget.reportId,
                                );
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              },
                              child: const Text('Assign'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Assign'))
            ],
          )
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    // showGeneralDialog(
    //   context: context,
    //   barrierLabel: "Barrier",
    //   barrierDismissible: true,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   transitionDuration: const Duration(milliseconds: 700),
    //   pageBuilder: (_, __, ___) {
    //     return Center(
    //       child: Container(
    //         height: 400,
    //         margin: const EdgeInsets.symmetric(horizontal: 20),
    //         decoration: BoxDecoration(
    //             color: Colors.white, borderRadius: BorderRadius.circular(40)),
    //         child: Column(
    //           children: [
    //             Text(availableVolunteers[selectedIndex].userName ?? ""),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    //   transitionBuilder: (_, anim, __, child) {
    //     Tween<Offset> tween;
    //     if (anim.status == AnimationStatus.reverse) {
    //       tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
    //     } else {
    //       tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
    //     }

    //     return SlideTransition(
    //       position: tween.animate(anim),
    //       child: FadeTransition(
    //         opacity: anim,
    //         child: child,
    //       ),
    //     );
    //   },
    // );

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
                      "http://localhost:8080/file/download/${availableVolunteers[selectedIndex].profileUrl}",
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
                "Email: ${availableVolunteers[selectedIndex].email}",
              ),
              const SizedBox(height: 10),
              Text(
                "Animals Rescued: ${availableVolunteers[selectedIndex].rescueCount.toString()}",
              ),
              const SizedBox(height: 10),
              Text(
                "City: ${availableVolunteers[selectedIndex].city}",
              ),
              const SizedBox(height: 10),
              Text(
                "Phone: ${availableVolunteers[selectedIndex].phone.toString()}",
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> assignVolunteer(String volunteerEmail, String reportId) async {
    log("Assigning volunteer");
    http.post(
      Uri.parse("http://localhost:8080/api/ngo/report/volunteer/assign"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": widget.volunteers[selectedIndex].ngos,
        "reportId": reportId,
        "volunteerId": volunteerEmail,
      }),
    );
  }
}
