import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:samurai_studios/features/episodes/domain/repositories/episode_repository.dart';

import '../../../../core/network/dio_error.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;

  EpisodeRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<EpisodePaginatedResult>> getEpisodes({
    int page = 1,
  }) async {
    try {
      final responseDto = await remoteDataSource.getEpisodes(page: page);

      // Convert DTOs to domain entities
      final episodes =
          responseDto.results.map((dto) => dto.toDomain()).toList();

      final result = EpisodePaginatedResult(
        episodes: episodes,
        currentPage: page,
        totalPages: responseDto.info.pages,
        hasNextPage: responseDto.info.next != null,
      );

      return Success(result);
    } on DioException catch (e) {
      return Failure(handleDioError(e), e);
    } catch (e) {
      return Failure('An unexpected error occurred', Exception(e.toString()));
    }
  }
}

final episodeRepositoryProvider = Provider<EpisodeRepository>((ref) {
  final remoteDataSource = ref.watch(episodeRemoteDataSourceProvider);
  return EpisodeRepositoryImpl(remoteDataSource);
});
