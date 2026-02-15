import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/episodes/domain/entities/episode_entity.dart';

abstract class EpisodeRepository {
  Future<ApiResult<EpisodePaginatedResult>> getEpisodes({int page = 1});
}

class EpisodePaginatedResult {
  final List<EpisodeEntity> episodes;
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
