import 'package:samurai_studios/features/episodes/domain/entities/episode.dart';

sealed class EpisodeListState {
  const EpisodeListState();

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(List<Episode> episodes, int currentPage, bool hasNextPage, bool isLoadingMore) loaded,
    required R Function(String message) error,
  }) {
    if (this is Initial) {
      return initial();
    } else if (this is Loading) {
      return loading();
    } else if (this is Loaded) {
      final state = this as Loaded;
      return loaded(state.episodes, state.currentPage, state.hasNextPage, state.isLoadingMore);
    } else if (this is Error) {
      return error((this as Error).message);
    }
    throw Exception('Unknown state');
  }
}

class Initial extends EpisodeListState {
  const Initial();
}

class Loading extends EpisodeListState {
  const Loading();
}

class Loaded extends EpisodeListState {
  final List<Episode> episodes;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;

  const Loaded({
    required this.episodes,
    required this.currentPage,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  Loaded copyWith({
    List<Episode>? episodes,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return Loaded(
      episodes: episodes ?? this.episodes,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class Error extends EpisodeListState {
  final String message;

  const Error(this.message);
}
