
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/adoption_post.dart';
import '../reports/carousel_view.dart';

class ClosedAdoptionPost extends ConsumerStatefulWidget {
  final AdoptionPost adoptionPost;
  const ClosedAdoptionPost({required this.adoptionPost, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenAdoptionPostState();
}

class _OpenAdoptionPostState extends ConsumerState<ClosedAdoptionPost> {
  // List<User> users = [];
  @override
  void initState() {
    // getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Text("Adopted By: ${widget.adoptionPost.adoptedBy}",
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // Future<List<User>> getUsers() async {
  //   var response = await http.get(
  //       Uri.parse("http://localhost:8080/api/ngo/adoption/requests").replace(
  //     queryParameters: {
  //       "id": widget.adoptionPost.id.toString(),
  //     },
  //   ));
  //   var jsonResponse = jsonDecode(response.body) as List;
  //   users = jsonResponse.map((e) => User.fromJson(e)).toList();
  //   return users;
  // }

  // Future<bool> updateStatus() async {
  //   var response = await http
  //       .put(Uri.parse("http://localhost:8080/api/ngo/adoption/close").replace(
  //     queryParameters: {
  //       "id": widget.adoptionPost.id.toString(),
  //     },
  //   ));
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
