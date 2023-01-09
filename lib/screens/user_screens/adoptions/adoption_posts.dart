import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/adoption_post.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/models/user.dart';
import 'package:stray_animals_ui/screens/user_screens/adoptions/request_for_adoption.dart';

class AdoptionPosts extends ConsumerStatefulWidget {
  final String ngoEmail;
  final User user;
  const AdoptionPosts({required this.user,required this.ngoEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRequestsState();
}

class _MyRequestsState extends ConsumerState<AdoptionPosts> {
  List<AdoptionPost> posts = [];
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        posts = [];

        setState(() {});
        return Future.value();
      },
      child: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          return posts.isEmpty
              ? const Center(child: Text("No posts"))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Colors.deepPurple[200],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RequestForAdopt(
                                  post: posts[index],
                                  user: widget.user,
                                ),
                              ));
                            },
                            title: Text(posts[index].title!),
                            subtitle: Text(posts[index].description!),
                            trailing: posts[index].status == false
                                ? const Text("Status: Pending")
                                : const Text("Status: Completed"),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Future<List<AdoptionPost>> getPosts() async {
    var response = await http
        .get(Uri.parse("http://localhost:8080/api/ngo/adoptions").replace(
      queryParameters: {
        "ngoEmail": widget.ngoEmail,
      },
    ));
    var jsonResponse = jsonDecode(response.body) as List;
    posts = jsonResponse
        .map((e) => AdoptionPost.fromJson(e))
        .where((element) => element.status == false)
        .toList();
    return posts;
  }
}
