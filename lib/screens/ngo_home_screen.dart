import 'package:flutter/material.dart';
import 'package:stray_animals_ui/components/ngo_nav_bar.dart';

import '../models/ngo_model.dart';

class NGOHome extends StatelessWidget {
  final  NGO ngo;
  const  NGOHome({super.key, required this.ngo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(ngo: ngo,),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(child: Text("NGO Home")),
    );
  }
}
