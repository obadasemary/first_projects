import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:samurai_studios/features/characters/domain/repositories/character_repository.dart';

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
      return Failure(_handleDioError(e), e);
    } catch (e) {
      return Failure('An unexpected error occurred', Exception(e.toString()));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server not responding. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}. Please try again later.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(characterRemoteDataSourceProvider);
  return CharacterRepositoryImpl(remoteDataSource);
});
