import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stray_animals_ui/models/ngo_model.dart';
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';
import 'package:string_validator/string_validator.dart';

import 'package:http/http.dart' as http;

import '../../../components/appvar_widget.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class VolEditNameFormPage extends StatefulWidget {
  Volunteer ngo;
  VolEditNameFormPage({required this.ngo, Key? key}) : super(key: key);

  @override
  VolEditNameFormPageState createState() {
    return VolEditNameFormPageState();
  }
}

class VolEditNameFormPageState extends State<VolEditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

  @override
  void initState() {
    _userNameController.text = widget.ngo.userName!;
    _userNameController.addListener(() {
      widget.ngo.userName = _userNameController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    widget.ngo.userName = name;
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
                  "What's Your Username?",
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
                              maxLength: 30,
                              // Handles Form Validation for First Name
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter user name';
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
                  onTap: () async {
                    var nav = Navigator.of(context);
                    var scaff = ScaffoldMessenger.of(context);
                    log(widget.ngo.userName!);
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      var res = await http.post(
                        Uri.parse("http://localhost:8080/api/volunteer/update"),
                        body: jsonEncode(
                          {
                            "id": widget.ngo.id,
                            "userName": widget.ngo.userName,
                            "phone": widget.ngo.phone,
                            "role": "Volunteer",
                            "email": widget.ngo.email,
                            "status": widget.ngo.status,
                            "resueCount": widget.ngo.rescueCount,
                            "profileUrl": widget.ngo.profileUrl,
                            "reports": widget.ngo.reports,
                            "city": widget.ngo.city,
                            "events": widget.ngo.events,
                            "ngos": widget.ngo.ngos
                          },
                        ),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                      );
                      if (res.statusCode == 200) {
                        scaff.showSnackBar(const SnackBar(
                            content: Text("Updated Successfully")));
                        res = await http.get(Uri.parse(
                            "http://localhost:8080/api/volunteer/get?email=${widget.ngo.email}"));
                        log(res.body.toString());
                        var ngo = Volunteer.fromJson(jsonDecode(res.body));
                        nav.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => VolunteerHome(
                              vol: widget.ngo,
                            ),
                          ),
                          (route) => false,
                        );
                      } else {
                        scaff.showSnackBar(
                            const SnackBar(content: Text("Error Updating")));
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
