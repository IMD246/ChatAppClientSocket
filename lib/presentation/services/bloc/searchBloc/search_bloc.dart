import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_state.dart';

import '../../../../data/repositories/friend_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FriendRepository friendRepository;
  late StreamController<List<Friend>> friendsController;
  late Stream<List<Friend>> $friends;
  SearchBloc({required this.friendRepository})
      : super(
          RecommendedResultSearchState(
            listFriend: [],
          ),
        ) {
    on<InitializeSearchEvent>((event, emit) async {
      final friendResponse = await friendRepository.getData(
        body: {"keyword": event.keyWord},
        urlAPI: friendRepository.getFriendKeywordURL,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      log("check length${friendResponse.length}");
      emit(
        RecommendedResultSearchState(
          listFriend: friendResponse,
        ),
      );
    });
    on<TypingSearchEvent>((event, emit) {});
  }
}
