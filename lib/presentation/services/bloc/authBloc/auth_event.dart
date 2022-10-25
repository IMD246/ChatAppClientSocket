// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class AuthEvent {}

class AuthEventLogin extends AuthEvent {}

class AuthEventLoginWithToken extends AuthEvent {}

class AuthEventLogOut extends AuthEvent {
  UserInformation userInformation;
  AuthEventLogOut({
    required this.userInformation,
  });
}
