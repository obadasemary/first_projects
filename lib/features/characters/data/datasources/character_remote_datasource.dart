import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/constants/api_constants.dart';
import 'package:samurai_studios/core/providers/dio_provider.dart';
import 'package:samurai_studios/features/characters/data/models/character_response_dto.dart';
import 'package:samurai_studios/features/characters/data/models/episode_dto.dart';

abstract class CharacterRemoteDataSource {
  Future<CharacterResponseDto> getCharacters({int page = 1});
  Future<List<EpisodeDto>> getEpisodes(List<String> episodeUrls);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl(this.dio);

  @override
  Future<CharacterResponseDto> getCharacters({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.charactersEndpoint,
      queryParameters: {'page': page},
    );
    return CharacterResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<EpisodeDto>> getEpisodes(List<String> episodeUrls) async {
    if (episodeUrls.isEmpty) {
      return [];
    }

    // Extract episode IDs from URLs
    // URLs look like: "https://rickandmortyapi.com/api/episode/1"
    final episodeIds = episodeUrls
        .map((url) => url.split('/').last)
        .where((id) => id.isNotEmpty)
        .toList();

    if (episodeIds.isEmpty) {
      return [];
    }

    // Fetch episodes by comma-separated IDs
    final response = await dio.get(
      '${ApiConstants.episodeEndpoint}/${episodeIds.join(',')}',
    );

    // API returns a single object if only one ID, or an array for multiple
    if (response.data is List) {
      return (response.data as List)
          .map((json) => EpisodeDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      return [EpisodeDto.fromJson(response.data as Map<String, dynamic>)];
    }
  }
}

final characterRemoteDataSourceProvider = Provider<CharacterRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CharacterRemoteDataSourceImpl(dio);
});
