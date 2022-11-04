import 'package:testsocketchatapp/data/models/message.dart';

class Chat {
  String? sId;
  List<String>? users;
  String? lastMessage;
  String? timeLastMessage;
  String? userIDLastMessage;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Message>? messages;

  Chat(
      {this.sId,
      this.users,
      this.lastMessage,
      this.timeLastMessage,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.messages});

  Chat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    users = json['users'].cast<String>();
    lastMessage = json['lastMessage'];
    timeLastMessage = json['timeLastMessage'];
    userIDLastMessage = json['userIDLastMessage'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['users'] = users;
    data['lastMessage'] = lastMessage;
    data['timeLastMessage'] = timeLastMessage;
    data['userIDLastMessage'] = userIDLastMessage;
    data['active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}