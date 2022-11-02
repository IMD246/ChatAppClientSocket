// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/friend.dart';

abstract class SearchEvent {
  SearchEvent();
}

class InitializeSearchEvent extends SearchEvent {
  final String? keyWord;
  InitializeSearchEvent({required this.keyWord});
}

class TypingSearchEvent extends SearchEvent {
  final String? keyWord;
  TypingSearchEvent({required this.keyWord});
}

class CreateAndJoinChatSearchEvent extends SearchEvent {
  final Friend friend;
  CreateAndJoinChatSearchEvent({
    required this.friend,
  });
}
