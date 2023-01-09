import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:http/http.dart' as http;

import '../../../models/user.dart';

class SelectUser extends ConsumerStatefulWidget {
  final String adoptionId;
  final List<User> users;
  const SelectUser({required this.adoptionId, required this.users, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VolunteerListState();
}

class _VolunteerListState extends ConsumerState<SelectUser> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Volunteers'),
      ),
      body: widget.users.isNotEmpty
          ? ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor:
                        selectedIndex == index ? Colors.deepPurple[200] : null,
                    onTap: () {
                      setState(
                        () {
                          selectedIndex = index;
                        },
                      );
                      // showCustomDialougue();
                    },
                    title: Text(widget.users[index].userName!),
                    subtitle: Text(widget.users[index].email!),
                    trailing: IconButton(
                      icon: const Icon(Icons.done),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[300],
                              title: const Text('Close post?'),
                              content: const Text(
                                  "Are you sure you want to mark post as complete?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () async {
                                    var navCon = Navigator.of(context);
                                    var scaffoldCon =
                                        ScaffoldMessenger.of(context);
                                    var navPop = Navigator.pop(context, true);
                                    var resposne = await http.get(
                                      Uri.parse(
                                              "http://localhost:8080/api/ngo/adoption/close")
                                          .replace(queryParameters: {
                                        "id": widget.adoptionId,
                                        "userEmail": widget.users[index].email
                                      }),
                                    );
                                    if (resposne.statusCode == 200) {
                                      scaffoldCon.showSnackBar(
                                        const SnackBar(
                                          content: Text("Post closed"),
                                        ),
                                      );
                                      navPop;
                                      navCon.pop();
                                      navCon.pop();
                                    } else {
                                      scaffoldCon.showSnackBar(
                                        const SnackBar(
                                          content: Text("Something went wrong"),
                                        ),
                                      );
                                      navPop;
                                    }
                                  },
                                  child: const Text('Confirm'),
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
          : const Center(
              child: Text("No users found",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
    );
  }
}
  



  // void showCustomDialougue() {
  //   showModalBottomSheet(
  //     elevation: 0,
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: 400,
  //         decoration: BoxDecoration(
  //             color: Colors.grey[400],
  //             borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(40), topRight: Radius.circular(40))),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Center(
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(100),
  //                   child: Image.network(
  //                     "http://localhost:8080/file/download/${volunteers[selectedIndex].profileUrl}",
  //                     height: 150,
  //                     width: 150,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Text(
  //               "Email: ${volunteers[selectedIndex].email}",
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               "Animals Rescued: ${volunteers[selectedIndex].rescueCount.toString()}",
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               "City: ${volunteers[selectedIndex].city}",
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               "Phone: ${volunteers[selectedIndex].phone.toString()}",
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

