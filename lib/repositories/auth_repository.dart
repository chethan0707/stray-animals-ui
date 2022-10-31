import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:stray_animals_ui/models/user.dart' as user;
import 'package:stray_animals_ui/repositories/local_storage_repository.dart';

import '../models/ngo_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final LocalStorageRepository _localStorageRepository;
  final Client _client;
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required LocalStorageRepository localStorageRepository,
    required Client client,
  })  : _client = client,
        _firebaseAuth = firebaseAuth,
        _localStorageRepository = localStorageRepository;

  //Getting current user from firebase
  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String> getURL() async {
    return _firebaseAuth.currentUser?.photoURL ??
        "https://as2.ftcdn.net/v2/jpg/01/18/03/35/1000_F_118033506_uMrhnrjBWBxVE9sYGTgBht8S5liVnIeY.jpg";
  }

  Future<bool> doesUserExist(String email) async {
    String url = "http://localhost:8080/api/user/get?email=$email";

    try {
      var res = await _client.get(Uri.parse(url));
      var result;
      if (res.body.isNotEmpty) {
        result = json.decode(res.body);
      }
      if (result == null) {
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> doesNGOExist(String email) async {
    String url = "http://localhost:8080/api/ngo/get?email=$email";

    try {
      var res = await _client.get(Uri.parse(url));
      var result;
      if (res.body.isNotEmpty) {
        result = json.decode(res.body);
      }
      if (result == null) {
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<user.User?> getUserFromDB(String email) async {
    String url = "http://localhost:8080/api/user/get?email=$email";
    try {
      var res = await _client.get(Uri.parse(url));
      log(res.statusCode.toString());
      var result;
      result = json.decode(res.body);
      if (result == null) {
        return null;
      }
      var newUser = user.User.fromJson(result);
      return newUser;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<NGO?> getNGOFromDB(String email) async {
    String url = "http://localhost:8080/api/ngo/get?email=$email";
    try {
      var res = await _client.get(Uri.parse(url));
      log(res.statusCode.toString());
      var result;
      result = json.decode(res.body);
      if (result == null) {
        return null;
      }
      var ngo = NGO.fromJson(result);
      return ngo;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String> getUserRole(String email) async {
    String url = "http://localhost:8080/api/user/get?email=$email";
    String url2 = "http://localhost:8080/api/ngo/get?email=$email";
    try {
      log(email);
      var res = await _client.get(Uri.parse(url));
      log(res.statusCode.toString());
      var result;
      if (res.body.isNotEmpty) {
        result = json.decode(res.body);
      }
      if (result != null) {
        log("not null");
        var newUser = user.User.fromJson(result);
        return newUser.role!;
      }
      log("2nd url");
      var response = await _client.get(Uri.parse(url2));

      if (response.body.isNotEmpty) {
        result = json.decode(response.body);
        log(result.toString());
      }

      if (result != null) {
        var newNGO = NGO.fromJson(result);
        return newNGO.role;
      }
      return "";
    } catch (e) {
      log(e.toString());
      return "";
    }
  }

  //User Sign-in
  User? signIn(String email, String password) {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return getUser();
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
    return null;
  }

  //Create Firebase user
  Future<User?> createUser(String email, String password, String role,
      String phone, String userName) async {
    try {
      log("Create user");
      var url = "http://localhost:8080/api/user/create";
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      var response = _client.post(Uri.parse(url),
          body: jsonEncode(
            {
              "email": email,
              "phone": phone,
              "userName": userName,
              "role": role,
              "id": null
            },
          ),
          headers: {'Content-type': 'application/json'});
      return res.user;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<User?> createNGO(
    String email,
    String password,
    String role,
    String phone,
    String userName,
    String zip,
    List<double> coordinates,
    String city,
  ) async {
    try {
      var url = "http://localhost:8080/api/ngo/create";
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      var response = _client.post(Uri.parse(url),
          body: jsonEncode(
            {
              "email": email,
              "phone": phone,
              "name": userName,
              "city": city,
              "state": "Karnataka",
              "zip": zip,
              "volunteers": [],
              "coordinates": coordinates
            },
          ),
          headers: {'Content-type': 'application/json'});
      return res.user;
    } catch (e) {
      log(e.toString());
    }
  }
}