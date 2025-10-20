import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Play state enum
enum PlayState {
  playing,
  paused,
  loading,
}

/// A standardized circular play button widget
///
/// Provides consistent styling and behavior for play buttons across the app.
///
/// Example:
/// ```dart
/// PlayButton(
///   playState: isPlaying ? PlayState.playing : PlayState.paused,
///   onPlayPressed: () => togglePlay(),
///   size: 60,
/// )
/// ```
class PlayButton extends StatefulWidget {
  /// The current playing state
  final PlayState playState;

  /// Callback when play/pause is pressed
  final VoidCallback? onPlayPressed;

  /// Size of the button (diameter)
  final double size;

  /// Background color of the button
  final Color? backgroundColor;

  /// Icon color for play/pause icons
  final Color? iconColor;

  /// Whether the button should be circular (default: true)
  final bool isCircular;

  /// Custom play icon
  final IconData? playIcon;

  /// Custom pause icon
  final IconData? pauseIcon;

  /// Animation duration for state changes
  final Duration animationDuration;

  /// Whether to show a subtle shadow
  final bool showShadow;

  /// Elevation for the shadow
  final double elevation;

  const PlayButton({
    super.key,
    this.playState = PlayState.paused,
    this.onPlayPressed,
    this.size = 56,
    this.backgroundColor,
    this.iconColor,
    this.isCircular = true,
    this.playIcon,
    this.pauseIcon,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showShadow = true,
    this.elevation = 4,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();

  /// Factory for a small play button
  factory PlayButton.small({
    required PlayState playState,
    VoidCallback? onPlayPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return PlayButton(
      playState: playState,
      onPlayPressed: onPlayPressed,
      size: 40,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  /// Factory for a large play button
  factory PlayButton.large({
    required PlayState playState,
    VoidCallback? onPlayPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return PlayButton(
      playState: playState,
      onPlayPressed: onPlayPressed,
      size: 72,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _updateAnimationState();
  }

  @override
  void didUpdateWidget(PlayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playState != widget.playState) {
      _updateAnimationState();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimationState() {
    if (widget.playState == PlayState.loading) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.value = 1.0;
    }
  }

  void _handleTap() {
    if (widget.playState == PlayState.loading || widget.onPlayPressed == null) {
      return;
    }

    // Animate button press
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onPlayPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: widget.isCircular
                  ? null
                  : BorderRadius.circular(DesignSystem.radiusMD),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: widget.isCircular
                      ? null
                      : BorderRadius.circular(DesignSystem.radiusMD),
                  shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                  boxShadow: widget.showShadow
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: widget.elevation,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: widget.playState == PlayState.loading
                      ? _buildLoadingIndicator()
                      : _buildIcon(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    switch (widget.playState) {
      case PlayState.playing:
        return DesignSystem.primary;
      case PlayState.paused:
        return DesignSystem.primary;
      case PlayState.loading:
        return DesignSystem.surfaceContainer;
    }
  }

  Widget _buildIcon() {
    final IconData icon = widget.playState == PlayState.playing
        ? (widget.pauseIcon ?? Icons.pause)
        : (widget.playIcon ?? Icons.play_arrow);

    return Icon(
      icon,
      size: widget.size * 0.5,
      color: widget.iconColor ?? DesignSystem.onPrimary,
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: widget.size * 0.5,
      height: widget.size * 0.5,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.iconColor ?? DesignSystem.onPrimary,
        ),
      ),
    );
  }
}

/// A minimal play/pause toggle icon button
class PlayPauseIcon extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  const PlayPauseIcon({
    super.key,
    required this.isPlaying,
    this.onTap,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: size,
      ),
      color: color ?? DesignSystem.onSurface,
    );
  }
}
