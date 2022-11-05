import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/bloc/messageBloc/message_bloc.dart';
import '../../widgets/online_icon_widget.dart';

class WelcomeChatMessage extends StatelessWidget {
  const WelcomeChatMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    messageBloc.messageManager.emitNewChat(
      chatUserAndPresence: messageBloc.chatUserAndPresence,
    );
    final size = getDeviceSize(context: context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              circleImageWidget(
                urlImage:
                    messageBloc.chatUserAndPresence.user!.urlImage!.isEmpty
                        ? "https://i.stack.imgur.com/l60Hf.png"
                        : messageBloc.chatUserAndPresence.user!.urlImage!,
                radius: 60.w,
              ),
              if (messageBloc.chatUserAndPresence.presence!.presence!)
                onlineIcon(
                  widget: 20.w,
                  height: 20.h,
                  right: 10.w,
                  bottom: 5.h,
                ),
            ],
          ),
          SizedBox(height: 10.h),
          textWidget(
            text: messageBloc.chatUserAndPresence.user?.name ?? "Unknown",
          ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.5),
            child: textWidget(
              text: "Các bạn hiện đã là bạn bè của nhau",
              textAlign: TextAlign.center,
              maxLines: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
