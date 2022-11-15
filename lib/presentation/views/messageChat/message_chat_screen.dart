import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';
import 'package:testsocketchatapp/data/repositories/chat_message_repository.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/body_message_chat.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';

import '../../../data/models/chat.dart';
import '../../../data/models/user.dart';
import '../../services/provider/config_app_provider.dart';
import '../widgets/online_icon_widget.dart';

class MessageChatScreen extends StatefulWidget {
  const MessageChatScreen({
    Key? key,
    required this.socket,
    required this.chatUserAndPresence,
    required this.userInformation,
  }) : super(key: key);
  final Socket socket;
  final UserInformation userInformation;
  final ChatUserAndPresence chatUserAndPresence;

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  late String presence;
  void startTimer(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        presence = differenceInCalendarDaysLocalization(
          DateTime.parse(
            widget.chatUserAndPresence.presence!.presenceTimeStamp!,
          ),
          context,
        );
      });
    });
  }

  @override
  void initState() {
    startTimer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigAppProvider>(context);
    // startTimer(context);
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(
          MessageManager(
            socket: widget.socket,
            userPresence: widget.chatUserAndPresence.presence!,
            chatID: widget.chatUserAndPresence.chat!.sId!,
            chatMessageRepository: ChatMessageRepository(
              baseUrl: configProvider.env.apiURL,
            ),
            chat: widget.chatUserAndPresence.chat!,
            ownerUserID: widget.userInformation.user!.sId!,
          ),
          widget.userInformation,
          widget.chatUserAndPresence)
        ..add(
          InitializingMessageEvent(
            chatUserAndPresence: widget.chatUserAndPresence,
          ),
        ),
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state is LeavedChatMessageState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppbar(
                context,
                state.userPresence,
                widget.chatUserAndPresence.chat!,
                widget.chatUserAndPresence.user!,
                state.userInformation),
            body: BodyMessageChat(
              messages: state.$messages,
              chatUserAndPresence: widget.chatUserAndPresence,
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppbar(BuildContext context, Stream<UserPresence> userPresence,
      Chat chat, User user, UserInformation userInformation) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          context.read<MessageBloc>().add(
                LeaveChatMessageEvent(
                  chatID: chat.sId!,
                  userID: userInformation.user!.sId.toString(),
                ),
              );
        },
      ),
      title: Observer(
        stream: userPresence,
        onSuccess: (context, data) {
          final userPresence = data;
          return Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  circleImageWidget(
                    urlImage: user.urlImage!.isNotEmpty
                        ? user.urlImage!
                        : "https://i.stack.imgur.com/l60Hf.png",
                    radius: 20.w,
                  ),
                  if (userPresence?.presence == true) onlineIcon(),
                ],
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: user.name ?? "Unknown",
                    size: 16.sp,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${context.loc.online} ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        if (userPresence?.presence == false)
                          TextSpan(
                            text: presence,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
