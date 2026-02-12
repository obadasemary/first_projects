import 'package:samurai_studios/features/characters/domain/entities/episode.dart';

sealed class CharacterEpisodesState {
  const CharacterEpisodesState();

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(List<Episode> episodes) loaded,
    required R Function(String message) error,
  }) {
    if (this is Initial) {
      return initial();
    } else if (this is Loading) {
      return loading();
    } else if (this is Loaded) {
      return loaded((this as Loaded).episodes);
    } else if (this is Error) {
      return error((this as Error).message);
    }
    throw Exception('Unknown CharacterEpisodesState type');
  }
}

class Initial extends CharacterEpisodesState {
  const Initial();
}

class Loading extends CharacterEpisodesState {
  const Loading();
}

class Loaded extends CharacterEpisodesState {
  final List<Episode> episodes;

  const Loaded(this.episodes);
}

class Error extends CharacterEpisodesState {
  final String message;

  const Error(this.message);
}
