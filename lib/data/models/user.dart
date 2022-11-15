class User {
  String? sId;
  String? email;
  String? name;
  bool? isDarkMode;
  String? urlImage;
  String? deviceToken;
  String? languageCode;
  String? countryCode;
  int? iV;

  User(
      {this.sId,
      this.email,
      this.name,
      this.isDarkMode,
      this.urlImage,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    isDarkMode = json['isDarkMode'];
    urlImage = json['urlImage'];
    deviceToken = json['deviceToken'];
    languageCode = json['languageCode'];
    countryCode = json['countryCode'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    data['isDarkMode'] = isDarkMode;
    data['urlImage'] = urlImage;
    data['deviceToken'] = deviceToken;
    data['languageCode'] = languageCode;
    data['countryCode'] = countryCode;
    data['__v'] = iV;
    return data;
  }
}
