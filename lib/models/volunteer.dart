import 'package:stray_animals_ui/models/ngo_model.dart';

class Volunteer {
  String? role;
  String? id;
  String? userName;
  String? email;
  String? phone;
  int? rescueCount;
  String? city;
  List<NGO>? ngos;
  String? profileUrl;

  Volunteer(
      {this.profileUrl,
      this.role,
      this.id,
      this.userName,
      this.email,
      this.phone,
      this.rescueCount,
      this.city,
      this.ngos});

  Volunteer.fromJson(Map<String, dynamic> json) {
    profileUrl = json['profileUrl'];
    id = json['id'];
    role = json['role'];
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    rescueCount = json['rescueCount'];
    city = json['city'];
    if (json['ngos'] != null) {
      ngos = <NGO>[];
      json['ngos'].forEach((v) {
        ngos!.add(NGO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileUrl'] = profileUrl;
    data['id'] = id;
    data['role'] = role;
    data['userName'] = userName;
    data['email'] = email;
    data['phone'] = phone;
    data['rescueCount'] = rescueCount;
    data['city'] = city;
    if (ngos != null) {
      data['ngos'] = ngos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
