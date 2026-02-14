import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/episodes/data/datasources/episode_remote_datasource.dart';
import 'package:samurai_studios/features/episodes/data/models/episode_dto.dart';
import 'package:samurai_studios/features/episodes/data/models/episode_response_dto.dart';
import 'package:samurai_studios/features/episodes/data/repositories/episode_repository_impl.dart';

import 'episode_repository_impl_test.mocks.dart';

@GenerateMocks([EpisodeRemoteDataSource])
void main() {
  late EpisodeRepositoryImpl repository;
  late MockEpisodeRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockEpisodeRemoteDataSource();
    repository = EpisodeRepositoryImpl(mockDataSource);
  });

  group('EpisodeRepositoryImpl', () {
    test('should return success with episodes when API call succeeds', () async {
      // Arrange
      final responseDto = EpisodeResponseDto(
        info: const InfoDto(
          count: 51,
          pages: 3,
          next: 'https://rickandmortyapi.com/api/episode?page=2',
          prev: null,
        ),
        results: const [
          EpisodeDto(
            id: 1,
            name: 'Pilot',
            airDate: 'December 2, 2013',
            episode: 'S01E01',
            characters: [],
            url: '',
            created: '',
          ),
        ],
      );

      when(mockDataSource.getEpisodes(page: 1))
          .thenAnswer((_) async => responseDto);

      // Act
      final result = await repository.getEpisodes(page: 1);

      // Assert
      expect(result, isA<Success>());
      result.when(
        success: (data) {
          expect(data.episodes.length, 1);
          expect(data.episodes.first.name, 'Pilot');
          expect(data.currentPage, 1);
          expect(data.totalPages, 3);
          expect(data.hasNextPage, true);
        },
        failure: (_, __) => fail('Should not be failure'),
      );

      verify(mockDataSource.getEpisodes(page: 1)).called(1);
    });

    test('should return failure when API call throws DioException', () async {
      // Arrange
      when(mockDataSource.getEpisodes(page: 1)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await repository.getEpisodes(page: 1);

      // Assert
      expect(result, isA<Failure>());
      result.when(
        success: (_) => fail('Should not be success'),
        failure: (message, exception) {
          expect(message, contains('Connection timeout'));
        },
      );
    });

    test('should handle no next page correctly', () async {
      // Arrange
      final responseDto = EpisodeResponseDto(
        info: const InfoDto(
          count: 20,
          pages: 1,
          next: null,
          prev: null,
        ),
        results: const [],
      );

      when(mockDataSource.getEpisodes(page: 1))
          .thenAnswer((_) async => responseDto);

      // Act
      final result = await repository.getEpisodes(page: 1);

      // Assert
      result.when(
        success: (data) {
          expect(data.hasNextPage, false);
        },
        failure: (_, __) => fail('Should not be failure'),
      );
    });

    test('should return user-friendly error for connection error', () async {
      // Arrange
      when(mockDataSource.getEpisodes(page: 1)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await repository.getEpisodes(page: 1);

      // Assert
      result.when(
        success: (_) => fail('Should not be success'),
        failure: (message, exception) {
          expect(message, contains('No internet connection'));
        },
      );
    });
  });
}
