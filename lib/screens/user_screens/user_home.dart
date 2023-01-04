import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/screens/user_screens/user_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/screens/ngo_screens/ngo_descprition.dart';
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