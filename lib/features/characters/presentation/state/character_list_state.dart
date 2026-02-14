import 'package:samurai_studios/features/characters/domain/entities/character.dart';

sealed class CharacterListState {
  const CharacterListState();

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(List<Character> characters, int currentPage, bool hasNextPage, bool isLoadingMore) loaded,
    required R Function(String message) error,
  }) {
    if (this is Initial) {
      return initial();
    } else if (this is Loading) {
      return loading();
    } else if (this is Loaded) {
      final state = this as Loaded;
      return loaded(state.characters, state.currentPage, state.hasNextPage, state.isLoadingMore);
    } else if (this is Error) {
      return error((this as Error).message);
    }
    throw Exception('Unknown state');
  }
}

class Initial extends CharacterListState {
  const Initial();
}

class Loading extends CharacterListState {
  const Loading();
}

class Loaded extends CharacterListState {
  final List<Character> characters;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;

  const Loaded({
    required this.characters,
    required this.currentPage,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  Loaded copyWith({
    List<Character>? characters,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return Loaded(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class Error extends CharacterListState {
  final String message;

  const Error(this.message);
}
