import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';

import '../../../../data/models/user_info.dart';
import '../../../services/bloc/chatBloc/chat_bloc.dart';
import '../../widgets/offline_icon_widget.dart';
import '../../widgets/online_icon_widget.dart';

class ItemChatScreen extends StatelessWidget {
  const ItemChatScreen({super.key, required this.chat});
  final ChatUserAndPresence chat;
  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    return InkWell(
      onTap: () {
        chatBloc.add(
              JoinChatEvent(
                chatUserAndPresence: chat,
              ),
            );
      },
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            circleImageWidget(
              urlImage: chat.user!.urlImage!.isEmpty
                  ? "https://i.stack.imgur.com/l60Hf.png"
                  : chat.user!.urlImage!,
              radius: 20.w,
            ),
            if (chat.presence!.presence!) onlineIcon(),
            if (!chat.presence!.presence!)
              offlineIcon(
                text: differenceInCalendarPresence(
                  DateTime.parse(
                    chat.presence?.presenceTimeStamp ?? "",
                  ),
                ),
              ),
          ],
        ),
        title: textWidget(
          text: chat.user?.name ?? "Unknown",
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: textWidget(
                maxLines: 1,
                text: chat.chat?.lastMessage ?? "",
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16.w),
            textWidget(
              text: differenceInCalendarDaysLocalization(
                DateTime.parse(chat.chat!.timeLastMessage!),
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
