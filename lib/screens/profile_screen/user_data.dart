import 'dart:convert';

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';
  final String? image;
  final String name;
  final String email;
  final String phone;

  static UserProfile myUser = UserProfile(
    image:
        "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
    name: 'Test Test',
    email: 'test.test@gmail.com',
    phone: '(208) 206-5039',
  );

  UserData(this.image,
      {required this.name, required this.email, required this.phone});

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserProfile user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static UserProfile getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : UserProfile.fromJson(jsonDecode(json));
  }
}
