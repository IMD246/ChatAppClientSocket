import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/searchBloc/search_state.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

import '../../../../data/repositories/friend_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FriendRepository friendRepository;
  final UserRepository userRepository;
  final UserInformation userInformation;
  late List<Friend> listFriendRecommended;
  final SearchManager searchManager;
  SearchBloc({
    required this.searchManager,
    required this.friendRepository,
    required this.userInformation,
    required this.userRepository,
  }) : super(
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
    on<CreateAndJoinChatSearchEvent>((event, emit) async {
      final response = await userRepository.getData(
          body: {
            "listUser": [userInformation.user!.sId, event.friend.user!.sId!],
            "userIDFriend": event.friend.user!.sId!
          },
          urlAPI: userRepository.joinChatURL,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      if (ValidateUtilities.checkBaseResponse(baseResponse: response)) {
        final chatUser =
            userRepository.convertDynamicToObject(response!.data[0]);
        searchManager.emitJoinChat(chatUser.chat?.sId ?? "");
        emit(JoinedChatSuccessSearchState(
          chatUserAndPresence: chatUser,
          userInformation: userInformation,
          socket: searchManager.socket,
        ));
      }
    });
  }
}
