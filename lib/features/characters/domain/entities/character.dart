class Character {
  final int id;
  final String name;
  final CharacterStatus status;
  final String species;
  final String type;
  final CharacterGender gender;
  final CharacterLocation origin;
  final CharacterLocation location;
  final String imageUrl;
  final int episodeCount;
  final List<String> episodeUrls;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.imageUrl,
    required this.episodeCount,
    required this.episodeUrls,
  });
}

enum CharacterStatus {
  alive,
  dead,
  unknown,
}

enum CharacterGender {
  female,
  male,
  genderless,
  unknown,
}

class CharacterLocation {
  final String name;

  const CharacterLocation({required this.name});
}
