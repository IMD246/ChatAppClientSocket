import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/body_message_chat.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';

import '../widgets/online_icon_widget.dart';

class MessageChatScreen extends StatelessWidget {
  const MessageChatScreen({
    Key? key,
    required this.chatManager,
    required this.chatUserAndPresence,
  }) : super(key: key);
  final ChatManager chatManager;
  final ChatUserAndPresence chatUserAndPresence;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(
        MessageManager(
          socket: chatManager.socket,
        ),
      )..add(
          InitializingMessageEvent(
            chatUserAndPresence: chatUserAndPresence,
          ),
        ),
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state is LeavedChatMessageState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Observer<ChatUserAndPresence>(
            onSuccess: (context, data) {
              final chat = data!;
              return Scaffold(
                appBar: buildAppbar(context, chat),
                body: BodyMessageChat(
                  messages: chat.chat!.messages!,
                ),
              );
            },
            stream: state.$chatUserAndPresence,
          );
        },
      ),
    );
  }

  AppBar buildAppbar(BuildContext context, ChatUserAndPresence chat) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          context.read<MessageBloc>().add(
                LeaveChatMessageEvent(
                  chatID: chat.chat!.sId!,
                  userID: chat.user!.sId!,
                ),
              );
        },
      ),
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              circleImageWidget(
                urlImage: chat.user!.urlImage!.isNotEmpty
                    ? chat.user!.urlImage!
                    : "https://i.stack.imgur.com/l60Hf.png",
                radius: 20.w,
              ),
              if (chat.presence!.presence == true) onlineIcon(),
            ],
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: chat.user?.name ?? "Unknown",
                size: 16.sp,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Online ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                    if (chat.presence?.presence == false)
                      TextSpan(
                        text: differenceInCalendarDaysLocalization(
                          DateTime.parse(
                            chat.presence!.presenceTimeStamp!,
                          ),
                          context,
                        ),
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
      ),
    );
  }
}
