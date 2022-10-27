class UserPresence {
  String? sId;
  String? userID;
  bool? presence;
  String? presenceTimeStamp;
  int? iV;

  UserPresence({this.sId, this.userID, this.presence, this.iV});

  UserPresence.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    presence = json['presence'];
    presenceTimeStamp = json['presenceTimeStamp'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userID'] = userID;
    data['presence'] = presence;
    data['presenceTimeStamp'] = presenceTimeStamp;
    data['__v'] = iV;
    return data;
  }
}
