import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/adoption_post.dart';
import 'package:http/http.dart' as http;

import 'open_adoption_post.dart';

class PendingAdoptionReport extends ConsumerStatefulWidget {
  final String ngoEmail;
  const PendingAdoptionReport({required this.ngoEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PendingAdoptionReportState();
}

class _PendingAdoptionReportState extends ConsumerState<PendingAdoptionReport> {
  var posts = <AdoptionPost>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: RefreshIndicator(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OpenAdoptionPost(
                                        adoptionPost: posts[index],
                                      ),
                                    ),
                                  );
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
        ));
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
