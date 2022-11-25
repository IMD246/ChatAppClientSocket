import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/data/repositories/auth_repository.dart';
import 'package:testsocketchatapp/presentation/extensions/google_sign_in_extension.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_state.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';
import '../../../../constants/constant.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPref;
  final AuthRepository authRepository;
  final GoogleSignInExtension googleSignInExtension;
  final String? deviceToken;
  AuthBloc(
      {required this.sharedPref,
      required this.authRepository,
      required this.googleSignInExtension,
      required this.deviceToken})
      : super(
          AuthStateLoading(isLoading: false),
        ) {
    on<AuthEventLoginWithToken>(
      (event, emit) async {
        try {
          final token = sharedPref.getString(Constants.tokenKey);
          if (token == "" || token == null) {
            emit(
              AuthStateLoggedOut(
                isLoading: false,
              ),
            );
          } else {
            emit(
              AuthStateLoggedOut(
                isLoading: true,
              ),
            );
            final checkInfoToken = await authRepository.getData(
              body: {"deviceToken": deviceToken ?? ""},
              urlAPI: authRepository.loginByTokenURL,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              },
            );
            if (checkInfoToken != null) {
              final userInfor = authRepository.convertDynamicToObject(
                checkInfoToken.data[0],
              );
              emit(
                AuthStateLoggedIn(
                  userInformation: userInfor,
                  isLoading: false,
                ),
              );
            } else {
              emit(
                AuthStateLoggedOut(
                  isLoading: false,
                ),
              );
            }
          }
        } catch (e) {
          log(e.toString());
          emit(
            AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AuthEventLogin>(
      (event, emit) async {
        try {
          emit(
            AuthStateLoggedOut(
              isLoading: true,
            ),
          );
          final googleSignInAcc = await googleSignInExtension.login();
          if (googleSignInAcc != null) {
            final loginResponse = await authRepository.getData(
              body: {
                "email": googleSignInAcc.email,
                "name": googleSignInAcc.displayName,
                "urlImage": googleSignInAcc.photoUrl,
                "deviceToken": deviceToken
              },
              headers: {
                'Content-Type': 'application/json',
              },
              urlAPI: authRepository.loginByGoogleURL,
            );
            if (ValidateUtilities.checkBaseResponse(
                baseResponse: loginResponse)) {
              final userInfor = authRepository.convertDynamicToObject(
                loginResponse!.data[0],
              );
              await sharedPref.setString(
                Constants.tokenKey,
                userInfor.accessToken!.token ?? "",
              );
              emit(
                AuthStateLoggedIn(
                  isLoading: false,
                  userInformation: userInfor,
                ),
              );
            } else {
              emit(
                AuthStateLoggedOut(
                  isLoading: false,
                ),
              );
            }
          } else {
            emit(
              AuthStateLoggedOut(
                isLoading: false,
              ),
            );
          }
        } catch (e) {
          log(e.toString());
          emit(
            AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
    on((event, emit) => null);
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(
            AuthStateLoggedIn(
              userInformation: event.userInformation,
              isLoading: true,
            ),
          );
          await sharedPref.setString(
            Constants.tokenKey,
            "",
          );
          final logoutResponse = await authRepository.getData(
            body: {"userID": event.userInformation.user?.sId},
            urlAPI: authRepository.logoutURL,
            headers: {
              'Content-Type': 'application/json',
            },
          );
          if (ValidateUtilities.checkBaseResponse(
              baseResponse: logoutResponse)) {
            await googleSignInExtension.logout();
            emit(
              AuthStateLoggedOut(isLoading: false),
            );
          } else {
            emit(
              AuthStateLoggedIn(
                userInformation: event.userInformation,
                isLoading: false,
              ),
            );
          }
        } catch (e) {
          log(e.toString());
          emit(
            AuthStateLoggedIn(
              userInformation: event.userInformation,
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
