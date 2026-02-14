import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:samurai_studios/features/characters/data/models/character_dto.dart';
import 'package:samurai_studios/features/characters/data/models/character_response_dto.dart';
import 'package:samurai_studios/features/characters/data/repositories/character_repository_impl.dart';

import 'character_repository_impl_test.mocks.dart';

@GenerateMocks([CharacterRemoteDataSource])
void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCharacterRemoteDataSource();
    repository = CharacterRepositoryImpl(mockDataSource);
  });

  group('CharacterRepositoryImpl', () {
    test('should return success with characters when API call succeeds', () async {
      // Arrange
      final responseDto = CharacterResponseDto(
        info: const InfoDto(
          count: 826,
          pages: 42,
          next: 'https://rickandmortyapi.com/api/character?page=2',
          prev: null,
        ),
        results: [
          const CharacterDto(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            type: '',
            gender: 'Male',
            origin: LocationDto(name: 'Earth (C-137)', url: ''),
            location: LocationDto(name: 'Citadel of Ricks', url: ''),
            image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            episode: [],
            url: '',
            created: '',
          ),
        ],
      );

      when(mockDataSource.getCharacters(page: 1))
          .thenAnswer((_) async => responseDto);

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      expect(result, isA<Success>());
      result.when(
        success: (data) {
          expect(data.characters.length, 1);
          expect(data.characters.first.name, 'Rick Sanchez');
          expect(data.currentPage, 1);
          expect(data.totalPages, 42);
          expect(data.hasNextPage, true);
        },
        failure: (_, __) => fail('Should not be failure'),
      );

      verify(mockDataSource.getCharacters(page: 1)).called(1);
    });

    test('should return failure when API call throws DioException', () async {
      // Arrange
      when(mockDataSource.getCharacters(page: 1)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      expect(result, isA<Failure>());
      result.when(
        success: (_) => fail('Should not be success'),
        failure: (message, exception) {
          expect(message, contains('Connection timeout'));
        },
      );
    });

    test('should return failure when API call throws generic exception', () async {
      // Arrange
      when(mockDataSource.getCharacters(page: 1))
          .thenThrow(Exception('Something went wrong'));

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      expect(result, isA<Failure>());
      result.when(
        success: (_) => fail('Should not be success'),
        failure: (message, exception) {
          expect(message, 'An unexpected error occurred');
        },
      );
    });

    test('should handle no next page correctly', () async {
      // Arrange
      final responseDto = CharacterResponseDto(
        info: const InfoDto(
          count: 20,
          pages: 1,
          next: null,
          prev: null,
        ),
        results: const [],
      );

      when(mockDataSource.getCharacters(page: 1))
          .thenAnswer((_) async => responseDto);

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      result.when(
        success: (data) {
          expect(data.hasNextPage, false);
        },
        failure: (_, __) => fail('Should not be failure'),
      );
    });
  });
}
