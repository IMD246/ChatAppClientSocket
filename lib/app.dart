import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_basic_utilities/helper/loading/loading_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_state.dart';
import 'package:testsocketchatapp/presentation/views/chat/components/chat_screen.dart';
import 'package:testsocketchatapp/presentation/views/welcome/login_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.textLoading);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedOut || state is AuthStateLoading) {
          return const Scaffold(
            body: LoginScreen(),
          );
        } else if (state is AuthStateLoggedIn) {
          return const ChatScreen();
        } else {
          return Scaffold(
            body: textWidget(
              text: "Something went wrong",
            ),
          );
        }
      },
    );
  }
}
