import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../../core/constants/ui_assets.dart';

class UIShowcasePage extends StatefulWidget {
  const UIShowcasePage({super.key});

  @override
  State<UIShowcasePage> createState() => _UIShowcasePageState();
}

class _UIShowcasePageState extends State<UIShowcasePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusicBudColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'UI Design Showcase',
          style: MusicBudTypography.heading4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(MusicBudSpacing.lg),
            decoration: BoxDecoration(
              color: MusicBudColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: MusicBudColors.primaryRed,
                borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: DesignSystem.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: DesignSystem.onPrimary,
              ),
              unselectedLabelStyle: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              tabs: const [
                Tab(text: 'Main'),
                Tab(text: 'Extra'),
                Tab(text: 'Case Study'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMainScreensTab(),
                _buildExtraScreensTab(),
                _buildCaseStudyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainScreensTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(MusicBudSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: MusicBudSpacing.md,
        mainAxisSpacing: MusicBudSpacing.md,
      ),
      itemCount: UIAssets.mainScreenAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.mainScreenAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: MusicBudColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
              boxShadow: MusicBudShadows.medium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                      topRight: Radius.circular(MusicBudSpacing.radiusLg),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MusicBudColors.backgroundSecondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: MusicBudColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: MusicBudTypography.bodySmall.copyWith(
                                  color: MusicBudColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacingSM),
                  child: Text(
                    screenName,
                    style: DesignSystem.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: DesignSystem.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExtraScreensTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16.0, // DesignSystem.spacingMD
        mainAxisSpacing: 16.0, // DesignSystem.spacingMD
      ),
      itemCount: UIAssets.extraScreenAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.extraScreenAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: MusicBudColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
              boxShadow: MusicBudShadows.medium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                      topRight: Radius.circular(MusicBudSpacing.radiusLg),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MusicBudColors.backgroundSecondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: MusicBudColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: MusicBudTypography.bodySmall.copyWith(
                                  color: MusicBudColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacingSM),
                  child: Text(
                    screenName,
                    style: DesignSystem.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: DesignSystem.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCaseStudyTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(MusicBudSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
        mainAxisSpacing: MusicBudSpacing.md,
      ),
      itemCount: UIAssets.caseStudyAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.caseStudyAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: MusicBudColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
              boxShadow: MusicBudShadows.medium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                      topRight: Radius.circular(MusicBudSpacing.radiusLg),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MusicBudColors.backgroundSecondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: MusicBudColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: MusicBudTypography.bodySmall.copyWith(
                                  color: MusicBudColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacingSM),
                  child: Text(
                    screenName,
                    style: DesignSystem.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: DesignSystem.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getScreenName(String assetPath) {
    // Extract filename from path and clean it up
    final filename = assetPath.split('/').last;
    final nameWithoutExtension = filename.replaceAll('.png', '');
    
    // Convert to title case and clean up
    return nameWithoutExtension
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? 
             word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ')
        .trim();
  }

  void _showImageDialog(BuildContext context, String assetPath, String screenName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          decoration: BoxDecoration(
            color: MusicBudColors.backgroundTertiary,
            borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(MusicBudSpacing.md),
                decoration: const BoxDecoration(
                  color: MusicBudColors.primaryRed,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                    topRight: Radius.circular(MusicBudSpacing.radiusLg),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        screenName,
                        style: MusicBudTypography.heading5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Image
              Flexible(
                child: Container(
                  margin: const EdgeInsets.all(MusicBudSpacing.md),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(MusicBudSpacing.radiusMd),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: MusicBudColors.backgroundSecondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.broken_image,
                                size: 64,
                                color: MusicBudColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Image could not be loaded',
                                style: DesignSystem.bodyMedium.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                assetPath,
                                style: DesignSystem.bodySmall.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}