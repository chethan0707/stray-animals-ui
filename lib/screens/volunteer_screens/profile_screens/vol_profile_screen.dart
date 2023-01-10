import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/screens/ngo_screens/profile_screens/update_phone.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/profile_screens/update_phone.dart';

import '../../../models/ngo_model.dart';
import '../../../models/volunteer.dart';
import '../../profile_screen/display_image.dart';
import '../../profile_screen/image_picker/set_photo_screen.dart';
import 'edit_name.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen

class VolunteerProfilePage extends StatefulWidget {
  final Volunteer ngo;

  const VolunteerProfilePage({super.key, required this.ngo});
  @override
  _VolunteerProfilePageState createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          const SizedBox(
            height: 40,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          InkWell(
              onTap: () {
                navigateSecondPage(SetPhotoScreen(
                  email: widget.ngo.email!,
                ));
              },
              child: DisplayImage(
                imagePath:
                    "http://localhost:8080/file/download/${widget.ngo.email}",
                onPressed: () {
                  setState(() {});
                },
              )),
          buildUserInfoDisplay(
            widget.ngo.userName!,
            'Name',
            VolEditNameFormPage(
              ngo: widget.ngo,
            ),
          ),
          buildUserInfoDisplay(
            widget.ngo.phone!,
            'Phone',
            VolEditPhoneFormPage(
              ngo: widget.ngo,
            ),
          ),
          buildWidgets(
            widget.ngo.email!,
            'Email',
          ),
          buildWidgets(
            widget.ngo.rescueCount.toString(),
            'Animals Rescued',
          ),
          buildWidgets(
            widget.ngo.city!,
            'City',
          )
        ],
      ),
    );
  }

  Widget buildWidgets(String getValue, String title) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            width: 350,
            height: 40,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.deepPurple,
              width: 1,
            ))),
            child: Row(
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          getValue,
                          style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: Colors.deepPurple),
                        ))),
              ],
            ),
          )
        ],
      ));

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.deepPurple,
                  width: 1,
                ))),
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: title != 'Email'
                                ? () {
                                    navigateSecondPage(editPage);
                                  }
                                : () {},
                            child: Text(
                              getValue,
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.deepPurple),
                            ))),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                      size: 40.0,
                    )
                  ],
                ),
              )
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
