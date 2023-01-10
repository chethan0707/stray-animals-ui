import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/repositories/auth_repository.dart';
import 'package:stray_animals_ui/screens/ngo_screens/ngo_home.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';
import 'package:string_validator/string_validator.dart';

import 'package:http/http.dart' as http;

import '../../../components/appvar_widget.dart';
import '../../../models/ngo_model.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
class NGOEditPhoneFormPage extends StatefulWidget {
  final NGO ngo;
  const NGOEditPhoneFormPage({required this.ngo, Key? key}) : super(key: key);
  @override
  NGOEditPhoneFormPageState createState() {
    return NGOEditPhoneFormPageState();
  }
}

class NGOEditPhoneFormPageState extends State<NGOEditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  @override
  void initState() {
    phoneController.text = widget.ngo.phone;
    phoneController.addListener(() {
      // widget.ngo.phone = phoneController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
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
                      "What's Your Phone Number?",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (isAlpha(value)) {
                              return 'Only Numbers Please';
                            } else if (value.length < 10) {
                              return 'Please enter a VALID phone number';
                            }
                            return null;
                          },
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Your Phone Number',
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            var nav = Navigator.of(context);
                            var scaff = ScaffoldMessenger.of(
                                context); // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate() &&
                                isNumeric(phoneController.text)) {
                              var res = await http.post(
                                Uri.parse(
                                    "http://localhost:8080/api/ngo/update"),
                                body: jsonEncode(
                                  {},
                                ),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                              );
                              if (res.statusCode == 200) {
                                scaff.showSnackBar(const SnackBar(
                                    content: Text("Updated Successfully")));
                                res = await http.get(Uri.parse(
                                    "http://localhost:8080/api/ngo/get?email=${widget.ngo.email}"));
                                log(res.body.toString());
                                var ngo = NGO.fromJson(jsonDecode(res.body));
                                nav.pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => NGOHome(
                                      ngo: ngo,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                scaff.showSnackBar(const SnackBar(
                                    content: Text("Error Updating")));
                              }
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
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
