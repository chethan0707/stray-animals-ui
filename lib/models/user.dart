import 'package:stray_animals_ui/models/report_model/user_report_model.dart';

class User {
  String? email;
  String? id;
  String? phone;
  String? userName;
  String? role;
  String? profileUrl;
  List<UserReport> userReports = [];
  User(
      {this.email,
      this.id,
      this.phone,
      this.userName,
      this.role,
      required this.userReports,
      this.profileUrl});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    phone = json['phone'];
    userName = json['userName'];
    role = json['role'];
    profileUrl = json['profileUrl'];
    userReports = (json['userReports'] as List)
        .map((e) => UserReport.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = this.email;
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['userName'] = this.userName;
    data['role'] = this.role;
    data['profileUrl'] = this.profileUrl;
    data['userReports'] = userReports.map((e) => e.toJson()).toList();
    return data;
  }
}
