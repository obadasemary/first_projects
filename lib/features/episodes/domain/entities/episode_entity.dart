class EpisodeEntity {
  final int id;
  final String name;
  final String airDate;
  final String episode; // e.g., "S01E01"
  final String url;
  final String created;
  final List<String> characters;

  const EpisodeEntity({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.url,
    required this.created,
    required this.characters,
  });
}
