import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/provider/internet_provider.dart';
import 'package:testsocketchatapp/presentation/views/chat/components/list_chat.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';

import '../../../services/bloc/chatBloc/chat_bloc.dart';
import '../../../services/bloc/chatBloc/chat_event.dart';

class BodyChatScreen extends StatelessWidget {
  const BodyChatScreen(
      {super.key, required this.userInformation, required this.$chats});
  final UserInformation userInformation;
  final StreamController<List<ChatUserAndPresence>> $chats;
  @override
  Widget build(BuildContext context) {
    final internetProvider = Provider.of<InternetProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            context.read<ChatBloc>().add(
                  GoToMenuSettingEvent(
                    userInformation: userInformation,
                  ),
                );
          },
          child: circleImageWidget(
            urlImage: userInformation.user?.urlImage ??
                "https://i.stack.imgur.com/l60Hf.png",
            radius: 20.h,
          ),
        ),
        title: textWidget(
          text: context.loc.chat,
          size: 20.h,
        ),
        bottom: !internetProvider.isConnectedInternet
            ? PreferredSize(
                preferredSize: Size(
                  20.w,
                  20.h,
                ),
                child: Visibility(
                  visible: !internetProvider.isConnectedInternet,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0.h),
                    child: textWidget(
                      text: context.loc.waiting_internet,
                      size: 15.h,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            searchWidget(context),
            Observer(
              stream: $chats.stream,
              onSuccess: (context, data) {
                final listChat = data;
                if (listChat == null || listChat.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 280.0.h),
                    child: TextButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(
                              GoToSearchFriendChatEvent(
                                userInformation: userInformation,
                              ),
                            );
                      },
                      child: textWidget(
                        text: "Let find some chat",
                      ),
                    ),
                  );
                } else {
                  return ListChat(chats: listChat);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget(
    BuildContext context,
  ) {
    return Center(
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            GoToSearchFriendChatEvent(
              userInformation: userInformation,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20.w),
        child: Container(
          width: 360.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.w),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Icon(
                Icons.search,
              ),
              textWidget(
                text: context.loc.search,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
