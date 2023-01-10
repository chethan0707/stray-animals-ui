import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/repositories/auth_repository.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';
import '../../models/ngo_model.dart';
import '../../models/volunteer.dart';

class JoinNGO extends ConsumerStatefulWidget {
  final Volunteer volunteer;
  final List<NGO> ngos;
  const JoinNGO({required this.ngos, required this.volunteer, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinNGOState();
}

class _JoinNGOState extends ConsumerState<JoinNGO> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Join NGO'),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: widget.ngos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(widget.ngos[index].name),
                      tileColor: selectedIndex == index
                          ? Colors.deepPurple[200]
                          : null,
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
                              "Are you sure you want to join ${widget.ngos[selectedIndex].name} as volunteer?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                var navPop = Navigator.pop(context, true);
                                var navContext = Navigator.of(context);
                                await updateVolunteer();
                                navPop;
                                var volunteer = await ref
                                    .read(authRepositoryProvider)
                                    .getVolunteerFromDB(
                                        widget.volunteer.email!);
                                log(volunteer!.userName!);
                                navContext.pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => VolunteerHome(
                                      vol: volunteer,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text('Join'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Join',
                  ),
                )
              ],
            )
          ],
        ));
  }

  void showCustomDialog(BuildContext context) {
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
                      "https://projectheena.com/uploads/ngo/34136632170024/overviewImages/images/1370675746.jpg",
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
                "NGO Name: ${widget.ngos[selectedIndex].name}",
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Email: ${widget.ngos[selectedIndex].email}",
              ),
              const SizedBox(height: 10),
              Text(
                "Animals Rescued: ${widget.ngos[selectedIndex].rescueCount.toString()}",
              ),
              const SizedBox(height: 10),
              Text(
                "City: ${widget.ngos[selectedIndex].city}",
              ),
              const SizedBox(height: 10),
              Text(
                "Phone: ${widget.ngos[selectedIndex].phone.toString()}",
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateVolunteer() async {
    http.post(
      Uri.parse("http://localhost:8080/api/volunteer/join/ngo").replace(
        queryParameters: {
          "email": widget.volunteer.email,
          "ngoId": widget.ngos[selectedIndex].email,
        },
      ),
    );
  }
}
