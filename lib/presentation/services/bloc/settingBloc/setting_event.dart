import '../../../../data/models/user_info.dart';

abstract class SettingEvent{}
class BackToMenuSettingEvent extends SettingEvent {
  final UserInformation userInformation;
  BackToMenuSettingEvent({
    required this.userInformation,
  });
}
class GoToUpdateInfoSettingEvent extends SettingEvent {
  final UserInformation userInformation;
  GoToUpdateInfoSettingEvent({
    required this.userInformation,
  });
}

class GoToUpdateThemeModeSettingEvent extends SettingEvent {
  final UserInformation userInformation;
  GoToUpdateThemeModeSettingEvent({
    required this.userInformation,
  });
}
