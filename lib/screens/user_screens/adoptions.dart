import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/screens/user_screens/adoptions/my_requests.dart';

import '../../models/user.dart';

class Adoptions extends ConsumerStatefulWidget {
  final User user;
  const Adoptions({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdoptionsState();
}

class _AdoptionsState extends ConsumerState<Adoptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Adoption Requests"),
      ),
      body: MyRequests(user: widget.user),
    );
  }
}
