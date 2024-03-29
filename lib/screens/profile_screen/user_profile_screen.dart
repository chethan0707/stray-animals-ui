import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:stray_animals_ui/screens/profile_screen/update_phone.dart';

import 'display_image.dart';
import 'edit_email.dart';
import 'edit_name.dart';
import 'image_picker/set_photo_screen.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  email: widget.user.email!,
                ));
              },
              child: DisplayImage(
                imagePath:
                    "http://localhost:8080/file/download/${widget.user.email}",
                onPressed: () {
                  setState(() {});
                },
              )),
          buildUserInfoDisplay(
            widget.user.userName!,
            'Name',
            EditNameFormPage(
              user: widget.user,
              uname: widget.user.userName!,
            ),
          ),
          buildUserInfoDisplay(
            widget.user.phone!,
            'Phone',
            EditPhoneFormPage(
              user: widget.user,
            ),
          ),
          buildUserInfoDisplay(
              widget.user.email!,
              'Email',
              EditEmailFormPage(
                user: widget.user,
              )),
        ],
      ),
    );
  }

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
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.deepPurple),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                      size: 40.0,
                    )
                  ]))
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
