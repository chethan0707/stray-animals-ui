class User {
  String? email;
  String? id;
  String? phone;
  String? userName;
  String? role;
  String? profileUrl;
  List<String> userReports = [];
  List<String> adoptionPosts = [];
  User(
      {required this.adoptionPosts,
      this.email,
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
    profileUrl = json['profileURL'];
    userReports = List.castFrom<dynamic, String>(json['userReports']);
    adoptionPosts = List.castFrom<dynamic, String>(json['adoptionPosts']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['id'] = id;
    data['phone'] = phone;
    data['userName'] = userName;
    data['role'] = role;
    data['profileUrl'] = profileUrl;
    data['userReports'] = userReports;
    data['adoptionPosts'] = adoptionPosts;
    return data;
  }
}
