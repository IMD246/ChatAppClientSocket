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
              },
              urlAPI: authRepository.loginByGoogleURL,
            );
            if (ValidateUtilities.checkBaseResponse(
                baseResponse: loginResponse)) {
              emit(
                AuthStateLoggedIn(
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
            // if (loginResponse == null) {
            //   final registerResponse = await authRepository.getData(
            //     body: {
            //       "email": googleSignInAcc.email,
            //       "name": googleSignInAcc.displayName,
            //       "urlImage": googleSignInAcc.photoUrl,
            //     },
            //     headers: {
            //       'Content-Type': 'application/json',
            //     },
            //     urlAPI: authRepository.registerURL,
            //   );
            //   if (registerResponse != null) {
            //     emit(
            //       AuthStateLoggedIn(
            //         isLoading: false,
            //       ),
            //     );
            //   } else {
            //     emit(
            //       AuthStateLoggedOut(
            //         isLoading: false,
            //       ),
            //     );
            //   }
            // }
            // // if (ValidateUtilities.checkBaseResponse(
            //     baseResponse: loginResponse)) {
            //   final registerResponse = await authRepository.getData(
            //     body: {
            //       "email": googleSignInAcc.email,
            //       "name": googleSignInAcc.displayName,
            //       "urlImage": googleSignInAcc.photoUrl,
            //     },
            //     headers: {
            //       'Content-Type': 'application/json',
            //     },
            //     urlAPI: authRepository.registerURL,
            //   );
            //   if (ValidateUtilities.checkBaseResponse(
            //       baseResponse: registerResponse)) {
            //     final loginResponse = await authRepository.getData(
            //       body: {
            //         "email": googleSignInAcc.email,
            //       },
            //       headers: {
            //         'Content-Type': 'application/json',
            //       },
            //       urlAPI: authRepository.loginURL,
            //     );
            //     if (ValidateUtilities.checkBaseResponse(
            //         baseResponse: loginResponse)) {
            //       emit(AuthStateLoggedIn(isLoading: false));
            //     } else {
            //       emit(AuthStateLoggedOut(isLoading: false));
            //     }
            //   } else {
            //     emit(AuthStateLoggedOut(isLoading: false));
            //   }
            // } else {
            //   emit(AuthStateLoggedOut(isLoading: false));
            // }
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
