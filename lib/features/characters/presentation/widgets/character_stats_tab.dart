import 'package:flutter/material.dart';
import 'package:samurai_studios/core/constants/app_colors.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/stat_card_widget.dart';

class CharacterStatsTab extends StatelessWidget {
  final Character character;

  const CharacterStatsTab({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Character Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            StatCard(
              icon: Icons.tv,
              label: 'Episodes',
              value: '${character.episodeCount}',
              color: AppColors.genderMale,
              progress: _calculateEpisodeProgress(),
            ),
            StatCard(
              icon: _getStatusIcon(),
              label: 'Status',
              value: _formatStatus(character.status),
              color: _getStatusColor(),
            ),
            StatCard(
              icon: Icons.science,
              label: 'Species',
              value: character.species,
              color: AppColors.genderGenderless,
            ),
            StatCard(
              icon: _getGenderIcon(),
              label: 'Gender',
              value: _formatGender(character.gender),
              color: _getGenderColor(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Character Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoItem(
                  context,
                  'Character ID',
                  '#${character.id}',
                  Icons.tag,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  'Full Name',
                  character.name,
                  Icons.person,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  'Current Location',
                  character.location.name,
                  Icons.location_on,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  'Origin',
                  character.origin.name,
                  Icons.home,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textGrey600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGrey600,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateEpisodeProgress() {
    // Assuming max episodes across all characters is around 51
    // This is for visualization purposes
    return (character.episodeCount / 51).clamp(0.0, 1.0);
  }

  Color _getStatusColor() {
    switch (character.status) {
      case CharacterStatus.alive:
        return AppColors.statusAlive;
      case CharacterStatus.dead:
        return AppColors.statusDead;
      case CharacterStatus.unknown:
        return AppColors.statusUnknown;
    }
  }

  IconData _getStatusIcon() {
    switch (character.status) {
      case CharacterStatus.alive:
        return Icons.favorite;
      case CharacterStatus.dead:
        return Icons.heart_broken;
      case CharacterStatus.unknown:
        return Icons.help_outline;
    }
  }

  String _formatStatus(CharacterStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  Color _getGenderColor() {
    switch (character.gender) {
      case CharacterGender.male:
        return AppColors.genderMale;
      case CharacterGender.female:
        return AppColors.genderFemale;
      case CharacterGender.genderless:
        return AppColors.genderGenderless;
      case CharacterGender.unknown:
        return AppColors.genderUnknown;
    }
  }

  IconData _getGenderIcon() {
    switch (character.gender) {
      case CharacterGender.male:
        return Icons.male;
      case CharacterGender.female:
        return Icons.female;
      case CharacterGender.genderless:
        return Icons.remove_circle_outline;
      case CharacterGender.unknown:
        return Icons.help_outline;
    }
  }

  String _formatGender(CharacterGender gender) {
    return gender.name[0].toUpperCase() + gender.name.substring(1);
  }
}
