import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';
import 'package:testsocketchatapp/presentation/views/chat/components/body_chat_screen.dart';
import 'package:testsocketchatapp/presentation/views/searchFriend/search_friend_screen.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/setting_screen.dart';
import 'package:testsocketchatapp/presentation/views/widgets/animated_switcher_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.userInformation,
  }) : super(key: key);
  final UserInformation userInformation;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late io.Socket socket;
  @override
  void initState() {
    socket = io.io(
      "http://192.168.180.1:5000",
      <String, dynamic>{
        "transports": ["websocket"],
      },
    );
    socket.onConnect(
      (data) {
        log("Connection established");
      },
    );

    // Connect error
    socket.onConnectError(
      (data) {
        log("connection failed + $data");
      },
    );

    // disconnect
    socket.onDisconnect(
      (data) {
        log("socketio Server disconnected");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        chatManager: ChatManager(
          socket: socket,
        ),
        userInformation: widget.userInformation,
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return AnimatedSwitcherWidget(
            widget: dynamicScreen(state),
          );
        },
      ),
    );
  }

  Widget dynamicScreen(ChatState state) {
    if (state is LeavedChatState) {
      return BodyChatScreen(userInformation: state.userInformation);
    } else if (state is InsideSettingChatState) {
      return SettingScreen(
        userInformation: state.userInformation,
      );
    } else if (state is InsideSearchChatState) {
      return SearchFriendScreen(userInformation: state.userInformation,);
    } else {
      return Scaffold(
        body: textWidget(text: "Chưa có màn hình"),
      );
    }
  }
}
