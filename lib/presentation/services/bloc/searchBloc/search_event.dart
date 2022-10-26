abstract class SearchEvent {
  final String? keyWord;
  SearchEvent({
    required this.keyWord,
  });
}

class InitializeSearchEvent extends SearchEvent {
  InitializeSearchEvent({required super.keyWord});
  
}

class TypingSearchEvent extends SearchEvent {
  TypingSearchEvent({required super.keyWord});
}
