import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/episodes/data/repositories/episode_repository_impl.dart';
import 'package:samurai_studios/features/episodes/presentation/state/episode_list_state.dart';

class EpisodeListNotifier extends StateNotifier<EpisodeListState> {
  final Ref ref;

  EpisodeListNotifier(this.ref) : super(const Loading()) {
    _loadEpisodes();
  }

  Future<void> _loadEpisodes({int page = 1}) async {
    try {
      final repository = ref.read(episodeRepositoryProvider);
      final result = await repository.getEpisodes(page: page);

      result.when(
        success: (paginatedResult) {
          state = Loaded(
            episodes: paginatedResult.episodes,
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
      final repository = ref.read(episodeRepositoryProvider);
      final result = await repository.getEpisodes(page: nextPage);

      result.when(
        success: (paginatedResult) {
          state = Loaded(
            episodes: [
              ...currentState.episodes,
              ...paginatedResult.episodes,
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
    await _loadEpisodes(page: 1);
  }
}

final episodeListNotifierProvider =
    StateNotifierProvider<EpisodeListNotifier, EpisodeListState>((ref) {
  return EpisodeListNotifier(ref);
});
