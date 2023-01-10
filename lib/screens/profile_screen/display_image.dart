import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/components/image_view.dart';
import 'package:stray_animals_ui/components/photo_view_component.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  // Constructor
  const DisplayImage({
    Key? key,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Color.fromARGB(255, 87, 71, 179);

    return Center(
        child: Stack(children: [
      InkWell(
          onTap: () {
            log(imagePath);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImageView(url: imagePath),
            ));
          },
          child: buildImage(color)),
      Positioned(
        right: 4,
        top: 10,
        child: buildEditIcon(color),
      )
    ]));
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    final image = NetworkImage(imagePath);

    return CircleAvatar(
      radius: 75,
      backgroundColor: color,
      child: CircleAvatar(
        backgroundImage: image,
        radius: 70,
      ),
    );
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: const Icon(
        Icons.edit,
        color: Colors.black,
        size: 20,
      ));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}
