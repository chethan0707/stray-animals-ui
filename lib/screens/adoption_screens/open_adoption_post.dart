import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/screens/adoption_screens/select_user.dart';
import 'package:stray_animals_ui/screens/adoption_screens/view_requests.dart';
import 'package:http/http.dart' as http;
import '../../models/adoption_post.dart';
import '../../models/user.dart';
import '../ngo_screens/reports/carousel_view.dart';

class OpenAdoptionPost extends ConsumerStatefulWidget {
  final AdoptionPost adoptionPost;
  const OpenAdoptionPost({required this.adoptionPost, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenAdoptionPostState();
}

class _OpenAdoptionPostState extends ConsumerState<OpenAdoptionPost> {
  List<User> users = [];
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var navCont = Navigator.of(context);
          users = await getUsers();
          navCont.push(
            MaterialPageRoute(
              builder: (context) =>
                  SelectUser(users: users, adoptionId: widget.adoptionPost.id!),
            ),
          );
        },
        child: const Icon(Icons.done),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Adoption Post"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(widget.adoptionPost.title!,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 20,
          ),
          CarouseWithIndicator(
            images: widget.adoptionPost.imageUrls!,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(widget.adoptionPost.description!,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: widget.adoptionPost.status == false
                ? const Text(
                    "Status: Pending",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const Text("Status: Completed"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var navContext = Navigator.of(context);
                var requests = await getUsers();
                navContext.push(
                  MaterialPageRoute(
                    builder: (context) => ViewRequests(
                      requests: requests,
                      adoptionPost: widget.adoptionPost,
                    ),
                  ),
                );
              },
              child: const Text("View requests"))
        ],
      ),
    );
  }

  Future<List<User>> getUsers() async {
    var response = await http.get(
        Uri.parse("http://localhost:8080/api/ngo/adoption/requests").replace(
      queryParameters: {
        "id": widget.adoptionPost.id.toString(),
      },
    ));
    var jsonResponse = jsonDecode(response.body) as List;
    users = jsonResponse.map((e) => User.fromJson(e)).toList();
    return users;
  }

  Future<bool> updateStatus() async {
    var response = await http
        .put(Uri.parse("http://localhost:8080/api/ngo/adoption/close").replace(
      queryParameters: {
        "id": widget.adoptionPost.id.toString(),
      },
    ));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
