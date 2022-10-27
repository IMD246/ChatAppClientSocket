import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/app.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/data/repositories/auth_repository.dart';
import 'package:testsocketchatapp/presentation/extensions/google_sign_in_extension.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigAppProvider>(
      create: (context) => ConfigAppProvider(
        env: Environment(
          isProduct: false,
        ),
      ),
      child: Consumer<ConfigAppProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(Platform.localeName),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            home: ScreenUtilInit(
              splitScreenMode: true,
              minTextAdapt: true,
              builder: (context, child) {
                return BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(
                    googleSignInExtension: GoogleSignInExtension(),
                    sharedPref: SharedPreferences.getInstance(),
                    authRepository: AuthRepository(
                      baseUrl: value.env.apiURL,
                    ),
                  )..add(
                      AuthEventLoginWithToken(),
                    ),
                  child: const App(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
