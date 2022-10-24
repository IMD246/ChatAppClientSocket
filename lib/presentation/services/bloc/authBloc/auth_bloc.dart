import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/data/repositories/auth_repository.dart';
import 'package:testsocketchatapp/presentation/extensions/google_sign_in_extension.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_state.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $tokenUser'
  //     }
  final Future<SharedPreferences> sharedPref;
  final AuthRepository authRepository;
  final GoogleSignInExtension googleSignInExtension;
  AuthBloc({
    required this.sharedPref,
    required this.authRepository,
    required this.googleSignInExtension,
  }) : super(
          AuthStateLoading(isLoading: false),
        ) {
    on<AuthEventLoginWithToken>(
      (event, emit) async {
        try {
          emit(
            AuthStateLoggedOut(
              isLoading: true,
            ),
          );
          final pref = await sharedPref;
          final token = pref.getString("token");
          if (token == null) {
            emit(
              AuthStateLoggedOut(
                isLoading: false,
              ),
            );
          } else {
            final checkInfoToken = await authRepository.getData(
              body: {},
              urlAPI: authRepository.loginByTokenURL,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              },
            );
            if (checkInfoToken != null) {
              final userInfor =
                  authRepository.convertDynamicToObject(checkInfoToken.data[0]);
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
              },
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              urlAPI: authRepository.loginByGoogleURL,
            );
            if (ValidateUtilities.checkBaseResponse(
                baseResponse: loginResponse)) {
              final userInfor = authRepository.convertDynamicToObject(
                loginResponse!.data[0],
              );
              final pref = await sharedPref;
              await pref.setString("token", userInfor.accessToken!.token ?? "");
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
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(
          AuthStateLoggedOut(
            isLoading: true,
          ),
        );
        try {
          await googleSignInExtension.logout();
          emit(
            AuthStateLoggedOut(isLoading: false),
          );
        } catch (e) {
          log(e.toString());
        }
      },
    );
  }
}
