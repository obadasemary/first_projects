import 'package:flutter/material.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/info_row_widget.dart';

class CharacterInfoTab extends StatelessWidget {
  final Character character;

  const CharacterInfoTab({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 24),
                InfoRow(
                  icon: Icons.person,
                  label: 'Name',
                  value: character.name,
                ),
                const SizedBox(height: 8),
                _buildStatusRow(context),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.science,
                  label: 'Species',
                  value: character.species,
                ),
                if (character.type.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  InfoRow(
                    icon: Icons.category,
                    label: 'Type',
                    value: character.type,
                  ),
                ],
                const SizedBox(height: 8),
                InfoRow(
                  icon: _getGenderIcon(),
                  label: 'Gender',
                  value: _formatGender(character.gender),
                  iconColor: _getGenderColor(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 24),
                InfoRow(
                  icon: Icons.tv,
                  label: 'Episode Appearances',
                  value: '${character.episodeCount} episodes',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            size: 24,
            color: _getStatusColor(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    character.status.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (character.status) {
      case CharacterStatus.alive:
        return Colors.green;
      case CharacterStatus.dead:
        return Colors.red;
      case CharacterStatus.unknown:
        return Colors.grey;
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

  Color _getGenderColor() {
    switch (character.gender) {
      case CharacterGender.male:
        return Colors.blue;
      case CharacterGender.female:
        return Colors.pink;
      case CharacterGender.genderless:
        return Colors.purple;
      case CharacterGender.unknown:
        return Colors.grey;
    }
  }

  String _formatGender(CharacterGender gender) {
    return gender.name[0].toUpperCase() + gender.name.substring(1);
  }
}
