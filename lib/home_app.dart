import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/presentation/extensions/google_sign_in_extension.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';

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
  late final RemoteMessage? remoteMessage;
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    remoteMessage = initialMessage;
    log(initialMessage?.notification?.title ?? "khong co du lieu 1");
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        remoteMessage = event;
        log(event.notification?.title ?? "khong co du lieu 2");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<ConfigAppProvider>(context);
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        googleSignInExtension: GoogleSignInExtension(),
        sharedPref: SharedPreferences.getInstance(),
        authRepository: AuthRepository(
          baseUrl: value.env.apiURL,
        ),
      )..add(AuthEventLoginWithToken()),
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(Platform.localeName),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        home: const App(),
      ),
    );
  }
}
