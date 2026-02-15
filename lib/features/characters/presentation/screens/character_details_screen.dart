import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:samurai_studios/core/constants/app_colors.dart';
import 'package:samurai_studios/features/characters/domain/entities/character.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/character_info_tab.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/character_stats_tab.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/character_location_tab.dart';
import 'package:samurai_studios/features/characters/presentation/widgets/episode_list_widget.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailsScreen({
    super.key,
    required this.character,
  });

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.black.withValues(alpha: 0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              unselectedLabelColor: AppColors.textGrey,
              labelColor: AppColors.white,
              tabs: [
                Tab(text: 'Info', icon: Icon(Icons.info_outline)),
                Tab(text: 'Stats', icon: Icon(Icons.bar_chart)),
                Tab(text: 'Location', icon: Icon(Icons.location_on_outlined)),
                Tab(text: 'Episodes', icon: Icon(Icons.tv)),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.character.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: AppColors.shadow,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'character-${widget.character.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.character.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.shimmerBase,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.shimmerBase,
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.transparent,
                          AppColors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                CharacterInfoTab(character: widget.character),
                // Stats Tab
                CharacterStatsTab(character: widget.character),
                // Location Tab
                CharacterLocationTab(character: widget.character),
                // Episodes Tab
                EpisodeListWidget(episodeUrls: widget.character.episodeUrls),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
