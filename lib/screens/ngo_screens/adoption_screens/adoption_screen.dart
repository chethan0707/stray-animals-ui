import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/screens/ngo_screens/adoption_screens/completed_adoption.dart';
import 'package:stray_animals_ui/screens/ngo_screens/adoption_screens/pending_adoption_posts.dart';

import 'add_adption_post.dart';

class AdoptionScreen extends ConsumerStatefulWidget {
  final NGO ngo;
  const AdoptionScreen({required this.ngo, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends ConsumerState<AdoptionScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddAdoptionPost(ngo: widget.ngo),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
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
          title: Text(
            "Adopt",
            style: GoogleFonts.aldrich(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(
                child: Text(
                  "Pending adoptions",
                  style: GoogleFonts.aldrich(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                  style: GoogleFonts.aldrich(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  PendingAdoptionReport(ngoEmail: widget.ngo.email),
                  CompletedAdoptionReport(ngoEmail: widget.ngo.email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
