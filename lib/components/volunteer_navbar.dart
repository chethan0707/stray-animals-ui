import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:stray_animals_ui/models/event_model.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/join_ngo.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/my_ngo_desc.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/vol_events.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/nearest_pet_clinic_vol.dart';
import "package:http/http.dart" as http;
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';
import '../blocs/application_bloc.dart';
import '../models/ngo_model.dart';

class VolunteerNavBar extends ConsumerStatefulWidget {
  final Volunteer vol;
  final BuildContext context;
  const VolunteerNavBar({required this.vol, super.key, required this.context});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<VolunteerNavBar> {
  @override
  void initState() {
    // getImageUrl(widget.user.email);
    // ref.read(applicationBlocController).
    super.initState();
  }

  // getImageUrl(String? email) async {
  //   var user = await ref.read(authRepositoryProvider).getUserFromDB(email!);
  //   widget.user.profileUrl = user!.profileUrl;
  // }

  @override
  Widget build(BuildContext context) {
    final application = p.Provider.of<ApplicationBloc>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text('Reports'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VolunteerHome(vol: widget.vol),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Events'),
            onTap: () async {
              var nav = Navigator.of(context);
              var items = await getItems();
              nav.push(MaterialPageRoute(
                builder: (context) => VolunteerEventsScreen(
                    ngoEMail: widget.vol.ngos!,
                    events: items,
                    volEmail: widget.vol.email!),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Adopt'),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Near by Veterinary Clinics'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NearestPetClinicsVolunteer(vol: widget.vol),
                ));
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('My NGO'),
            onTap: () async {
              if (widget.vol.ngos!.isEmpty) {
                var navCon = Navigator.of(context);
                var ngos = await getNGOs();
                navCon.push(MaterialPageRoute(
                  builder: (context) =>
                      JoinNGO(ngos: ngos, volunteer: widget.vol),
                ));
              } else {
                var navCon = Navigator.of(context);
                var ngo = await getNGO();
                navCon.push(
                  MaterialPageRoute(
                    builder: (context) => MyNGODesc(
                      volEmail: widget.vol.email!,
                      ngo: ngo,
                      volunteer: widget.vol,
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Future<List<Event>> getItems() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngo/events").replace(
        queryParameters: {"email": widget.vol.ngos},
      ),
    );
    var jsonBody = json.decode(response.body);
    var items =
        List<Event>.from(jsonBody.map((model) => Event.fromJson(model)));
    return items;
  }

  Future<NGO> getNGO() async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/ngo/get").replace(
        queryParameters: {"email": widget.vol.ngos},
      ),
    );
    var jsonBody = json.decode(response.body);
    var ngo = NGO.fromJson(jsonBody);
    return ngo;
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
