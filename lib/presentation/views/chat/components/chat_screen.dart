import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/outline_button_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/bloc/authBloc/auth_bloc.dart';
import '../../../services/bloc/authBloc/auth_event.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          textWidget(
            text: "You logged successfully",
          ),
          FillOutlineButton(
            press: () {
              context.read<AuthBloc>().add(
                    AuthEventLogOut(),
                  );
            },
            text: "Logout",
          )
        ],
      ),
    );
  }
}