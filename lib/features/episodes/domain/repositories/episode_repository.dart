import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/episodes/domain/entities/episode.dart';

abstract class EpisodeRepository {
  Future<ApiResult<EpisodePaginatedResult>> getEpisodes({int page = 1});
}

class EpisodePaginatedResult {
  final List<Episode> episodes;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  EpisodePaginatedResult({
    required this.episodes,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}
