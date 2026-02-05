import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern carousel with page indicators
///
/// Example:
/// ```dart
/// ModernCarousel(
///   items: [AlbumCard1(), AlbumCard2(), AlbumCard3()],
///   height: 200,
/// )
/// ```
class ModernCarousel extends StatefulWidget {
  const ModernCarousel({
    super.key,
    required this.items,
    this.height = 200.0,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicators = true,
    this.onPageChanged,
  });

  final List<Widget> items;
  final double height;
  final double aspectRatio;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showIndicators;
  final ValueChanged<int>? onPageChanged;

  @override
  State<ModernCarousel> createState() => _ModernCarouselState();
}

class _ModernCarouselState extends State<ModernCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayInterval, () {
      if (mounted && widget.autoPlay) {
        final nextPage = (_currentPage + 1) % widget.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
        ),
        if (widget.showIndicators) ...[
          const SizedBox(height: 16),
          CarouselIndicators(
            count: widget.items.length,
            currentIndex: _currentPage,
          ),
        ],
      ],
    );
  }
}

/// Page indicators for carousel
class CarouselIndicators extends StatelessWidget {
  const CarouselIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.size = 8.0,
  });

  final int count;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: index == currentIndex ? size * 2 : size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == currentIndex
                ? (activeColor ?? DesignSystem.primary)
                : (inactiveColor ?? DesignSystem.border),
            borderRadius: BorderRadius.circular(size / 2),
          ),
        );
      }),
    );
  }
}

/// Horizontal scrollable carousel
class HorizontalCarousel extends StatelessWidget {
  const HorizontalCarousel({
    super.key,
    required this.items,
    this.height = 200.0,
    this.itemWidth = 150.0,
    this.spacing = 12.0,
  });

  final List<Widget> items;
  final double height;
  final double itemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return SizedBox(
            width: itemWidth,
            child: items[index],
          );
        },
      ),
    );
  }
}

/// Story-style circular carousel
class StoryCarousel extends StatelessWidget {
  const StoryCarousel({
    super.key,
    required this.stories,
    this.size = 80.0,
  });

  final List<StoryItem> stories;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size + 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: DesignSystem.spacingSM),
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: story.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: story.hasUnread
                        ? const LinearGradient(
                            colors: [
                              DesignSystem.primary,
                              DesignSystem.secondary,
                            ],
                          )
                        : null,
                    border: !story.hasUnread
                        ? Border.all(
                            color: DesignSystem.border,
                            width: 2,
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    backgroundImage: story.imageUrl != null ? NetworkImage(story.imageUrl!) : null,
                    child: story.imageUrl == null ? Icon(story.icon ?? Icons.person) : null,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                SizedBox(
                  width: size,
                  child: Text(
                    story.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: DesignSystem.caption,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StoryItem {
  const StoryItem({
    required this.title,
    this.imageUrl,
    this.icon,
    this.hasUnread = false,
    this.onTap,
  });

  final String title;
  final String? imageUrl;
  final IconData? icon;
  final bool hasUnread;
  final VoidCallback? onTap;
}

/// Full-screen page view with transitions
class FullScreenPageView extends StatelessWidget {
  const FullScreenPageView({
    super.key,
    required this.pages,
    this.initialPage = 0,
    this.onPageChanged,
  });

  final List<Widget> pages;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      controller: PageController(initialPage: initialPage),
      itemBuilder: (context, index) {
        return pages[index];
      },
    );
  }
}