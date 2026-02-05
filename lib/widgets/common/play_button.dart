import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A standardized circular play button widget.
/// Provides consistent styling and behavior for play buttons across the app.
///
/// Features:
/// - Circular design with customizable size
/// - Play/pause state management
/// - Loading state support
/// - Consistent theming and animations
/// - Accessibility support
/// - Customizable colors and styling
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

  /// Background color when playing
  final Color? playingBackgroundColor;

  /// Background color when paused
  final Color? pausedBackgroundColor;

  /// Background color when loading
  final Color? loadingBackgroundColor;

  /// Border radius for non-circular buttons
  final BorderRadius? borderRadius;

  /// Whether the button should be circular (default: true)
  final bool isCircular;

  /// Custom play icon
  final IconData? playIcon;

  /// Custom pause icon
  final IconData? pauseIcon;

  /// Custom loading indicator
  final Widget? loadingIndicator;

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
    this.playingBackgroundColor,
    this.pausedBackgroundColor,
    this.loadingBackgroundColor,
    this.borderRadius,
    this.isCircular = true,
    this.playIcon,
    this.pauseIcon,
    this.loadingIndicator,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showShadow = true,
    this.elevation = 4,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
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

    // Provide haptic feedback
    // HapticFeedback.lightImpact();

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
                  : (widget.borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD)),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: widget.isCircular
                      ? null
                      : (widget.borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD)),
                  shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                  boxShadow: widget.showShadow
                      ? [
                        BoxShadow(
                          color: Colors.black.withAlpha((255 * 0.2).round()),
                          blurRadius: widget.elevation,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
                ),
                child: IconButton(
                  onPressed: _handleTap,
                  icon: _buildIcon(),
                  iconSize: widget.size * 0.5,
                  color: widget.iconColor ?? DesignSystem.onPrimary,
                  padding: EdgeInsets.zero,
                  splashRadius: widget.size * 0.5,
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
        return widget.playingBackgroundColor ?? DesignSystem.primary;
      case PlayState.paused:
        return widget.pausedBackgroundColor ?? DesignSystem.primary;
      case PlayState.loading:
        return widget.loadingBackgroundColor ?? DesignSystem.primary.withAlpha((255 * 0.8).round());
    }
  }

  Widget _buildIcon() {
    switch (widget.playState) {
      case PlayState.playing:
        return Icon(
          widget.pauseIcon ?? Icons.pause,
          color: widget.iconColor ?? DesignSystem.onPrimary,
        );
      case PlayState.paused:
        return Icon(
          widget.playIcon ?? Icons.play_arrow,
          color: widget.iconColor ?? DesignSystem.onPrimary,
        );
      case PlayState.loading:
        return widget.loadingIndicator ?? SizedBox(
          width: widget.size * 0.3,
          height: widget.size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.iconColor ?? DesignSystem.onPrimary,
            ),
          ),
        );
    }
  }
}

/// Enum representing the different play states
enum PlayState {
  /// Content is currently playing
  playing,

  /// Content is paused
  paused,

  /// Content is loading/buffering
  loading,
}
