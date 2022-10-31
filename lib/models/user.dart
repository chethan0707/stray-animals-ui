class User {
  String? email;
  String? id;
  String? phone;
  String? userName;
  String? role;
  User({this.email, this.id, this.phone, this.userName, this.role});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    phone = json['phone'];
    userName = json['userName'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['userName'] = this.userName;
    data['role'] = this.role;
    return data;
  }
}
