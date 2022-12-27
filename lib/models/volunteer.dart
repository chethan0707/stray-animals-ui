class Volunteer {
  List<String>? reports;
  String? role;
  String? id;
  bool? status;
  String? userName;
  String? email;
  String? phone;
  int? rescueCount;
  String? city;
  String? ngos;
  String? profileUrl;

  Volunteer(
      {this.profileUrl,
      this.reports,
      this.status,
      this.role,
      this.id,
      this.userName,
      this.email,
      this.phone,
      this.rescueCount,
      this.city,
      this.ngos});

  Volunteer.fromJson(Map<String, dynamic> json) {
    reports = List.castFrom<dynamic, String>(json['reports']);
    profileUrl = json['profileUrl'];
    id = json['id'];
    role = json['role'];
    status = json['status'];
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    rescueCount = json['rescueCount'];
    city = json['city'];
    ngos = json['ngos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileUrl'] = profileUrl;
    data['id'] = id;
    data['reports'] = reports;
    data['role'] = role;
    data['userName'] = userName;
    data['email'] = email;
    data['phone'] = phone;
    data['rescueCount'] = rescueCount;
    data['city'] = city;
    if (ngos != null) {
      data['ngos'] = ngos;
    }
    return data;
  }
}
