import 'package:testsocketchatapp/data/models/user.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

class Friend {
  User? user;
  UserPresence? presence;

  Friend({this.user, this.presence});

  Friend.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    presence = json['presence'] != null
        ? UserPresence.fromJson(json['presence'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (presence != null) {
      data['presence'] = presence!.toJson();
    }
    return data;
  }
}