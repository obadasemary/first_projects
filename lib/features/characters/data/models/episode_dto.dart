import 'package:samurai_studios/features/characters/domain/entities/episode.dart';

class EpisodeDto {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final String url;
  final String created;

  const EpisodeDto({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory EpisodeDto.fromJson(Map<String, dynamic> json) {
    return EpisodeDto(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
      url: json['url'] as String,
      created: json['created'] as String,
    );
  }

  Episode toDomain() {
    return Episode(
      id: id,
      name: name,
      airDate: airDate,
      episode: episode,
    );
  }
}
