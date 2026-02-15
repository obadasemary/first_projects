import 'package:samurai_studios/features/episodes/domain/entities/episode_entity.dart';

class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final String created;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      episode: json['episode'] as String? ?? '',
      characters: (json['characters'] as List<dynamic>? ?? []).cast<String>(),
      url: json['url'] as String? ?? '',
      created: json['created'] as String? ?? '',
    );
  }

  EpisodeEntity toDomain() {
    return EpisodeEntity(
      id: id,
      name: name,
      airDate: airDate,
      episode: episode,
      created: created,
      url: url,
      characters: characters,
    );
  }
}
