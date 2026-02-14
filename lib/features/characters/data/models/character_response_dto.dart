import 'package:samurai_studios/features/characters/data/models/character_dto.dart';

class CharacterResponseDto {
  final InfoDto info;
  final List<CharacterDto> results;

  const CharacterResponseDto({
    required this.info,
    required this.results,
  });

  factory CharacterResponseDto.fromJson(Map<String, dynamic> json) {
    return CharacterResponseDto(
      info: InfoDto.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => CharacterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InfoDto {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoDto({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory InfoDto.fromJson(Map<String, dynamic> json) {
    return InfoDto(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}
