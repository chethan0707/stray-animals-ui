import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/adoption_post.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/photo_view_component.dart';

class ViewRequests extends ConsumerStatefulWidget {
  final List<User> requests;
  final AdoptionPost adoptionPost;
  const ViewRequests(
      {required this.adoptionPost, required this.requests, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends ConsumerState<ViewRequests> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Requests"),
        ),
        body: ListView.builder(
          itemCount: widget.requests.length,
          itemBuilder: (context, index) {
            log(widget.requests.length.toString());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.deepPurple[200],
                ),
                child: ListTile(
                  title: Text(widget.requests[index].userName!),
                  subtitle: Text(widget.requests[index].email!),
                  onTap: () async {
                    log(widget.adoptionPost.requestList.toString());
                    log(widget.requests[index].id.toString());
                    log(widget
                        .adoptionPost.requestList![widget.requests[index].id]
                        .toString());
                    showModalBottomSheet(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => PhotoViewComp(
                                            url: widget
                                                .requests[index].profileUrl!),
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        "http://localhost:8080/file/download/${widget.requests[index].email}",
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                "Email: ${widget.requests[index].email}",
                              ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   "Animals Rescued: ${widget.requests[index].}",
                              // ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   "City: ${widget.requests[index]}",
                              // ),
                              const SizedBox(height: 20),
                              Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                "Phone: ${widget.requests[index].phone.toString()}",
                              ),
                              const SizedBox(height: 20),
                              Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                "Requested Visit Schedule: ${widget.adoptionPost.requestList![widget.requests[index].id]}",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      color: Colors.green,
                                      child: IconButton(
                                        onPressed: () {
                                          launch(
                                              'mailto:${widget.requests[index].email}');
                                        },
                                        icon: const Icon(Icons.email),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      color: Colors.green,
                                      child: IconButton(
                                        onPressed: () {
                                          launch(
                                              'mailto:${widget.requests[index].email}');
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.call),
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
                ),
              ),
            );
          },
        ));
  }
}
