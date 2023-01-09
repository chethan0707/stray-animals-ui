import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/screens/user_screens/user_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/screens/user_screens/ngo_descprition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/photo_view_component.dart';
import '../../models/ngo_model.dart';
import '../../models/user.dart' as u;
import '../../repositories/auth_repository.dart';

class UserHome extends ConsumerStatefulWidget {
  final u.User user;
  const UserHome({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  List<NGO> ngos = [];
  Future<List<NGO>> getNGOList() async {
    return ngos = await getItems();
  }

  Future<String> getURL() async {
    String url = await ref.read(authRepositoryProvider).getURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "The Animal House",
          style: GoogleFonts.aldrich(color: Colors.black),
        ),
      ),
      drawer: NavBar(
        context: context,
        user: widget.user,
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder(
        future: getNGOList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (ngos.isEmpty) {
                return const Center(child: Text('No NGOs found'));
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ngos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NGODesc(
                                user: widget.user,
                                ngo: ngos[index],
                                userEmail: widget.user.email!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Colors.deepPurple[200],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 400,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(40),
                                                        topRight:
                                                            Radius.circular(
                                                                40))),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              PhotoViewComp(
                                                                  url: ngos[
                                                                          index]
                                                                      .email),
                                                        ));
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Image.network(
                                                          "http://localhost:8080/file/download/${ngos[index].email}",
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
                                                  "Email: ${ngos[index].email}",
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Animals Rescued: ${ngos[index].rescueCount.toString()}",
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "City: ${ngos[index].city}",
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Phone: ${ngos[index].phone.toString()}",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Container(
                                                        color: Colors.green,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            launch(
                                                                'mailto:${ngos[index].email}');
                                                          },
                                                          icon: const Icon(
                                                              Icons.email),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Container(
                                                        color: Colors.green,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            launch(
                                                                'mailto:${ngos[index].email}');
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: const Icon(
                                                              Icons.call),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.info,
                                      color: Colors.black,
                                    )),
                                title: Text(
                                  ngos[index].name,
                                  style: GoogleFonts.aldrich(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ),
                              ListTile(
                                  title: Text(
                                ngos[index].city,
                                style: GoogleFonts.aldrich(
                                    fontSize: 16, color: Colors.black),
                              )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<NGO>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngos").replace(
          // queryParameters: {"email": FirebaseAuth.instance.currentUser!.email},
          ),
    );
    var jsonBody = json.decode(response.body);
    var items = List<NGO>.from(jsonBody.map((model) => NGO.fromJson(model)));
    return items;
  }
}
