import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/friend_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_state.dart';

import '../../services/bloc/chatBloc/chat_event.dart';
import '../../services/provider/config_app_provider.dart';
import 'friend_item.dart';

class SearchFriendScreen extends StatelessWidget {
  const SearchFriendScreen({super.key, required this.userInformation});
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final configApp = Provider.of<ConfigAppProvider>(context);
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        friendRepository: FriendRepository(
          baseUrl: configApp.env.apiURL,
        ),
      )..add(
          InitializeSearchEvent(
            keyWord: "",
          ),
        ),
      child: Scaffold(
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            log(state.listFriend.length.toString());
            return Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        chatBloc.add(
                          BackToWaitingChatEvent(
                            userInformation: userInformation,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 100.w,
                      child: TextFieldWidget(
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                        onDeleted: () {},
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.listFriend.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final friend = state.listFriend.elementAt(index);
                    return FriendItem(friend: friend);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
