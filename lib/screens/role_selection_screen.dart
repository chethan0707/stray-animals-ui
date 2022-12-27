import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/repositories/auth_repository.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:stray_animals_ui/screens/profile_screen/image_picker/set_photo_screen.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  const RoleSelectionScreen(
      {super.key, required this.email, required this.password});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ngoNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _vPhController = TextEditingController();
  final TextEditingController _vuNameController = TextEditingController();
  final TextEditingController _vCityController = TextEditingController();
  late String vUname = "";
  late String vPhNo = "";
  late String vCity = "";

  late String userName = "";
  late String ngoName = "";
  late String city = "";
  late String zipCode = "";
  late String state = "";
  late String phoneNumber = "";
  bool isProfileImageSet = false;
  @override
  void initState() {
    _vCityController.addListener(() {
      vCity = _vCityController.text;
    });
    _vuNameController.addListener(() {
      vUname = _vuNameController.text;
    });
    _vPhController.addListener(() {
      vPhNo = _vPhController.text;
    });
    _usernameController.addListener(() {
      userName = _usernameController.text;
    });
    _ngoNameController.addListener(() {
      ngoName = _ngoNameController.text;
    });
    _cityController.addListener(() {
      city = _cityController.text;
    });
    _zipController.addListener(() {
      zipCode = _zipController.text;
    });
    _stateController.addListener(() {
      state = _stateController.text;
    });
    _phoneNumberController.addListener(() {
      phoneNumber = _phoneNumberController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _vCityController.dispose();
    _vuNameController.dispose();
    _vPhController.dispose();
    _usernameController.dispose();
    _cityController.dispose();
    _ngoNameController.dispose();
    _stateController.dispose();
    _phoneNumberController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<List<double>> getCoOrdinates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    List<double> coordinates = [];
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition();
      coordinates.add(currentPosition.latitude);
      coordinates.add(currentPosition.longitude);
    }
    return coordinates;
  }

  Future<bool> doesUserExist(String email) async {
    return await ref.read(authRepositoryProvider).doesUserExist(email);
  }

  Future<bool> doesNGOExist(String email) async {
    return await ref.read(authRepositoryProvider).doesNGOExist(email);
  }

  Future<bool> doesVolunteerExist(String email) async {
    return await ref.read(authRepositoryProvider).doesVolunteerExist(email);
  }

  Future<void> signUpUser(String email, String password, String userName,
      String role, String phone) async {
    await ref.read(authRepositoryProvider).createUser(
          email,
          password,
          role,
          phone,
          userName,
        );
  }

  Future<void> signUpVolunteer(String email, String password, String userName,
      String role, String phone, String city) async {
    await ref.read(authRepositoryProvider).createVolunteer(
          email,
          phone,
          city,
          userName,
          password,
        );
  }

  Future<void> signUpNGO(String email, String password, String ngoName,
      String role, String phone, String zip, List<double> coordinates) async {
    await ref.read(authRepositoryProvider).createNGO(
        email, password, role, phone, ngoName, zip, coordinates, city);
  }

  bool isUserNameEmpty(String uName) {
    return uName.isEmpty;
  }

  var options = ['User', 'NGO', 'Volunteer'];
  var _currentItemSelected = "";
  var role = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create account"),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text("Select Role", style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 00,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: DropdownButtonFormField2(
                decoration: InputDecoration(
                  isDense: true,
                  focusColor: Colors.deepPurple,
                  fillColor: Colors.deepPurple,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                isExpanded: true,
                focusColor: Colors.transparent,
                barrierColor: Colors.transparent,
                barrierLabel: "Role",
                hint: const Text(
                  'Select Your Role',
                  style: TextStyle(fontSize: 25),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                items: options
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select role.';
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _currentItemSelected = value!.toString();
                    log(value.toString());
                  });
                },
                onSaved: (value) {
                  _currentItemSelected = value.toString();
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            buildWidgets(_currentItemSelected),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: InkWell(
                onTap: () async {
                  isProfileImageSet = true;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SetPhotoScreen(
                              email: widget.email,
                            )),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Add profile image',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: InkWell(
                onTap: () async {
                  if (_currentItemSelected == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User cannot be empty"),
                      ),
                    );
                  } else if (_currentItemSelected == "User" &&
                      isUserNameEmpty(userName) &&
                      phoneNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fields cannot be empty"),
                      ),
                    );
                  } else if (isProfileImageSet == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Uppload profile picture"),
                      ),
                    );
                  } else if (_currentItemSelected == "NGO" &&
                      (ngoName.isEmpty ||
                          city.isEmpty ||
                          zipCode.isEmpty ||
                          phoneNumber.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fill all fields"),
                      ),
                    );
                  } else if (_currentItemSelected == "User") {
                    var scMessanger = ScaffoldMessenger.of(context);
                    var navContext = Navigator.of(context);
                    var flag = await doesUserExist(widget.email);
                    if (flag == true) {
                      log("user already exists");
                      scMessanger.showSnackBar(
                        const SnackBar(
                          content: Text("Email already registered"),
                        ),
                      );
                    } else {
                      await signUpUser(widget.email, widget.password, userName,
                          _currentItemSelected, phoneNumber);
                      navContext.push(MaterialPageRoute(
                          builder: (navContext) => const LoginScreen()));
                    }
                  } else if (_currentItemSelected == "NGO") {
                    var navContext = Navigator.of(context);
                    var scMessanger = ScaffoldMessenger.of(context);
                    var coordinates = await getCoOrdinates();

                    var flag = await doesNGOExist(widget.email);
                    if (flag == true) {
                      scMessanger.showSnackBar(
                        const SnackBar(
                          content: Text("Email already registered"),
                        ),
                      );
                    } else if (coordinates.isEmpty) {
                      scMessanger.showSnackBar(
                        const SnackBar(
                          content: Text("Turn on location"),
                        ),
                      );
                    } else {
                      await signUpNGO(
                          widget.email,
                          widget.password,
                          ngoName,
                          _currentItemSelected,
                          phoneNumber,
                          zipCode,
                          coordinates);
                      navContext.push(MaterialPageRoute(
                          builder: (navContext) => const LoginScreen()));
                    }
                  } else if (_currentItemSelected == "Volunteer") {
                    var navContext = Navigator.of(context);
                    var scMessanger = ScaffoldMessenger.of(context);

                    var flag = await doesVolunteerExist(widget.email);
                    if (flag == true) {
                      scMessanger.showSnackBar(
                        const SnackBar(
                          content: Text("Email already registered"),
                        ),
                      );
                    } else {
                      await signUpVolunteer(
                        widget.email,
                        widget.password,
                        vUname,
                        _currentItemSelected,
                        vPhNo,
                        vCity,
                      );
                      navContext.push(MaterialPageRoute(
                          builder: (navContext) => const LoginScreen()));
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already signed-up? ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    'Sing in',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildWidgets(String selectedItem) {
    log(selectedItem);
    switch (selectedItem) {
      case "User":
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Username",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_usernameController, 'User name'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Phone no.",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_phoneNumberController, 'Phone number')
          ],
        );
      case "NGO":
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter NGO name",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildTextFiled(_ngoNameController, 'NGO name'),
//phone
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Phone number",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_phoneNumberController, 'Phone number'),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter City", style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_cityController, "City"),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Zip code",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_zipController, "Zip-code")
          ],
        );
      case "Volunteer":
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Username",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildTextFiled(_vuNameController, 'Username'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter Phone number",
                      style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_vPhController, 'Phone number'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Enter City", style: GoogleFonts.aldrich(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildTextFiled(_vCityController, "City"),
            const SizedBox(
              height: 20,
            ),
          ],
        );
    }
    return Column();
  }

  Widget buildTextFiled(TextEditingController tXController, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            maxLength: hintText == "Phone number"
                ? 10
                : hintText == "Zip-code"
                    ? 6
                    : 20,
            keyboardType: hintText == "Phone number" || hintText == "Zip-code"
                ? TextInputType.number
                : TextInputType.text,
            controller: tXController,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ),
    );
  }
}
