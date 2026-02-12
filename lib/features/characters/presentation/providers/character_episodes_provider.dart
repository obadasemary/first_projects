import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:samurai_studios/features/characters/presentation/state/character_episodes_state.dart';

class CharacterEpisodesNotifier
    extends StateNotifier<CharacterEpisodesState> {
  final Ref ref;
  final List<String> episodeUrls;

  CharacterEpisodesNotifier(this.ref, this.episodeUrls)
      : super(const Loading()) {
    _loadEpisodes();
  }

  Future<void> _loadEpisodes() async {
    try {
      final dataSource = ref.read(characterRemoteDataSourceProvider);
      final episodeDtos = await dataSource.getEpisodes(episodeUrls);
      final episodes = episodeDtos.map((dto) => dto.toDomain()).toList();
      state = Loaded(episodes);
    } catch (e) {
      state = Error('Failed to load episodes: ${e.toString()}');
    }
  }

  Future<void> retry() async {
    state = const Loading();
    await _loadEpisodes();
  }
}

final characterEpisodesProvider = StateNotifierProvider.family<
    CharacterEpisodesNotifier, CharacterEpisodesState, List<String>>(
  (ref, episodeUrls) {
    return CharacterEpisodesNotifier(ref, episodeUrls);
  },
);
