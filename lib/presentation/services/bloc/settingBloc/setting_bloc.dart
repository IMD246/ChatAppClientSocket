import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final UserInformation userInformation;
  final SettingManager settingManager;
  SettingBloc({
    required this.userInformation,
    required this.settingManager,
  }) : super(
          InsideSettingState(
            userInformation: userInformation,
          ),
        ) {
    on<BackToMenuSettingEvent>(
      (event, emit) {
        emit(
          InsideSettingState(
            userInformation: event.userInformation,
          ),
        );
      },
    );
    on<GoToUpdateInfoSettingEvent>(
      (event, emit) {
        emit(
          InsideUpdateInfoState(
            userInformation: event.userInformation,
          ),
        );
      },
    );
  }
}
