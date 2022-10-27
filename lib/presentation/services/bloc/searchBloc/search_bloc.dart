import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_state.dart';

import '../../../../data/repositories/friend_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FriendRepository friendRepository;
  late List<Friend> listFriendRecommended;
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
      listFriendRecommended = friendResponse;
      emit(
        RecommendedResultSearchState(
          listFriend: listFriendRecommended,
        ),
      );
    });
    on<TypingSearchEvent>(
      (event, emit) async {
        if (event.keyWord == null || event.keyWord!.isEmpty) {
          emit(
            RecommendedResultSearchState(
              listFriend: listFriendRecommended,
            ),
          );
        } else {
          final friendResponse = await friendRepository.getData(
            body: {"keyword": event.keyWord},
            urlAPI: friendRepository.getFriendKeywordURL,
            headers: {
              'Content-Type': 'application/json',
            },
          );
          StreamController<List<Friend>> listFriendStream =
              StreamController<List<Friend>>();
          listFriendStream.add(friendResponse);
          emit(
            ResultMatchKeywordSearchState(
              $friends: listFriendStream.stream,
            ),
          );
        }
      },
    );
  }
}
