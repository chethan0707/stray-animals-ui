import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:stray_animals_ui/models/user.dart';

import '../../components/appvar_widget.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class EditEmailFormPage extends StatefulWidget {
  final User user;
  const EditEmailFormPage({Key? key, required this.user}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void initState() {
    emailController.text = widget.user.email!;
    emailController.addListener(() {
      widget.user.email = emailController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    widget.user.email = email;
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
              children: [
                const SizedBox(
                    width: 320,
                    child: Text(
                      "What's your email?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 100,
                    width: 320,
                    child: TextFormField(
                      // Handles Form Validation
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Your email address'),
                      controller: emailController,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 320,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate() &&
                                  EmailValidator.validate(
                                      emailController.text)) {
                                updateUserValue(emailController.text);

                                var res = http.post(
                                  Uri.parse(
                                      "http://localhost:8080/api/user/update"),
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
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
