import 'package:samurai_studios/features/characters/domain/entities/character.dart';

class CharacterDto {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final LocationDto origin;
  final LocationDto location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  const CharacterDto({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: LocationDto.fromJson(json['origin'] as Map<String, dynamic>),
      location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
      image: json['image'] as String,
      episode: (json['episode'] as List<dynamic>).cast<String>(),
      url: json['url'] as String,
      created: json['created'] as String,
    );
  }

  Character toDomain() {
    return Character(
      id: id,
      name: name,
      status: _parseStatus(status),
      species: species,
      type: type,
      gender: _parseGender(gender),
      origin: CharacterLocation(name: origin.name),
      location: CharacterLocation(name: location.name),
      imageUrl: image,
      episodeCount: episode.length,
      episodeUrls: episode,
    );
  }

  CharacterStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return CharacterStatus.alive;
      case 'dead':
        return CharacterStatus.dead;
      default:
        return CharacterStatus.unknown;
    }
  }

  CharacterGender _parseGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'female':
        return CharacterGender.female;
      case 'male':
        return CharacterGender.male;
      case 'genderless':
        return CharacterGender.genderless;
      default:
        return CharacterGender.unknown;
    }
  }
}

class LocationDto {
  final String name;
  final String url;

  const LocationDto({
    required this.name,
    required this.url,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
