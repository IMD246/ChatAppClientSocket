import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/presentation/extensions/google_sign_in_extension.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/language_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/theme_provider.dart';
import 'package:testsocketchatapp/presentation/theme/theme_data.dart';
import 'app.dart';
import 'data/repositories/auth_repository.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({
    Key? key,
  }) : super(key: key);
  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<ConfigAppProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        googleSignInExtension: GoogleSignInExtension(),
        sharedPref: SharedPreferences.getInstance(),
        authRepository: AuthRepository(
          baseUrl: value.env.apiURL,
        ),
      )..add(AuthEventLoginWithToken()),
      child: MaterialApp(
        navigatorKey: value.navigatorKey,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: languageProvider.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        themeMode: themeProvider.themeMode,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        home: const App(),
      ),
    );
  }
}
