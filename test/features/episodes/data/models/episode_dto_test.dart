import 'package:flutter_test/flutter_test.dart';
import 'package:samurai_studios/features/episodes/data/models/episode_dto.dart';
import 'package:samurai_studios/features/episodes/domain/entities/episode.dart';

void main() {
  group('EpisodeDto', () {
    test('should parse JSON correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Pilot',
        'air_date': 'December 2, 2013',
        'episode': 'S01E01',
        'characters': [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2'
        ],
        'url': 'https://rickandmortyapi.com/api/episode/1',
        'created': '2017-11-10T12:56:33.798Z'
      };

      // Act
      final dto = EpisodeDto.fromJson(json);

      // Assert
      expect(dto.id, 1);
      expect(dto.name, 'Pilot');
      expect(dto.airDate, 'December 2, 2013');
      expect(dto.episode, 'S01E01');
      expect(dto.characters.length, 2);
    });

    test('should convert to domain entity correctly', () {
      // Arrange
      final dto = EpisodeDto(
        id: 1,
        name: 'Pilot',
        airDate: 'December 2, 2013',
        episode: 'S01E01',
        characters: const [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2'
        ],
        url: 'https://rickandmortyapi.com/api/episode/1',
        created: '2017-11-10T12:56:33.798Z',
      );

      // Act
      final episode = dto.toDomain();

      // Assert
      expect(episode.id, 1);
      expect(episode.name, 'Pilot');
      expect(episode.airDate, 'December 2, 2013');
      expect(episode.episode, 'S01E01');
      expect(episode.characterCount, 2);
    });

    test('should calculate characterCount from characters array length', () {
      // Arrange
      final dto = EpisodeDto(
        id: 2,
        name: 'Lawnmower Dog',
        airDate: 'December 9, 2013',
        episode: 'S01E02',
        characters: const [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2',
          'https://rickandmortyapi.com/api/character/38',
        ],
        url: 'https://rickandmortyapi.com/api/episode/2',
        created: '2017-11-10T12:56:33.916Z',
      );

      // Act
      final episode = dto.toDomain();

      // Assert
      expect(episode.characterCount, 3);
    });
  });
}
