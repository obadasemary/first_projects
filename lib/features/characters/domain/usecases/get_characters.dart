import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/features/characters/data/repositories/character_repository_impl.dart';
import 'package:samurai_studios/features/characters/domain/repositories/character_repository.dart';

final getCharactersProvider = FutureProvider.family<CharacterPaginatedResult, int>(
  (ref, page) async {
    final repository = ref.watch(characterRepositoryProvider);
    final result = await repository.getCharacters(page: page);

    return result.when(
      success: (data) => data,
      failure: (message, exception) => throw Exception(message),
    );
  },
);
