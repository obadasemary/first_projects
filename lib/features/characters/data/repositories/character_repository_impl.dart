import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:samurai_studios/features/characters/domain/repositories/character_repository.dart';

import '../../../../core/network/dio_error.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<CharacterPaginatedResult>> getCharacters({
    int page = 1,
  }) async {
    try {
      final responseDto = await remoteDataSource.getCharacters(page: page);

      // Convert DTOs to domain entities
      final characters =
          responseDto.results.map((dto) => dto.toDomain()).toList();

      final result = CharacterPaginatedResult(
        characters: characters,
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

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(characterRemoteDataSourceProvider);
  return CharacterRepositoryImpl(remoteDataSource);
});
