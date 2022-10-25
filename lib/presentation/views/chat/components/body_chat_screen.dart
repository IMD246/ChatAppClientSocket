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
        children: [
          SizedBox(
            height: 8.h,
          ),
          searchWidget(context),
        ],
      ),
    );
  }

  Center searchWidget(
    BuildContext context,
  ) {
    return Center(
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(GoToSearchFriendChatEvent(userInformation: userInformation,),);
        },
        borderRadius: BorderRadius.circular(20.w),
        child: Container(
          width: 300.w,
          height: 30.h,
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
                color: Colors.black54,
              ),
              textWidget(
                text: "Tìm kiếm",
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
