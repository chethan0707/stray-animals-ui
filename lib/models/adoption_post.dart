class AdoptionPost {
  String? id;
  String? ngoID;
  bool? status;
  String? adoptedBy;
  String? title;
  String? description;
  Map<String, String>? requestList;
  List<String>? imageUrls;

  AdoptionPost(
      {this.id,
      this.ngoID,
      this.status,
      this.adoptedBy,
      this.title,
      this.description,
      this.requestList,
      this.imageUrls});

  AdoptionPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ngoID = json['ngoID'];
    status = json['status'];
    adoptedBy = json['adoptedBy'];
    title = json['title'];
    description = json['description'];
    requestList = json['requestList'].cast<String, String>();
    imageUrls = json['imageUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ngoID'] = ngoID;
    data['status'] = status;
    data['adoptedBy'] = adoptedBy;
    data['title'] = title;
    data['description'] = description;
    data['requestList'] = requestList;
    data['imageUrls'] = imageUrls;
    return data;
  }
}
