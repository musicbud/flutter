import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A skeleton/shimmer loading placeholder widget.
///
/// Displays animated placeholder content while data is loading.
/// Supports various shapes and custom dimensions.
///
/// Example:
/// ```dart
/// Skeleton(
///   width: 200,
///   height: 20,
/// )
/// ```
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double? borderRadius;
  final BoxShape shape;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final baseColor = design?.designSystemColors.surfaceDark ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = design?.designSystemColors.surfaceDark.withValues(alpha: 0.5) ?? 
        theme.colorScheme.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ),
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.borderRadius ?? 4)
                : null,
            shape: widget.shape,
          ),
        );
      },
    );
  }
}

/// Circular skeleton for avatars
class CircularSkeleton extends StatelessWidget {
  const CircularSkeleton({
    super.key,
    this.size = 48,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }
}

/// Text line skeleton
class TextLineSkeleton extends StatelessWidget {
  const TextLineSkeleton({
    super.key,
    this.width,
    this.height = 16,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: 8,
    );
  }
}

/// Card skeleton for media cards
class CardSkeleton extends StatelessWidget {
  const CardSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 200,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    
    return Container(
      width: width,
      padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(
            width: width,
            height: height * 0.6,
            borderRadius: design?.designSystemRadius.md ?? 12,
          ),
          SizedBox(height: design?.designSystemSpacing.sm ?? 8),
          const TextLineSkeleton(width: 150),
          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
          const TextLineSkeleton(width: 100),
        ],
      ),
    );
  }
}

/// List item skeleton
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({
    super.key,
    this.showAvatar = true,
    this.showTrailing = false,
  });

  final bool showAvatar;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    
    return Padding(
      padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 16),
      child: Row(
        children: [
          if (showAvatar) ...[
            const CircularSkeleton(size: 48),
            SizedBox(width: design?.designSystemSpacing.md ?? 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextLineSkeleton(width: 150),
                SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                const TextLineSkeleton(width: 100),
              ],
            ),
          ),
          if (showTrailing)
            const Skeleton(width: 24, height: 24),
        ],
      ),
    );
  }
}

/// Track tile skeleton
class TrackTileSkeleton extends StatelessWidget {
  const TrackTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design?.designSystemSpacing.md ?? 16,
        vertical: design?.designSystemSpacing.sm ?? 8,
      ),
      child: Row(
        children: [
          const Skeleton(width: 56, height: 56, borderRadius: 8),
          SizedBox(width: design?.designSystemSpacing.md ?? 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextLineSkeleton(width: 180),
                SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                const TextLineSkeleton(width: 120),
              ],
            ),
          ),
          const Skeleton(width: 24, height: 24),
        ],
      ),
    );
  }
}

/// Grid skeleton for content grids
class GridSkeleton extends StatelessWidget {
  const GridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: design?.designSystemSpacing.md ?? 16,
        mainAxisSpacing: design?.designSystemSpacing.md ?? 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Skeleton(
                width: double.infinity,
                borderRadius: 12,
              ),
            ),
            SizedBox(height: design?.designSystemSpacing.sm ?? 8),
            const TextLineSkeleton(width: 100),
            SizedBox(height: design?.designSystemSpacing.xs ?? 4),
            const TextLineSkeleton(width: 70),
          ],
        );
      },
    );
  }
}

/// Profile skeleton
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    
    return Column(
      children: [
        const CircularSkeleton(size: 96),
        SizedBox(height: design?.designSystemSpacing.md ?? 16),
        const TextLineSkeleton(width: 150),
        SizedBox(height: design?.designSystemSpacing.xs ?? 4),
        const TextLineSkeleton(width: 200),
        SizedBox(height: design?.designSystemSpacing.lg ?? 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatSkeleton(design),
            _buildStatSkeleton(design),
            _buildStatSkeleton(design),
          ],
        ),
      ],
    );
  }

  Widget _buildStatSkeleton(DesignSystemThemeExtension? design) {
    return Column(
      children: [
        const TextLineSkeleton(width: 60),
        SizedBox(height: design?.designSystemSpacing.xs ?? 4),
        const TextLineSkeleton(width: 80),
      ],
    );
  }
}

/// Shimmer wrapper for custom content
class ShimmerWrapper extends StatefulWidget {
  const ShimmerWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white,
                Colors.transparent,
              ],
              stops: [
                (_controller.value - 1).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
