import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/episodes/presentation/providers/episode_list_provider.dart';
import 'package:samurai_studios/features/episodes/presentation/widgets/episode_card.dart';
import 'package:samurai_studios/features/episodes/presentation/widgets/episode_shimmer.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/error_widget.dart';

class EpisodeListScreen extends ConsumerStatefulWidget {
  const EpisodeListScreen({super.key});

  @override
  ConsumerState<EpisodeListScreen> createState() =>
      _EpisodeListScreenState();
}

class _EpisodeListScreenState extends ConsumerState<EpisodeListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      final notifier = ref.read(episodeListNotifierProvider.notifier);
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(episodeListNotifierProvider);

    return Scaffold(
      body: state.when(
        initial: () => const Center(
          child: Text('Initializing...'),
        ),
        loading: () => const EpisodeShimmer(),
        loaded: (episodes, currentPage, hasNextPage, isLoadingMore) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(episodeListNotifierProvider.notifier)
                  .refresh();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: episodes.length + (isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemBuilder: (context, index) {
                if (index >= episodes.length) {
                  // Loading more indicator
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return EpisodeCard(episode: episodes[index]);
              },
            ),
          );
        },
        error: (message) => ErrorDisplay(
          message: message,
          onRetry: () {
            ref.invalidate(episodeListNotifierProvider);
          },
        ),
      ),
    );
  }
}
