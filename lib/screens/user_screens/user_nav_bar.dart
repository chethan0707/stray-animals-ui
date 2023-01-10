import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/components/settgins.dart';
import 'package:stray_animals_ui/models/user.dart' as u;
import 'package:stray_animals_ui/repositories/auth_repository.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:stray_animals_ui/screens/user_screens/adoptions.dart';
import 'package:stray_animals_ui/screens/user_screens/nearest_pet_store.dart';
import 'package:stray_animals_ui/screens/profile_screen/user_profile_screen.dart';
import 'package:stray_animals_ui/screens/user_screens/user_home.dart';
import 'package:stray_animals_ui/screens/user_screens/user_reports/my_reports.dart';
import 'package:http/http.dart' as http;

class NavBar extends ConsumerStatefulWidget {
  final u.User user;
  final BuildContext context;
  const NavBar({super.key, required this.user, required this.context});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override
  void initState() {
    // getImageUrl(widget.user.email);
    // ref.read(applicationBlocController).
    super.initState();
  }

  Future<Uint8List> getImageBytes(String path) async {
    var response = await http.get(Uri.parse(path));
    return response.bodyBytes;
  }
  // getImageUrl(String? email) async {
  //   var user = await ref.read(authRepositoryProvider).getUserFromDB(email!);
  //   widget.user.profileUrl = user!.profileUrl;
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.userName!),
            accountEmail: Text(widget.user.email!),
            currentAccountPicture: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: widget.user),
                ));
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    "http://localhost:8080/file/download/${widget.user.email}",
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
            leading: const Icon(Icons.house),
            title: const Text('NGOs'),
            onTap: () async {
              var con = Navigator.of(context);
              var us = await ref
                  .read(authRepositoryProvider)
                  .getUserFromDB(widget.user.email!);
              con.push(MaterialPageRoute(
                builder: (con) => UserHome(user: us!),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My  Reports'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyReports(
                        reports: widget.user.userReports,
                        userEmail: widget.user.email!),
                  ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.pets),
          //   title: const Text('Adopt'),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) =>  UserAdoptionScreen(
          //           ngo: ,
          //         ),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Near by Veterinary Clinics'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NearestPetClinics(user: widget.user),
                  ),
                );
              }),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Adoptions'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Adoptions(user: widget.user),
              ));
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
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
