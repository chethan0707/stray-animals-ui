import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/report_model/user_report_model.dart';
import 'package:stray_animals_ui/screens/user_screens/user_reports/closed_reports.dart';
import 'package:stray_animals_ui/screens/user_screens/user_reports/open_reports_list.dart';

class MyReports extends ConsumerStatefulWidget {
  final List<String> reports;
  final String userEmail;
  const MyReports({required this.userEmail, required this.reports, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyReportsState();
}

class _MyReportsState extends ConsumerState<MyReports> {
  List<UserReport> openReports = [];
  List<UserReport> closedReports = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          title: const Text(
            "My Reports",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Open",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "Closed",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OpenReportsList(userEmail: widget.userEmail),
                  ClosedReportList(userEmail: widget.userEmail)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
