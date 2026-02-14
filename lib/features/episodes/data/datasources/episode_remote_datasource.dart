import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/constants/api_constants.dart';
import 'package:samurai_studios/core/providers/dio_provider.dart';
import 'package:samurai_studios/features/episodes/data/models/episode_response_dto.dart';

abstract class EpisodeRemoteDataSource {
  Future<EpisodeResponseDto> getEpisodes({int page = 1});
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSourceImpl(this.dio);

  @override
  Future<EpisodeResponseDto> getEpisodes({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.episodeEndpoint,
      queryParameters: {'page': page},
    );
    return EpisodeResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}

final episodeRemoteDataSourceProvider = Provider<EpisodeRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return EpisodeRemoteDataSourceImpl(dio);
});
