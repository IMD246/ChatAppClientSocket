import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';
import 'package:testsocketchatapp/presentation/views/chat/components/body_chat_screen.dart';
import 'package:testsocketchatapp/presentation/views/searchFriend/search_friend_screen.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/setting_screen.dart';
import 'package:testsocketchatapp/presentation/views/widgets/animated_switcher_widget.dart';

import '../../services/provider/config_app_provider.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configAppProvider = Provider.of<ConfigAppProvider>(context);
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        chatManager: ChatManager(
          socket: io.io(
            configAppProvider.env.baseURL,
            <String, dynamic>{
              "transports": ["websocket"],
            },
          ),
        ),
        userInformation: widget.userInformation,
        userRepository: UserRepository(
          baseUrl: configAppProvider.env.apiURL,
        ),
      )..add(
          InitializeChatEvent(
            userInformation: widget.userInformation,
          ),
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
    if (state is BackToWaitingChatState) {
      return BodyChatScreen(
        userInformation: state.userInformation,
        $chats: state.listChatController,
      );
    } else if (state is WentToSettingMenuChatState) {
      return SettingScreen(
        userInformation: state.userInformation,
      );
    } else if (state is WentToSearchChatState) {
      return SearchFriendScreen(
        userInformation: state.userInformation,
      );
    } else {
      return Scaffold(
        body: textWidget(text: "Chưa có màn hình"),
      );
    }
  }
}
