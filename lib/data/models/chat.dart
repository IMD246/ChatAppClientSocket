class Chat {
  String? sId;
  List<String>? users;
  String? lastMessage;
  String? timeLastMessage;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<dynamic>? messages;

  Chat(
      {this.sId,
      this.users,
      this.lastMessage,
      this.timeLastMessage,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Chat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['messages'] != null) {
      messages = <Null>[];
      json['messages'].forEach((v) {
        // messages!.add(new Null.fromJson(v));
      });
    }
    users = json['users'].cast<String>();
    lastMessage = json['lastMessage'];
    timeLastMessage = json['timeLastMessage'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['messages'] = messages;
    data['users'] = users;
    data['lastMessage'] = lastMessage;
    data['timeLastMessage'] = timeLastMessage;
    data['active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
