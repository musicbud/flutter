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
      backgroundColor: DesignSystem.surface,
      appBar: AppBar(
        title: Text(
          'UI Design Showcase',
          style: DesignSystem.headlineSmall.copyWith(
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
            margin: const EdgeInsets.all(DesignSystem.spacingLG),
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: DesignSystem.primary,
                borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
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
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: DesignSystem.spacingMD,
        mainAxisSpacing: DesignSystem.spacingMD,
      ),
      itemCount: UIAssets.mainScreenAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.mainScreenAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              boxShadow: DesignSystem.shadowMedium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusLG),
                      topRight: Radius.circular(DesignSystem.radiusLG),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: DesignSystem.surfaceContainerHigh,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: DesignSystem.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: DesignSystem.bodySmall.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
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
        crossAxisSpacing: DesignSystem.spacingMD,
        mainAxisSpacing: DesignSystem.spacingMD,
      ),
      itemCount: UIAssets.extraScreenAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.extraScreenAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              boxShadow: DesignSystem.shadowMedium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusLG),
                      topRight: Radius.circular(DesignSystem.radiusLG),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: DesignSystem.surfaceContainerHigh,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: DesignSystem.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: DesignSystem.bodySmall.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
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
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: DesignSystem.spacingMD,
        mainAxisSpacing: DesignSystem.spacingMD,
      ),
      itemCount: UIAssets.caseStudyAssets.length,
      itemBuilder: (context, index) {
        final assetPath = UIAssets.caseStudyAssets[index];
        final screenName = _getScreenName(assetPath);

        return GestureDetector(
          onTap: () => _showImageDialog(context, assetPath, screenName),
          child: Container(
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              boxShadow: DesignSystem.shadowMedium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusLG),
                      topRight: Radius.circular(DesignSystem.radiusLG),
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: DesignSystem.surfaceContainerHigh,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: DesignSystem.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview\nUnavailable',
                                textAlign: TextAlign.center,
                                style: DesignSystem.bodySmall.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
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
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: Container(
            decoration: BoxDecoration(
              color: DesignSystem.surface,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              boxShadow: DesignSystem.shadowLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(DesignSystem.spacingMD),
                  decoration: BoxDecoration(
                    color: DesignSystem.surfaceContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusLG),
                      topRight: Radius.circular(DesignSystem.radiusLG),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          screenName,
                          style: DesignSystem.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: DesignSystem.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: DesignSystem.onSurface,
                      ),
                    ],
                  ),
                ),
                // Image
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingMD),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: DesignSystem.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                                const SizedBox(height: DesignSystem.spacingSM),
                                Text(
                                  'Image not available',
                                  style: DesignSystem.bodyMedium.copyWith(
                                    color: DesignSystem.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}