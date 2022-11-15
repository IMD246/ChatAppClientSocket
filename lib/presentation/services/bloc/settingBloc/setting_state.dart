import '../../../../data/models/user_info.dart';

abstract class SettingState {}

class InsideSettingState extends SettingState {
  final UserInformation userInformation;
  InsideSettingState({required this.userInformation});
}

class InsideUpdateInfoState extends SettingState {
  final UserInformation userInformation;
  InsideUpdateInfoState({
    required this.userInformation,
  });
}
class InsideSearchState extends SettingState {
  final UserInformation userInformation;
  InsideSearchState({required this.userInformation});
}
