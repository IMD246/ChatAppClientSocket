import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

import '../../../services/bloc/chatBloc/chat_bloc.dart';
import '../../../services/bloc/chatBloc/chat_event.dart';

class BodyChatScreen extends StatelessWidget {
  const BodyChatScreen({super.key, required this.userInformation});
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              context.read<ChatBloc>().add(
                    GoToSettingChatEvent(
                      userInformation: userInformation,
                    ),
                  );
            },
            child: circleImageWidget(
              urlImage: userInformation.user?.urlImage ??
                  "https://i.stack.imgur.com/l60Hf.png",
              radius: 14.h,
            ),
          ),
          title: textWidget(
            text: "Đoạn Chat",
            size: 20.h,
          ),
        ),
        body: Column(
          children: const [],
        ),);
  }
}
