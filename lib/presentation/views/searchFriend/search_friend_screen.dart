import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';

import '../../services/bloc/chatBloc/chat_event.dart';

class SearchFriendScreen extends StatelessWidget {
  const SearchFriendScreen({super.key, required this.userInformation});
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackButton(
            onPressed: () {
              BlocProvider.of<ChatBloc>(context).add(
                BackToWaitingChatEvent(
                  userInformation: userInformation,
                ),
              );
            },
          ),
          textWidget(text: "search"),
        ],
      ),
    );
  }
}
