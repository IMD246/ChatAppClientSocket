import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/friend_repository.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_state.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/message_chat_screen.dart';
import 'package:testsocketchatapp/presentation/views/searchFriend/recommded_list_friend.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';
import '../../../data/models/friend.dart';
import '../../services/bloc/chatBloc/chat_event.dart';
import '../../services/provider/config_app_provider.dart';
import 'friend_item.dart';

class SearchFriendScreen extends StatelessWidget {
  const SearchFriendScreen(
      {super.key,
      required this.userInformation,
      required this.userRepository,
      required this.socket});
  final UserInformation userInformation;
  final UserRepository userRepository;
  final io.Socket socket;
  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final configApp = Provider.of<ConfigAppProvider>(context);
    final TextEditingController searchText = TextEditingController();
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        friendRepository: FriendRepository(
          baseUrl: configApp.env.apiURL,
        ),
        userInformation: userInformation,
        userRepository: userRepository,
        searchManager: SearchManager(socket: socket),
      )..add(
          InitializeSearchEvent(
            keyWord: "",
          ),
        ),
      child: Scaffold(
        body: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is JoinedChatSuccessSearchState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MessageChatScreen(
                      socket: state.socket,
                      chatUserAndPresence: state.chatUserAndPresence,
                      userInformation: state.userInformation,
                    );
                  },
                ),
              ).then((value) {
                context.read<SearchBloc>().add(
                      TypingSearchEvent(
                        keyWord: searchText.text,
                      ),
                    );
              });
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32.h,
                ),
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
                        textField: searchText.text,
                        controller: searchText,
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
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
