import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';
import '../../../services/bloc/chatBloc/chat_bloc.dart';
import '../../widgets/offline_icon_widget.dart';
import '../../widgets/online_icon_widget.dart';

class ItemChatScreen extends StatefulWidget {
  const ItemChatScreen({super.key, required this.chat});
  final ChatUserAndPresence chat;

  @override
  State<ItemChatScreen> createState() => _ItemChatScreenState();
}

class _ItemChatScreenState extends State<ItemChatScreen> {
  late String timeMessage;
  late String presence;
  String _handleMessageChat(BuildContext context, ChatBloc chatBloc) {
    if (widget.chat.chat!.userIDLastMessage != "") {
      if (widget.chat.chat!.userIDLastMessage ==
          chatBloc.userInformation.user!.sId) {
        return "${context.loc.you}: ";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  void startTimer(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        timeMessage = differenceInCalendarDaysLocalization(
            DateTime.parse(widget.chat.chat!.timeLastMessage!), context);
        presence = differenceInCalendarPresence(
          DateTime.parse(
            widget.chat.presence?.presenceTimeStamp ?? "",
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    timeMessage = differenceInCalendarDaysLocalization(
        DateTime.parse(widget.chat.chat!.timeLastMessage!), context);
    presence = differenceInCalendarPresence(
      DateTime.parse(
        widget.chat.presence?.presenceTimeStamp ?? "",
      ),
    );
    startTimer(context);
    final chatBloc = context.read<ChatBloc>();
    final handleMessage = _handleMessageChat(context, chatBloc);
    return InkWell(
      onTap: () {
        chatBloc.add(
          JoinChatEvent(
            chatUserAndPresence: widget.chat,
          ),
        );
      },
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            circleImageWidget(
              urlImage: widget.chat.user!.urlImage!.isEmpty
                  ? "https://i.stack.imgur.com/l60Hf.png"
                  : widget.chat.user!.urlImage!,
              radius: 20.w,
            ),
            if (widget.chat.presence!.presence!) onlineIcon(),
            if (!widget.chat.presence!.presence!)
              offlineIcon(
                text: presence,
              ),
          ],
        ),
        title: textWidget(
          text: widget.chat.user?.name ?? "Unknown",
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: textWidget(
                maxLines: 1,
                text: handleMessage + (widget.chat.chat?.lastMessage ?? ""),
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16.w),
            textWidget(text: timeMessage),
          ],
        ),
      ),
    );
  }
}
