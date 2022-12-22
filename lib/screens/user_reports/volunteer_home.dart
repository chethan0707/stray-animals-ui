import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/models/volunteer.dart';

class VolunteerHome extends ConsumerStatefulWidget {
  final Volunteer vol;
  const VolunteerHome({required this.vol, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends ConsumerState<VolunteerHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Hello volunteer"),
    );
  }
}
