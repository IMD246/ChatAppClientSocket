import 'package:testsocketchatapp/data/models/access_token.dart';
import 'package:testsocketchatapp/data/models/user.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

class UserInformation {
  AccessToken? accessToken;
  User? user;
  UserPresence? userPresence;

  UserInformation({this.accessToken, this.user, this.userPresence});

  UserInformation.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'] != null
        ? AccessToken.fromJson(json['accessToken'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userPresence = json['userPresence'] != null
        ? UserPresence.fromJson(json['userPresence'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accessToken != null) {
      data['accessToken'] = accessToken!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userPresence != null) {
      data['userPresence'] = userPresence!.toJson();
    }
    return data;
  }
}
