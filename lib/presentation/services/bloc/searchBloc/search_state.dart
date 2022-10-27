import 'package:testsocketchatapp/data/models/friend.dart';

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
