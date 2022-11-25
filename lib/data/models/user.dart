class User {
  String? sId;
  String? email;
  String? name;
  String? urlImage;
  String? deviceToken;
  int? iV;

  User({this.sId, this.email, this.name, this.urlImage, this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    urlImage = json['urlImage'];
    deviceToken = json['deviceToken'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    data['urlImage'] = urlImage;
    data['deviceToken'] = deviceToken;
    data['__v'] = iV;
    return data;
  }
}
