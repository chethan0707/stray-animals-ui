import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stray_animals_ui/models/user.dart' as user;
import 'package:stray_animals_ui/models/volunteer.dart';
import 'package:stray_animals_ui/screens/ngo_screens/ngo_home.dart';
import 'package:stray_animals_ui/screens/register_screen.dart';
import 'package:stray_animals_ui/screens/user_screens/user_home.dart';
import 'package:stray_animals_ui/screens/volunteer_screens/volunteer_home.dart';

import '../components/error_dialouge.dart';
import '../models/ngo_model.dart';
import '../repositories/auth_repository.dart';
import 'forgot_password.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String email = "";
  late String password = "";
  bool _isVisible = false;

  Future<user.User?> getUser(String email) async {
    user.User? us = await ref.read(authRepositoryProvider).getUserFromDB(email);
    if (us != null) {
      return us;
    } else {
      return null;
    }
  }

  Future<Volunteer?> getVolunteer(String email) async {
    Volunteer? us =
        await ref.read(authRepositoryProvider).getVolunteerFromDB(email);
    log("in volunteer login func");
    if (us != null) {
      return us;
    } else {
      return null;
    }
  }

  Future<NGO?> getNGO(String email) async {
    NGO? us = await ref.read(authRepositoryProvider).getNGOFromDB(email);
    if (us != null) {
      return us;
    } else {
      return null;
    }
  }

  Future<String> getUserRole(String email) async {
    log("Hello World");
    String resRole = await ref.read(authRepositoryProvider).getUserRole(email);
    log("role is $resRole");
    return resRole;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      email = _emailController.text;
    });
    _passwordController.addListener(() {
      password = _passwordController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/login_screen.svg',
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Hello Again!",
            style: GoogleFonts.bebasNeue(
              fontSize: 52,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Email'),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
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
                  obscureText: !_isVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: _isVisible == true
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                      ),
                      border: InputBorder.none,
                      hintText: 'Password'),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: InkWell(
              onTap: () async {
                try {
                  email = _emailController.text;
                  password = _passwordController.text;
                  var navContext = Navigator.of(context);
                  var scafCon = ScaffoldMessenger.of(context);
                  final firebaseUser = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  var us = await getUserRole(email);
                  if (us.isNotEmpty) {
                    // log(firebaseUser.user!.emailVerified.toString());
                    // if (firebaseUser.user!.emailVerified == false) {
                    //   await firebaseUser.user!.sendEmailVerification();
                    //   scafCon.showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Please verify your email"),
                    //     ),
                    //   );
                    // } else
                    if (us == "User") {
                      log("Verified");
                      var use = await getUser(email);
                      navContext.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => UserHome(
                                  user: use!,
                                )),
                        (route) => false,
                      );
                    } else if (us == "NGO") {
                      var ngo = await getNGO(email);
                      navContext.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => NGOHome(
                                  ngo: ngo!,
                                )),
                        (route) => false,
                      );
                    } else if (us == "Volunteer") {
                      var vol = await getVolunteer(email);
                      navContext.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => VolunteerHome(
                                  vol: vol!,
                                )),
                        (route) => false,
                      );
                    }
                  } else {
                    throw Exception("User not found");
                  }
                } on FirebaseAuthException catch (e) {
                  if (email.isEmpty || password.isEmpty) {
                    ErrorDialog().showErrorDialog(
                        context, 'email and password fields cannot be empty');
                  } else {
                    ErrorDialog()
                        .showErrorDialog(context, e.message.toString());
                  }
                } on Exception catch (e) {
                  ErrorDialog()
                      .showErrorDialog(context, "User account not found");
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
                    'Sign in',
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
                'Not a member? ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                      (route) => false);
                },
                child: const Text(
                  'Register now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'forgot password? ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ),
                  );
                },
                child: const Text(
                  'Change password',
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
    );
  }
}
