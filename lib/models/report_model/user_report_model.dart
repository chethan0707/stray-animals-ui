class UserReport {
  final String caseId;
  final String userId;
  final List<double> coordinates;
  final bool status;
  final List<String> urls;

  UserReport({
    required this.caseId,
    required this.userId,
    required this.coordinates,
    required this.status,
    required this.urls,
  });

  Map toJson() => {
        'caseId': caseId,
        'userId': userId,
        'coordinates': coordinates,
        'status': status,
        'urls': urls
      };

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      caseId: json['caseId'],
      userId: json['userID'],
      coordinates: json['coordinates'],
      status: json['status'],
      urls: json['urls'],
    );
  }
}
