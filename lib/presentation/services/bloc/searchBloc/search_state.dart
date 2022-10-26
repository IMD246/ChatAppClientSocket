import 'package:testsocketchatapp/data/models/friend.dart';

abstract class SearchState {
  List<Friend> listFriend;
  SearchState({
    required this.listFriend,
  });
}

class RecommendedResultSearchState extends SearchState {
  RecommendedResultSearchState({required super.listFriend});
}

class ResultMatchKeywordSearchState extends SearchState {
  ResultMatchKeywordSearchState({required super.listFriend});
}
