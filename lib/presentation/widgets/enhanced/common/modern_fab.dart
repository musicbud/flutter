import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

/// Modern Floating Action Button with animations and variants
///
/// Supports:
/// - Extended FABs with text and icon
/// - Mini FABs
/// - Animated rotation, scale, and color transitions
/// - Multiple action buttons (Speed Dial)
///
/// Example:
/// ```dart
/// ModernFAB(
///   icon: Icons.add,
///   onPressed: () => addNewItem(),
///   label: 'Add',
/// )
/// ```
class ModernFAB extends StatefulWidget {
  const ModernFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
    this.tooltip,
    this.elevation = 6.0,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;
  final String? tooltip;
  final double elevation;

  @override
  State<ModernFAB> createState() => _ModernFABState();
}

class _ModernFABState extends State<ModernFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? DesignSystem.primary;
    final fgColor = widget.foregroundColor ?? Colors.white;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.label != null
          ? FloatingActionButton.extended(
              onPressed: widget.onPressed,
              backgroundColor: bgColor,
              foregroundColor: fgColor,
              icon: Icon(widget.icon),
              label: Text(widget.label!),
              heroTag: widget.heroTag,
              tooltip: widget.tooltip,
              elevation: widget.elevation,
            )
          : FloatingActionButton(
              onPressed: widget.onPressed,
              backgroundColor: bgColor,
              foregroundColor: fgColor,
              mini: widget.mini,
              heroTag: widget.heroTag,
              tooltip: widget.tooltip,
              elevation: widget.elevation,
              child: Icon(widget.icon),
            ),
    );
  }
}

/// Animated FAB that rotates on press
class RotatingFAB extends StatefulWidget {
  const RotatingFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.rotatedIcon,
    this.mini = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final IconData? rotatedIcon;
  final bool mini;

  @override
  State<RotatingFAB> createState() => _RotatingFABState();
}

class _RotatingFABState extends State<RotatingFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    setState(() {
      _isRotated = !_isRotated;
      if (_isRotated) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _handlePress,
      mini: widget.mini,
      backgroundColor: DesignSystem.primary,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 0.785, // 45 degrees in radians
            child: Icon(
              _isRotated && widget.rotatedIcon != null ? widget.rotatedIcon : widget.icon,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

/// Speed Dial FAB with multiple actions
class SpeedDialFAB extends StatefulWidget {
  const SpeedDialFAB({
    super.key,
    required this.icon,
    required this.actions,
    this.openIcon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final List<SpeedDialAction> actions;
  final IconData? openIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? DesignSystem.primary;
    final fgColor = widget.foregroundColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...List.generate(widget.actions.length, (index) {
          final reversedIndex = widget.actions.length - 1 - index;
          return _buildSpeedDialItem(
            widget.actions[reversedIndex],
            reversedIndex,
            theme,
          );
        }).reversed,
        SizedBox(height: _isOpen ? 16 : 0),
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0.0, // 45 degrees
            duration: const Duration(milliseconds: 250),
            child: Icon(
              _isOpen && widget.openIcon != null ? widget.openIcon : widget.icon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialItem(
    SpeedDialAction action,
    int index,
    ThemeData theme,
  ) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.value == 0.0) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: animation.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (action.label != null) ...[
                    Material(
                      color: theme.colorScheme.surface,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingMD,
                          vertical: DesignSystem.spacingXS,
                        ),
                        child: Text(
                          action.label!,
                          style: DesignSystem.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  FloatingActionButton.small(
                    onPressed: () {
                      action.onPressed();
                      _toggle();
                    },
                    backgroundColor: action.backgroundColor ?? theme.colorScheme.secondaryContainer,
                    foregroundColor: action.foregroundColor ?? theme.colorScheme.onSecondaryContainer,
                    heroTag: action.label ?? 'speed_dial_$index',
                    child: Icon(action.icon),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Action for SpeedDialFAB
class SpeedDialAction {
  const SpeedDialAction({
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
}

/// Morphing FAB that transitions between states
class MorphingFAB extends StatefulWidget {
  const MorphingFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.expandedIcon,
    this.label,
    this.isExpanded = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final IconData? expandedIcon;
  final String? label;
  final bool isExpanded;

  @override
  State<MorphingFAB> createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MorphingFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isExpanded = _controller.value > 0.5;
        
        return FloatingActionButton.extended(
          onPressed: widget.onPressed,
          backgroundColor: DesignSystem.primary,
          icon: Icon(
            isExpanded && widget.expandedIcon != null ? widget.expandedIcon : widget.icon,
            color: Colors.white,
          ),
          label: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: widget.label != null && _controller.value > 0.3
                ? Text(widget.label!, style: const TextStyle(color: Colors.white))
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

/// Pulsing FAB with attention-grabbing animation
class PulsingFAB extends StatefulWidget {
  const PulsingFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.mini = false,
    this.pulseColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool mini;
  final Color? pulseColor;

  @override
  State<PulsingFAB> createState() => _PulsingFABState();
}

class _PulsingFABState extends State<PulsingFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pulseColor = widget.pulseColor ?? DesignSystem.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: (widget.mini ? 40 : 56) * (1 + _controller.value * 0.5),
              height: (widget.mini ? 40 : 56) * (1 + _controller.value * 0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pulseColor.withAlpha((255 * 0.3 * (1 - _controller.value)).toInt()),
              ),
            ),
            // FAB
            FloatingActionButton(
              onPressed: widget.onPressed,
              mini: widget.mini,
              backgroundColor: pulseColor,
              child: Icon(widget.icon, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}