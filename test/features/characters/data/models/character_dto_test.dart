import 'package:flutter_test/flutter_test.dart';
import 'package:samurai_studios/features/characters/data/models/character_dto.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';

void main() {
  group('CharacterDto', () {
    test('should parse JSON correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {
          'name': 'Earth (C-137)',
          'url': 'https://rickandmortyapi.com/api/location/1'
        },
        'location': {
          'name': 'Citadel of Ricks',
          'url': 'https://rickandmortyapi.com/api/location/3'
        },
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': [
          'https://rickandmortyapi.com/api/episode/1',
          'https://rickandmortyapi.com/api/episode/2'
        ],
        'url': 'https://rickandmortyapi.com/api/character/1',
        'created': '2017-11-04T18:48:46.250Z'
      };

      // Act
      final dto = CharacterDto.fromJson(json);

      // Assert
      expect(dto.id, 1);
      expect(dto.name, 'Rick Sanchez');
      expect(dto.status, 'Alive');
      expect(dto.species, 'Human');
      expect(dto.gender, 'Male');
      expect(dto.origin.name, 'Earth (C-137)');
      expect(dto.location.name, 'Citadel of Ricks');
      expect(dto.image, 'https://rickandmortyapi.com/api/character/avatar/1.jpeg');
      expect(dto.episode.length, 2);
    });

    test('should convert to domain entity correctly', () {
      // Arrange
      final dto = CharacterDto(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: const LocationDto(
          name: 'Earth (C-137)',
          url: 'https://rickandmortyapi.com/api/location/1',
        ),
        location: const LocationDto(
          name: 'Citadel of Ricks',
          url: 'https://rickandmortyapi.com/api/location/3',
        ),
        image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        episode: const [
          'https://rickandmortyapi.com/api/episode/1',
          'https://rickandmortyapi.com/api/episode/2'
        ],
        url: 'https://rickandmortyapi.com/api/character/1',
        created: '2017-11-04T18:48:46.250Z',
      );

      // Act
      final character = dto.toDomain();

      // Assert
      expect(character.id, 1);
      expect(character.name, 'Rick Sanchez');
      expect(character.status, CharacterStatus.alive);
      expect(character.species, 'Human');
      expect(character.gender, CharacterGender.male);
      expect(character.origin.name, 'Earth (C-137)');
      expect(character.location.name, 'Citadel of Ricks');
      expect(character.imageUrl, 'https://rickandmortyapi.com/api/character/avatar/1.jpeg');
      expect(character.episodeCount, 2);
    });

    test('should parse status correctly', () {
      // Arrange & Act
      final aliveDto = CharacterDto.fromJson({
        'id': 1,
        'name': 'Rick',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'Earth', 'url': ''},
        'location': {'name': 'Earth', 'url': ''},
        'image': '',
        'episode': [],
        'url': '',
        'created': ''
      });

      final deadDto = CharacterDto.fromJson({
        'id': 2,
        'name': 'Dead Character',
        'status': 'Dead',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'Earth', 'url': ''},
        'location': {'name': 'Earth', 'url': ''},
        'image': '',
        'episode': [],
        'url': '',
        'created': ''
      });

      final unknownDto = CharacterDto.fromJson({
        'id': 3,
        'name': 'Unknown Character',
        'status': 'unknown',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'Earth', 'url': ''},
        'location': {'name': 'Earth', 'url': ''},
        'image': '',
        'episode': [],
        'url': '',
        'created': ''
      });

      // Assert
      expect(aliveDto.toDomain().status, CharacterStatus.alive);
      expect(deadDto.toDomain().status, CharacterStatus.dead);
      expect(unknownDto.toDomain().status, CharacterStatus.unknown);
    });
  });
}
