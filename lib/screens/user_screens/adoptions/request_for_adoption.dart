import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/adoption_post.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:http/http.dart' as http;
import '../../ngo_screens/reports/carousel_view.dart';

class RequestForAdopt extends ConsumerStatefulWidget {
  final User user;
  final AdoptionPost post;
  const RequestForAdopt({required this.user, required this.post, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestForAdoptState();
}

class _RequestForAdoptState extends ConsumerState<RequestForAdopt> {
  Set<String> st = {};
  @override
  void initState() {
    st = widget.post.requestList!.keys.toSet();
    super.initState();
  }

  String date = "";
  String time = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request for Adoption"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(widget.post.title!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(
                height: 20,
              ),
              CarouseWithIndicator(
                images: widget.post.imageUrls!,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.post.description!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: widget.post.status == false
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
              st.contains(widget.user.id)
                  ? Text("Already Request made")
                  : ElevatedButton(
                      onPressed: () async {
                        buildTimePicker();
                      },
                      child: const Text("Request for visit"))
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> buildTimePicker() {
    return DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2023, 6, 7),
      onChanged: (dateTime) {},
      onConfirm: (dateTime) {
        date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
        time = "${dateTime.hour}:${dateTime.minute}";
        updateAdoptionPost();
        setState(() {});
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  Future<void> updateAdoptionPost() async {
    http.post(Uri.parse("http://localhost:8080/api/user/join/requestlist")
        .replace(queryParameters: {
      "adoptionID": widget.post.id,
      "userEmail": widget.user.id,
      "time": "$date $time"
    }));
  }
}
