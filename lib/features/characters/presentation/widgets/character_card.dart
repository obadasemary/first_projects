import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';
import 'package:samurai_studios/features/characters/presentation/screens/character_details_screen.dart';
import 'package:samurai_studios/core/constants/app_colors.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailsScreen(character: character),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'character-${character.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: character.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: AppColors.shimmerBase,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: AppColors.shimmerBase,
                child: const Icon(Icons.person, color: AppColors.textGrey),
              ),
            ),
          ),
        ),
        title: Text(
          character.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${character.species} - ${character.status.name}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Location: ${character.location.name}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(character.status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            character.status.name.toUpperCase(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ),
    );
  }

  Color _getStatusColor(CharacterStatus status) {
    switch (status) {
      case CharacterStatus.alive:
        return AppColors.statusAlive;
      case CharacterStatus.dead:
        return AppColors.statusDead;
      case CharacterStatus.unknown:
        return AppColors.statusUnknown;
    }
  }
}
