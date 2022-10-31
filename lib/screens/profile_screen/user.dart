class UserProfile {
  String image;
  String name;
  String email;
  String phone;

  // Constructor
  UserProfile({
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
  });

  UserProfile copy({
    String? imagePath,
    String? name,
    String? phone,
    String? email,
  }) =>
      UserProfile(
        image: imagePath ?? this.image,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
        image: json['imagePath'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
