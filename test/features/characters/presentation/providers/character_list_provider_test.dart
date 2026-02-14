import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/characters/data/repositories/character_repository_impl.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';
import 'package:samurai_studios/features/characters/domain/repositories/character_repository.dart';
import 'package:samurai_studios/features/characters/presentation/providers/character_list_provider.dart';
import 'package:samurai_studios/features/characters/presentation/state/character_list_state.dart';

import 'character_list_provider_test.mocks.dart';

@GenerateMocks([CharacterRepository])
void main() {
  late MockCharacterRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockCharacterRepository();
    container = ProviderContainer(
      overrides: [
        characterRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CharacterListNotifier', () {
    test('should load characters on initialization', () async {
      // Arrange
      final mockCharacters = [
        const Character(
          id: 1,
          name: 'Rick Sanchez',
          status: CharacterStatus.alive,
          species: 'Human',
          type: '',
          gender: CharacterGender.male,
          origin: CharacterLocation(name: 'Earth'),
          location: CharacterLocation(name: 'Earth'),
          imageUrl: 'https://example.com/rick.jpg',
          episodeCount: 51,
          episodeUrls: [],
        ),
      ];

      final mockResult = CharacterPaginatedResult(
        characters: mockCharacters,
        currentPage: 1,
        totalPages: 42,
        hasNextPage: true,
      );

      when(mockRepository.getCharacters(page: 1))
          .thenAnswer((_) async => Success(mockResult));

      // Act
      final notifier = container.read(characterListNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(characterListNotifierProvider);
      expect(state, isA<Loaded>());

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (characters, currentPage, hasNextPage, isLoadingMore) {
          expect(characters.length, 1);
          expect(characters.first.name, 'Rick Sanchez');
          expect(currentPage, 1);
          expect(hasNextPage, true);
          expect(isLoadingMore, false);
        },
        error: (_) => fail('Should not be error'),
      );

      verify(mockRepository.getCharacters(page: 1)).called(1);
    });

    test('should show error state when loading fails', () async {
      // Arrange
      when(mockRepository.getCharacters(page: 1))
          .thenAnswer((_) async => const Failure('Network error'));

      // Act
      final notifier = container.read(characterListNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(characterListNotifierProvider);
      expect(state, isA<Error>());

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (_, __, ___, ____) => fail('Should not be loaded'),
        error: (message) {
          expect(message, 'Network error');
        },
      );
    });

    test('should load more characters when loadMore is called', () async {
      // Arrange
      final mockCharactersPage1 = [
        const Character(
          id: 1,
          name: 'Rick Sanchez',
          status: CharacterStatus.alive,
          species: 'Human',
          type: '',
          gender: CharacterGender.male,
          origin: CharacterLocation(name: 'Earth'),
          location: CharacterLocation(name: 'Earth'),
          imageUrl: 'https://example.com/rick.jpg',
          episodeCount: 51,
          episodeUrls: [],
        ),
      ];

      final mockCharactersPage2 = [
        const Character(
          id: 2,
          name: 'Morty Smith',
          status: CharacterStatus.alive,
          species: 'Human',
          type: '',
          gender: CharacterGender.male,
          origin: CharacterLocation(name: 'Earth'),
          location: CharacterLocation(name: 'Earth'),
          imageUrl: 'https://example.com/morty.jpg',
          episodeCount: 51,
          episodeUrls: [],
        ),
      ];

      final mockResultPage1 = CharacterPaginatedResult(
        characters: mockCharactersPage1,
        currentPage: 1,
        totalPages: 2,
        hasNextPage: true,
      );

      final mockResultPage2 = CharacterPaginatedResult(
        characters: mockCharactersPage2,
        currentPage: 2,
        totalPages: 2,
        hasNextPage: false,
      );

      when(mockRepository.getCharacters(page: 1))
          .thenAnswer((_) async => Success(mockResultPage1));
      when(mockRepository.getCharacters(page: 2))
          .thenAnswer((_) async => Success(mockResultPage2));

      // Act
      final notifier = container.read(characterListNotifierProvider.notifier);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Load more
      await notifier.loadMore();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(characterListNotifierProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (characters, currentPage, hasNextPage, isLoadingMore) {
          expect(characters.length, 2);
          expect(characters[0].name, 'Rick Sanchez');
          expect(characters[1].name, 'Morty Smith');
          expect(currentPage, 2);
          expect(hasNextPage, false);
        },
        error: (_) => fail('Should not be error'),
      );

      verify(mockRepository.getCharacters(page: 1)).called(1);
      verify(mockRepository.getCharacters(page: 2)).called(1);
    });

    test('should refresh and reload from first page', () async {
      // Arrange
      final mockCharacters = [
        const Character(
          id: 1,
          name: 'Rick Sanchez',
          status: CharacterStatus.alive,
          species: 'Human',
          type: '',
          gender: CharacterGender.male,
          origin: CharacterLocation(name: 'Earth'),
          location: CharacterLocation(name: 'Earth'),
          imageUrl: 'https://example.com/rick.jpg',
          episodeCount: 51,
          episodeUrls: [],
        ),
      ];

      final mockResult = CharacterPaginatedResult(
        characters: mockCharacters,
        currentPage: 1,
        totalPages: 42,
        hasNextPage: true,
      );

      when(mockRepository.getCharacters(page: 1))
          .thenAnswer((_) async => Success(mockResult));

      // Act
      final notifier = container.read(characterListNotifierProvider.notifier);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Refresh
      await notifier.refresh();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(mockRepository.getCharacters(page: 1)).called(2); // Initial + refresh
    });
  });
}
