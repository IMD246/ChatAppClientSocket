import 'package:socket_io_client/socket_io_client.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class SearchState {
  SearchState();
}

class RecommendedResultSearchState extends SearchState {
  final List<Friend> listFriend;
  RecommendedResultSearchState({required this.listFriend});
}

class ResultMatchKeywordSearchState extends SearchState {
  final Stream<List<Friend>> $friends;
  ResultMatchKeywordSearchState({required this.$friends});
}

class JoinedChatSuccessSearchState extends SearchState {
  final ChatUserAndPresence chatUserAndPresence;
  final UserInformation userInformation;
  final Socket socket;
  JoinedChatSuccessSearchState({
    required this.chatUserAndPresence,
    required this.userInformation,
    required this.socket,
  });
}
