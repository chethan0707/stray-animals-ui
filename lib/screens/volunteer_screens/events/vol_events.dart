import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/vol_completed_events.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/events/vol_upcoming_events.dart';

import '../../../models/event_model.dart';

class VolunteerEventsScreen extends ConsumerStatefulWidget {
  final String ngoEMail;
  final List<Event> events;
  final String volEmail;
  const VolunteerEventsScreen(
      {required this.ngoEMail,
      required this.volEmail,
      required this.events,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolunteerEventsScreenState();
}

class _VolunteerEventsScreenState extends ConsumerState<VolunteerEventsScreen> {
  List<Event> upcoming = [];
  List<Event> recent = [];
  @override
  void initState() {
    for (var item in widget.events) {
      if (item.status == true) {
        recent.add(item);
      } else {
        upcoming.add(item);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Events",
            style: GoogleFonts.aldrich(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4),
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Upcoming events',
                    style: GoogleFonts.aldrich(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Past events',
                    style: GoogleFonts.aldrich(
                      color: Colors.deepPurple,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UpcomingEventsVol(
                      ngoEmail: widget.ngoEMail, volEmail: widget.volEmail),
                  CompletedEventsVol(
                      ngoEmail: widget.ngoEMail, volEmail: widget.volEmail),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
