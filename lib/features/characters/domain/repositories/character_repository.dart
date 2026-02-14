import 'package:samurai_studios/core/network/api_result.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<ApiResult<CharacterPaginatedResult>> getCharacters({int page = 1});
}

class CharacterPaginatedResult {
  final List<Character> characters;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  CharacterPaginatedResult({
    required this.characters,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}
