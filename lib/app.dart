import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_state.dart';
import 'package:testsocketchatapp/presentation/services/provider/language_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/theme_provider.dart';
import 'package:testsocketchatapp/presentation/views/chat/chat_screen.dart';
import 'package:testsocketchatapp/presentation/views/welcome/login_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = getDeviceSize(context: context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
      designSize: size,
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthStateLoggedIn) {
              languageProvider.setLocale(
                languageCode: state.userInformation.user?.languageCode,
                countryCode: state.userInformation.user?.countryCode,
              );
              themeProvider.setThemeData(
                  isDarkMode: state.userInformation.user?.isDarkMode);
            }
            if (state.isLoading) {
              ShowLoadingParallelScreen().showLoading(context: context);
            } else {
              ShowLoadingParallelScreen().hideLoading();
            }
          },
          builder: (context, state) {
            if (state is AuthStateLoggedOut || state is AuthStateLoading) {
              return const Scaffold(
                body: LoginScreen(),
              );
            } else if (state is AuthStateLoggedIn) {
              return ChatScreen(
                userInformation: state.userInformation,
              );
            } else {
              return Scaffold(
                body: textWidget(
                  text: "Something went wrong",
                ),
              );
            }
          },
        );
      },
    );
  }
}
