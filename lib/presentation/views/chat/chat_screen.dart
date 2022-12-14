import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../data/models/user_info.dart';
import '../../../data/repositories/user_repository.dart';
import '../../services/bloc/chatBloc/chat_bloc.dart';
import '../../services/bloc/chatBloc/chat_event.dart';
import '../../services/bloc/chatBloc/chat_manager.dart';
import '../../services/bloc/chatBloc/chat_state.dart';
import '../../services/provider/config_app_provider.dart';
import '../messageChat/message_chat_screen.dart';
import '../searchFriend/search_friend_screen.dart';
import '../setting/components/setting_screen.dart';
import '../widgets/animated_switcher_widget.dart';
import 'components/body_chat_screen.dart';

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
  int count = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configAppProvider = Provider.of<ConfigAppProvider>(context);
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        noti: configAppProvider.noti,
        chatManager: ChatManager(
          socket: io.io(
            configAppProvider.env.baseURL,
            <String, dynamic>{
              "transports": ["websocket"],
            },
          ),
          userInformation: widget.userInformation,
          userRepository: UserRepository(
            baseUrl: configAppProvider.env.apiURL,
          ),
        ),
      )..add(
          InitializeChatEvent(
            userInformation: widget.userInformation,
          ),
        ),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is InitializeChatState) {
            configAppProvider.handlerNotification(
              context: context,
              listChatUser: state.chatManager.listChat,
              socket: state.chatManager.socket,
              userInformation: state.chatManager.userInformation,
            );
          }
          _listeningState(context: context, state: state);
        },
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
        userInformation: state.chatManager.userInformation,
        $chats: state.listChatController,
      );
    } else if (state is InitializeChatState) {
      return BodyChatScreen(
        userInformation: state.chatManager.userInformation,
        $chats: state.listChatController,
      );
    } else {
      return const Scaffold();
    }
  }

  void _listeningState(
      {required BuildContext context, required ChatState state}) {
    // #region listenState methods
    if (state is JoinedChatState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MessageChatScreen(
              chatUserAndPresence: state.chatUserAndPresence,
              userInformation: state.chatManager.userInformation,
              socket: state.chatManager.socket,
            );
          },
          settings: RouteSettings(
              name: "chat:${state.chatUserAndPresence.chat?.sId ?? ""}"),
        ),
      ).then((value) {
        context.read<ChatBloc>().add(
              BackToWaitingChatEvent(
                userInformation: state.chatManager.userInformation,
              ),
            );
      });
    } else if (state is WentToSearchChatState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SearchFriendScreen(
              userRepository: state.userRepository,
              userInformation: state.chatManager.userInformation,
              socket: state.chatManager.socket,
            );
          },
        ),
      ).then((value) {
        context.read<ChatBloc>().add(
              BackToWaitingChatEvent(
                userInformation: state.chatManager.userInformation,
              ),
            );
      });
    } else if (state is WentToSettingMenuChatState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SettingScreen(
              userInformation: state.chatManager.userInformation,
              socket: state.chatManager.socket,
            );
          },
        ),
      ).then((value) {
        context.read<ChatBloc>().add(
              BackToWaitingChatEvent(
                userInformation: state.chatManager.userInformation,
              ),
            );
      });
    }
    // #endregion
  }
}
