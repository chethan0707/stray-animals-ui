import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:stray_animals_ui/screens/user_screens/adoptions/adoption_posts.dart';
import 'package:stray_animals_ui/screens/user_screens/adoptions/my_requests.dart';
import 'package:stray_animals_ui/screens/user_screens/user_reports/my_reports.dart';

class UserAdoptionScreen extends ConsumerStatefulWidget {
  final User user;
  final NGO ngo;
  const UserAdoptionScreen({required this.user, required this.ngo, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAdoptionScreenState();
}

class _UserAdoptionScreenState extends ConsumerState<UserAdoptionScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Adoptions"),
          ),
          body: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Adoption Posts",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "My Requests",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AdoptionPosts(
                      ngoEmail: widget.ngo.email,
                      user: widget.user,
                    ),
                    MyRequests(user: widget.user),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
