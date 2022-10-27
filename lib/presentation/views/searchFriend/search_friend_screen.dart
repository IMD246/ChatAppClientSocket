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
import 'package:testsocketchatapp/presentation/views/searchFriend/recommded_list_friend.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';
import '../../../data/models/friend.dart';
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: TextFieldWidget(
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          context.read<SearchBloc>().add(
                                TypingSearchEvent(
                                  keyWord: value,
                                ),
                              );
                        },
                        onDeleted: () {
                          context.read<SearchBloc>().add(
                                TypingSearchEvent(
                                  keyWord: null,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                dividerWidget(thickness: 4),
                Visibility(
                  visible: state is RecommendedResultSearchState,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: textWidget(text: "Recommded"),
                  ),
                ),
                if (state is RecommendedResultSearchState)
                  RecommmendedListFriend(listFriend: state.listFriend)
                else if (state is ResultMatchKeywordSearchState)
                  Observer<List<Friend>>(
                    onError: null,
                    onSuccess: (context, data) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data?.length ?? -1,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final friend = data!.elementAt(index);
                            return FriendItem(
                              friend: friend,
                              press: () {},
                            );
                        },
                      );
                    },
                    stream: state.$friends,
                    onLoading: null,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
