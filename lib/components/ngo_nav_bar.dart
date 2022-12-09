import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stray_animals_ui/screens/events_screen/ngo_events_main_screen.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/ngo_model.dart';

class NavBar extends StatelessWidget {
  final NGO ngo;
  const NavBar({super.key, required this.ngo});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(ngo.name),
            accountEmail: Text(ngo.email),
            currentAccountPicture: InkWell(
              onTap: () {
                // TODO: NGO profile page edit
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => ProfilePage(),
                // ));
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://as2.ftcdn.net/v2/jpg/01/18/03/35/1000_F_118033506_uMrhnrjBWBxVE9sYGTgBht8S5liVnIeY.jpg',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: NetworkImage(
              //         'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () async {
              var navContext = Navigator.of(context);
              var items = await getItems();
              navContext.push(
                MaterialPageRoute(
                  builder: (context) => NGOEventMainScreen(
                    ngoEmail: ngo.email,
                    events: items,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Volunteers'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Reports'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {},
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
        queryParameters: {"email": ngo.email},
      ),
    );
    var jsonBody = json.decode(response.body);
    var items =
        List<Event>.from(jsonBody.map((model) => Event.fromJson(model)));
    return items;
  }
}
