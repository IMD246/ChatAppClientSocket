class AccessToken {
  String? token;
  String? userID;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AccessToken(
      {this.token,
      this.userID,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AccessToken.fromJson(Map<String, dynamic> json) {
    token = json['accessToken'];
    userID = json['userID'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = token;
    data['userID'] = userID;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}