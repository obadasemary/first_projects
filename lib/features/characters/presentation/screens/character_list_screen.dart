import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/characters/presentation/providers/character_list_provider.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/character_card.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/character_shimmer.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/error_widget.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() =>
      _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
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
      final notifier = ref.read(characterListNotifierProvider.notifier);
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterListNotifierProvider);

    return Scaffold(
      body: state.when(
        initial: () => const Center(
          child: Text('Initializing...'),
        ),
        loading: () => const CharacterShimmer(),
        loaded: (characters, currentPage, hasNextPage, isLoadingMore) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(characterListNotifierProvider.notifier)
                  .refresh();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: characters.length + (isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemBuilder: (context, index) {
                if (index >= characters.length) {
                  // Loading more indicator
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return CharacterCard(character: characters[index]);
              },
            ),
          );
        },
        error: (message) => ErrorDisplay(
          message: message,
          onRetry: () {
            ref.invalidate(characterListNotifierProvider);
          },
        ),
      ),
    );
  }
}
