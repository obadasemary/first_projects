import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/characters/data/repositories/character_repository_impl.dart';
import 'package:samurai_studios/features/characters/presentation/state/character_list_state.dart';

class CharacterListNotifier extends StateNotifier<CharacterListState> {
  final Ref ref;

  CharacterListNotifier(this.ref) : super(const Loading()) {
    _loadCharacters();
  }

  Future<void> _loadCharacters({int page = 1}) async {
    try {
      final repository = ref.read(characterRepositoryProvider);
      final result = await repository.getCharacters(page: page);

      result.when(
        success: (paginatedResult) {
          state = Loaded(
            characters: paginatedResult.characters,
            currentPage: paginatedResult.currentPage,
            hasNextPage: paginatedResult.hasNextPage,
          );
        },
        failure: (message, _) {
          state = Error(message);
        },
      );
    } catch (e) {
      state = const Error('An unexpected error occurred');
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! Loaded) return;
    if (!currentState.hasNextPage) return;
    if (currentState.isLoadingMore) return;

    // Set loading more flag
    state = currentState.copyWith(isLoadingMore: true);

    try {
      final nextPage = currentState.currentPage + 1;
      final repository = ref.read(characterRepositoryProvider);
      final result = await repository.getCharacters(page: nextPage);

      result.when(
        success: (paginatedResult) {
          state = Loaded(
            characters: [
              ...currentState.characters,
              ...paginatedResult.characters,
            ],
            currentPage: paginatedResult.currentPage,
            hasNextPage: paginatedResult.hasNextPage,
            isLoadingMore: false,
          );
        },
        failure: (message, _) {
          // Keep current state but stop loading
          state = currentState.copyWith(isLoadingMore: false);
        },
      );
    } catch (e) {
      state = currentState.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() async {
    state = const Loading();
    await _loadCharacters(page: 1);
  }
}

final characterListNotifierProvider =
    StateNotifierProvider<CharacterListNotifier, CharacterListState>((ref) {
  return CharacterListNotifier(ref);
});
