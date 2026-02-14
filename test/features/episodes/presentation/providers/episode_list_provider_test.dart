import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/episodes/data/repositories/episode_repository_impl.dart';
import 'package:samurai_studios/features/episodes/domain/entities/episode.dart';
import 'package:samurai_studios/features/episodes/domain/repositories/episode_repository.dart';
import 'package:samurai_studios/features/episodes/presentation/providers/episode_list_provider.dart';
import 'package:samurai_studios/features/episodes/presentation/state/episode_list_state.dart';

import 'episode_list_provider_test.mocks.dart';

@GenerateMocks([EpisodeRepository])
void main() {
  late MockEpisodeRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockEpisodeRepository();
    container = ProviderContainer(
      overrides: [
        episodeRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('EpisodeListNotifier', () {
    test('should load episodes on initialization', () async {
      // Arrange
      final mockEpisodes = [
        const Episode(
          id: 1,
          name: 'Pilot',
          airDate: 'December 2, 2013',
          episode: 'S01E01',
          characterCount: 19,
        ),
      ];

      final mockResult = EpisodePaginatedResult(
        episodes: mockEpisodes,
        currentPage: 1,
        totalPages: 3,
        hasNextPage: true,
      );

      when(mockRepository.getEpisodes(page: 1))
          .thenAnswer((_) async => Success(mockResult));

      // Act - just reading the provider will trigger initialization
      container.read(episodeListNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(episodeListNotifierProvider);
      expect(state, isA<Loaded>());

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (episodes, currentPage, hasNextPage, isLoadingMore) {
          expect(episodes.length, 1);
          expect(episodes.first.name, 'Pilot');
          expect(currentPage, 1);
          expect(hasNextPage, true);
          expect(isLoadingMore, false);
        },
        error: (_) => fail('Should not be error'),
      );

      verify(mockRepository.getEpisodes(page: 1)).called(1);
    });

    test('should show error state when loading fails', () async {
      // Arrange
      when(mockRepository.getEpisodes(page: 1))
          .thenAnswer((_) async => const Failure('Network error'));

      // Act
      container.read(episodeListNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(episodeListNotifierProvider);
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

    test('should load more episodes when loadMore is called', () async {
      // Arrange
      final mockEpisodesPage1 = [
        const Episode(
          id: 1,
          name: 'Pilot',
          airDate: 'December 2, 2013',
          episode: 'S01E01',
          characterCount: 19,
        ),
      ];

      final mockEpisodesPage2 = [
        const Episode(
          id: 2,
          name: 'Lawnmower Dog',
          airDate: 'December 9, 2013',
          episode: 'S01E02',
          characterCount: 18,
        ),
      ];

      final mockResultPage1 = EpisodePaginatedResult(
        episodes: mockEpisodesPage1,
        currentPage: 1,
        totalPages: 2,
        hasNextPage: true,
      );

      final mockResultPage2 = EpisodePaginatedResult(
        episodes: mockEpisodesPage2,
        currentPage: 2,
        totalPages: 2,
        hasNextPage: false,
      );

      when(mockRepository.getEpisodes(page: 1))
          .thenAnswer((_) async => Success(mockResultPage1));
      when(mockRepository.getEpisodes(page: 2))
          .thenAnswer((_) async => Success(mockResultPage2));

      // Act
      final notifier = container.read(episodeListNotifierProvider.notifier);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Load more
      await notifier.loadMore();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(episodeListNotifierProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (episodes, currentPage, hasNextPage, isLoadingMore) {
          expect(episodes.length, 2);
          expect(episodes[0].name, 'Pilot');
          expect(episodes[1].name, 'Lawnmower Dog');
          expect(currentPage, 2);
          expect(hasNextPage, false);
        },
        error: (_) => fail('Should not be error'),
      );

      verify(mockRepository.getEpisodes(page: 1)).called(1);
      verify(mockRepository.getEpisodes(page: 2)).called(1);
    });
  });
}
