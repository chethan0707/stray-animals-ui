import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/models/user.dart';
import 'package:string_validator/string_validator.dart';

import '../../components/appvar_widget.dart';
import 'package:http/http.dart' as http;

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  final String uname;
  final User user;
  const EditNameFormPage({required this.user, Key? key, required this.uname})
      : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

  @override
  void initState() {
    _userNameController.text = widget.uname;
    _userNameController.addListener(() {
      widget.user.userName = _userNameController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    widget.user.userName = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 330,
                child: Text(
                  "What's Your Name?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                        child: SizedBox(
                            height: 100,
                            width: 320,
                            child: TextFormField(
                              // Handles Form Validation for First Name
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                } else if (!isAlpha(value)) {
                                  return 'Only Letters Please';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                              ),
                              controller: _userNameController,
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: InkWell(
                  onTap: () {
                    log(widget.user.userName!);
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate() &&
                        isAlpha(_userNameController.text)) {
                      updateUserValue(_userNameController.text);
                      var res = http.post(
                          Uri.parse("http://localhost:8080/api/user/update"),
                          body: jsonEncode(
                            {
                              "id": widget.user.id,
                              "userName": widget.user.userName,
                              "phone": widget.user.phone,
                              "role": widget.user.role,
                              "email": widget.user.email,
                              "profileURL": widget.user.profileUrl,
                              "userReports": widget.user.userReports,
                              "adoptionPosts": widget.user.adoptionPosts
                            },
                          ),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
