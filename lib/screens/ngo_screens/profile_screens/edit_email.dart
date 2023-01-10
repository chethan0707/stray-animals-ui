import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:stray_animals_ui/models/user.dart';

import '../../../components/appvar_widget.dart';
import '../../../models/ngo_model.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class NGOEditEmailFormPage extends StatefulWidget {
  final NGO ngo;
  const NGOEditEmailFormPage({Key? key, required this.ngo}) : super(key: key);

  @override
  NGOEditEmailFormPageState createState() {
    return NGOEditEmailFormPageState();
  }
}

class NGOEditEmailFormPageState extends State<NGOEditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void initState() {
    emailController.text = widget.ngo.email;
    emailController.addListener(() {
      widget.ngo.email = emailController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    widget.ngo.email = email;
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
                                    {},
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
