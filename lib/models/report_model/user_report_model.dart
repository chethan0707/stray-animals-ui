class UserReport {
  final String? volunteer;
  final String caseId;
  final String userId;
  final List<double> coordinates;
  final bool status;
  final List<String> urls;
  final String ngoId;
  final String description;
  UserReport({
    required this.volunteer,
    required this.description,
    required this.ngoId,
    required this.caseId,
    required this.userId,
    required this.coordinates,
    required this.status,
    required this.urls,
  });

  Map toJson() => {
        'volunteer': volunteer,
        'description': description,
        'caseId': caseId,
        'userId': userId,
        'coordinates': coordinates,
        'status': status,
        'urls': urls,
        'ngoId': ngoId
      };

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      volunteer: json['volunteer'],
      description: json['description'],
      ngoId: json['ngoId'],
      caseId: json['caseId'],
      userId: json['userId'],
      coordinates: List.castFrom<dynamic, double>(json['coordinates']),
      status: json['status'],
      urls: List.castFrom<dynamic, String>(json['urls']),
    );
  }
}
