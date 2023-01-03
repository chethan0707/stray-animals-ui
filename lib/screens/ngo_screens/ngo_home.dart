import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/screens/ngo_screens/ngo_navbar.dart';
import 'package:stray_animals_ui/screens/ngo_screens/reports/ngo_closed_reports.dart';
import 'package:stray_animals_ui/screens/ngo_screens/reports/ngo_open_reports.dart';

class NGOHome extends ConsumerStatefulWidget {
  final NGO ngo;
  const NGOHome({required this.ngo, super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NGOHomeState();
}

class _NGOHomeState extends ConsumerState<NGOHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          drawer: NavBar(ngo: widget.ngo),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Reports",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Active Reports",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Closed",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NGOOpenReports(ngo: widget.ngo),
              NGOCloseReports(ngo: widget.ngo),
            ],
          )),
    );
  }
}
