import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/event_model.dart';

class EventsScreen extends ConsumerStatefulWidget {
  final List<Event> events;
  const EventsScreen({required this.events, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  String _currentItemSelected = "Upcoming";
  var options = ["Upcoming", "Recent"];
  List<Event> recent = [];
  List<Event> upcoming = [];
  List<Event> events = [];
  @override
  void initState() {
    for (var item in widget.events) {
      if (item.status == true) {
        recent.add(item);
      } else {
        upcoming.add(item);
      }
    }
    events = widget.events;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "$_currentItemSelected Events",
            style: GoogleFonts.aldrich(color: Colors.black, fontSize: 17),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: DropdownButtonFormField2(
                  decoration: InputDecoration(
                    isDense: true,
                    focusColor: Colors.deepPurple,
                    fillColor: Colors.deepPurple,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true,
                  focusColor: Colors.transparent,
                  barrierColor: Colors.transparent,
                  barrierLabel: "Event",
                  hint: const Text(
                    'Event',
                    style: TextStyle(fontSize: 25),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                  buttonHeight: 60,
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  items: options
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _currentItemSelected = value!.toString();
                      events = _currentItemSelected == "Upcoming"
                          ? upcoming
                          : recent;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _currentItemSelected = value.toString();
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              events.isEmpty
                  ? const Center(child: Text("No upcoming events! "))
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserEv,))
                              log("Hello");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: Colors.deepPurple[200],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      events[index].eventName,
                                      style: GoogleFonts.aldrich(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                      title: Text(
                                    events[index].description,
                                    style: GoogleFonts.aldrich(
                                        fontSize: 16, color: Colors.black),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
            ],
          ),
        ));
  }
}
