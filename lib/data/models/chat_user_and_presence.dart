import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/user.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

class ChatUserAndPresence {
  Chat? chat;
  User? user;
  UserPresence? presence;

  ChatUserAndPresence({this.chat, this.user, this.presence});

  ChatUserAndPresence.fromJson(Map<String, dynamic> json) {
    chat = json['chat'] != null ? Chat.fromJson(json['chat']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    presence = json['presence'] != null ? UserPresence.fromJson(json['presence']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chat != null) {
      data['chat'] = chat!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (presence != null) {
      data['presence'] = presence!.toJson();
    }
    return data;
  }
}