import 'package:flutter/material.dart';
import 'package:samurai_studios/core/constants/app_colors.dart';
import 'package:samurai_studios/features/episodes/domain/entities/episode_entity.dart';

class EpisodeCard extends StatelessWidget {
  final EpisodeEntity episode;

  const EpisodeCard({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              episode.episode,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        title: Text(
          episode.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
              'Air Date: ${episode.airDate}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${episode.characters.length} characters',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey500,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.play_circle_outline,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
