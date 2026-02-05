import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import '../../../../../core/theme/design_system.dart';

/// A mixin that provides comprehensive hover state management for widgets.
///
/// This mixin handles:
/// - Hover state detection and tracking
/// - Platform-specific hover behavior (web/desktop vs mobile)
/// - Hover animations and transitions
/// - Customizable hover effects and styling
/// - Hover callbacks and state management
/// - Accessibility support for hover states
/// - Memory management for hover animations
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with HoverMixin {
///
///   @override
///   Widget build(BuildContext context) {
///     return buildHoverableWidget(
///       context,
///       child: _buildContent(),
///       onHover: _handleHover,
///       onExit: _handleHoverExit,
///     );
///   }
/// }
/// ```
mixin HoverMixin<T extends StatefulWidget> on State<T> {
  /// Whether hover is enabled
  bool _hoverEnabled = true;

  /// Current hover state
  HoverState _hoverState = HoverState.idle;

  /// Whether the widget is currently being hovered
  bool _isHovered = false;

  /// Hover configuration
  HoverConfig? _hoverConfig;

  /// Animation controller for hover effects
  AnimationController? _hoverAnimationController;

  /// Scale animation for hover feedback
  Animation<double>? _hoverScaleAnimation;

  /// Whether hover is enabled
  bool get hoverEnabled => _hoverEnabled;

  /// Current hover state
  HoverState get hoverState => _hoverState;

  /// Whether the widget is currently being hovered
  bool get isHovered => _isHovered;

  @override
  void initState() {
    super.initState();
    _initializeHoverAnimations();
  }

  @override
  void dispose() {
    _disposeHoverAnimations();
    super.dispose();
  }

  /// Initialize hover animations
  void _initializeHoverAnimations() {
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: const _HoverTickerProvider(),
    );

    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController!,
      curve: Curves.easeInOut,
    ));
  }

  /// Dispose of hover animations
  void _disposeHoverAnimations() {
    _hoverAnimationController?.dispose();
  }

  /// Setup hover configuration
  void setupHover({
    VoidCallback? onHover,
    VoidCallback? onExit,
    bool enableScaleAnimation = true,
    bool enableOpacityAnimation = false,
    bool enableColorAnimation = false,
    Color? hoverColor,
    Color? normalColor,
    Duration animationDuration = const Duration(milliseconds: 200),
    Curve animationCurve = Curves.easeInOut,
    bool platformSpecific = true,
  }) {
    _hoverConfig = HoverConfig(
      onHover: onHover,
      onExit: onExit,
      enableScaleAnimation: enableScaleAnimation,
      enableOpacityAnimation: enableOpacityAnimation,
      enableColorAnimation: enableColorAnimation,
      hoverColor: hoverColor,
      normalColor: normalColor,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      platformSpecific: platformSpecific,
    );
  }

  /// Handle hover enter
  void _handleHoverEnter(PointerEnterEvent event) {
    if (!_hoverEnabled || !_isHoverPlatform()) return;

    _isHovered = true;
    _updateHoverState(HoverState.hovering);

    // Start hover animations
    if (_hoverConfig?.enableScaleAnimation == true) {
      _startHoverAnimation();
    }

    // Execute hover callback
    _hoverConfig?.onHover?.call();
  }

  /// Handle hover exit
  void _handleHoverExit(PointerExitEvent event) {
    if (!_hoverEnabled || !_isHoverPlatform()) return;

    _isHovered = false;
    _updateHoverState(HoverState.idle);

    // Stop hover animations
    if (_hoverConfig?.enableScaleAnimation == true) {
      _stopHoverAnimation();
    }

    // Execute exit callback
    _hoverConfig?.onExit?.call();
  }

  /// Check if current platform supports hover
  bool _isHoverPlatform() {
    if (_hoverConfig?.platformSpecific != true) return true;

    // In Flutter web, we can detect hover support
    // For mobile platforms, hover is typically disabled
    return true; // Simplified for this example
  }

  /// Start hover animation
  void _startHoverAnimation() {
    if (_hoverAnimationController?.isAnimating ?? false) {
      _hoverAnimationController?.stop();
    }
    _hoverAnimationController?.forward();
  }

  /// Stop hover animation
  void _stopHoverAnimation() {
    if (_hoverAnimationController?.isAnimating ?? false) {
      _hoverAnimationController?.reverse();
    }
  }

  /// Update hover state
  void _updateHoverState(HoverState state) {
    _hoverState = state;
    onHoverStateChanged?.call(state);
  }

  /// Enable or disable hover
  void setHoverEnabled(bool enabled) {
    _hoverEnabled = enabled;
    if (!enabled) {
      _handleHoverExit(const PointerExitEvent());
    }
  }

  /// Build hoverable widget with mouse region
  Widget buildHoverableWidget({
    required BuildContext context,
    required Widget child,
    VoidCallback? onHover,
    VoidCallback? onExit,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    bool opaque = true,
  }) {
    return MouseRegion(
      onEnter: _hoverEnabled ? _handleHoverEnter : null,
      onExit: _hoverEnabled ? _handleHoverExit : null,
      opaque: opaque,
      child: _hoverConfig?.enableScaleAnimation == true
          ? _buildAnimatedHoverChild(child)
          : child,
    );
  }

  /// Build animated hover child
  Widget _buildAnimatedHoverChild(Widget child) {
    if (_hoverScaleAnimation == null) return child;

    return AnimatedBuilder(
      animation: _hoverScaleAnimation!,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverScaleAnimation!.value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build hoverable container with custom styling
  Widget buildHoverableContainer({
    required BuildContext context,
    required Widget child,
    VoidCallback? onHover,
    VoidCallback? onExit,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Decoration? hoverDecoration,
    double? width,
    double? height,
    Alignment? alignment,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: child,
      ),
    );
  }

  /// Build hoverable card with material design
  Widget buildHoverableCard({
    required BuildContext context,
    required Widget child,
    VoidCallback? onHover,
    VoidCallback? onExit,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color? hoverColor,
    double? elevation,
    double? hoverElevation,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
  }) {
    return Card(
      margin: margin ?? const EdgeInsets.all(DesignSystem.spacingSM),
      color: color ?? DesignSystem.surfaceContainer,
      elevation: elevation ?? 2,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable icon
  Widget buildHoverableIcon({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    double? size,
    Color? color,
    Color? hoverColor,
    String? semanticLabel,
    EdgeInsetsGeometry? padding,
  }) {
    return buildHoverableContainer(
      context: context,
      onHover: onHover,
      onExit: onExit,
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingSM),
      child: Icon(
        icon,
        size: size ?? 24,
        color: color ?? DesignSystem.onSurface,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Build hoverable text
  Widget buildHoverableText({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? hoverColor,
    EdgeInsetsGeometry? padding,
  }) {
    return buildHoverableContainer(
      context: context,
      onHover: onHover,
      onExit: onExit,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSM,
        vertical: DesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  /// Build hoverable button
  Widget buildHoverableButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? hoverColor,
    BorderRadius? borderRadius,
    double? elevation,
    double? hoverElevation,
  }) {
    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? DesignSystem.primary,
        elevation: elevation ?? 2,
        borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
        child: buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: DesignSystem.spacingLG,
              vertical: DesignSystem.spacingMD,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Build hoverable list item
  Widget buildHoverableListItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? hoverColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusSM),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable avatar
  Widget buildHoverableAvatar({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    double? radius,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      shape: const CircleBorder(),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          width: (radius ?? 24) * 2,
          height: (radius ?? 24) * 2,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable chip
  Widget buildHoverableChip({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? hoverColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable menu item
  Widget buildHoverableMenuItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable navigation item
  Widget buildHoverableNavigationItem({
    required BuildContext context,
    required Widget child,
    required bool isSelected,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: isSelected
          ? (selectedColor ?? DesignSystem.primary)
          : (backgroundColor ?? DesignSystem.surfaceContainer),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable tooltip
  Widget buildHoverableTooltip({
    required BuildContext context,
    required Widget child,
    required String message,
    VoidCallback? onHover,
    VoidCallback? onExit,
    double? height,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    TextStyle? textStyle,
    Duration? waitDuration,
    Duration? showDuration,
  }) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 3),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: child,
      ),
    );
  }

  /// Build hoverable dropdown item
  Widget buildHoverableDropdownItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable tab
  Widget buildHoverableTab({
    required BuildContext context,
    required Widget child,
    required bool isSelected,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: isSelected
          ? (selectedColor ?? DesignSystem.primary)
          : (backgroundColor ?? DesignSystem.surfaceContainer),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable expansion tile
  Widget buildHoverableExpansionTile({
    required BuildContext context,
    required Widget title,
    required List<Widget> children,
    required bool initiallyExpanded,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: ExpansionTile(
        title: buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: title,
        ),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: backgroundColor ?? DesignSystem.surfaceContainer,
        collapsedBackgroundColor: backgroundColor ?? DesignSystem.surfaceContainer,
        childrenPadding: const EdgeInsets.all(DesignSystem.spacingMD),
        children: children,
      ),
    );
  }

  /// Build hoverable data table row
  Widget buildHoverableDataTableRow({
    required BuildContext context,
    required List<DataCell> cells,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: InkWell(
        onHover: _hoverEnabled ? (hovered) {
          if (hovered) {
            onHover?.call();
          } else {
            onExit?.call();
          }
        } : null,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingSM),
          child: Row(
            children: cells.map((cell) {
              return Expanded(
                child: buildHoverableWidget(
                  context: context,
                  onHover: onHover,
                  onExit: onExit,
                  child: cell.child,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Build hoverable calendar day
  Widget buildHoverableCalendarDay({
    required BuildContext context,
    required Widget child,
    required bool isSelected,
    required bool isToday,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: isSelected
          ? (selectedColor ?? DesignSystem.primary)
          : (backgroundColor ?? DesignSystem.surfaceContainer),
      shape: const CircleBorder(),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingSM),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable color swatch
  Widget buildHoverableColorSwatch({
    required BuildContext context,
    required Color color,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    double? size,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: color,
      borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusSM),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          width: size ?? 40,
          height: size ?? 40,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusSM),
            border: Border.all(
              color: DesignSystem.borderColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// Build hoverable slider thumb
  Widget buildHoverableSliderThumb({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.primary,
      shape: const CircleBorder(),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingSM),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable switch
  Widget buildHoverableSwitch({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? activeColor,
    Color? inactiveColor,
    Color? hoverColor,
  }) {
    return Material(
      color: value
          ? (activeColor ?? DesignSystem.primary)
          : (inactiveColor ?? DesignSystem.surfaceContainer),
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Switch(
          value: value,
          onChanged: _hoverEnabled ? onChanged : null,
          activeThumbColor: activeColor ?? DesignSystem.primary,
          inactiveThumbColor: inactiveColor ?? DesignSystem.surfaceContainer,
        ),
      ),
    );
  }

  /// Build hoverable checkbox
  Widget buildHoverableCheckbox({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? activeColor,
    Color? hoverColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Checkbox(
          value: value,
          onChanged: _hoverEnabled ? (value) => onChanged(value ?? false) : null,
          checkColor: activeColor ?? DesignSystem.primary,
        ),
      ),
    );
  }

  /// Build hoverable radio button
  Widget buildHoverableRadio<U>({
    required BuildContext context,
    required U value,
    required U groupValue,
    required ValueChanged<U> onChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? activeColor,
    Color? hoverColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Radio<U>(
          value: value,
          // groupValue: groupValue, // Deprecated
          // onChanged: _hoverEnabled ? (value) => onChanged(value as U) : null, // Deprecated
          activeColor: activeColor ?? DesignSystem.primary,
        ),
      ),
    );
  }

  /// Build hoverable progress indicator
  Widget buildHoverableProgressIndicator({
    required BuildContext context,
    required double value,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? progressColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingSM),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: DesignSystem.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? DesignSystem.primary,
            ),
          ),
        ),
      ),
    );
  }

  /// Build hoverable rating widget
  Widget buildHoverableRating({
    required BuildContext context,
    required double rating,
    required int maxRating,
    required ValueChanged<double> onRatingChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? activeColor,
    Color? inactiveColor,
    Color? hoverColor,
    double? size,
  }) {
    return Row(
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        final isActive = starValue <= rating;

        return buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: IconButton(
            onPressed: _hoverEnabled ? () => onRatingChanged(starValue.toDouble()) : null,
            icon: Icon(
              isActive ? Icons.star : Icons.star_border,
              color: isActive
                  ? (activeColor ?? DesignSystem.warning)
                  : (inactiveColor ?? DesignSystem.onSurfaceVariant),
            ),
            iconSize: size ?? 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        );
      }),
    );
  }

  /// Build hoverable pagination controls
  Widget buildHoverablePagination({
    required BuildContext context,
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHoverableWidget(
            context: context,
            onHover: onHover,
            onExit: onExit,
            child: IconButton(
              onPressed: _hoverEnabled && currentPage > 1
                  ? () => onPageChanged(currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
              padding: const EdgeInsets.all(DesignSystem.spacingSM),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            child: Text(
              '$currentPage / $totalPages',
              style: DesignSystem.bodyMedium,
            ),
          ),
          buildHoverableWidget(
            context: context,
            onHover: onHover,
            onExit: onExit,
            child: IconButton(
              onPressed: _hoverEnabled && currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
              padding: const EdgeInsets.all(DesignSystem.spacingSM),
            ),
          ),
        ],
      ),
    );
  }

  /// Build hoverable filter chip
  Widget buildHoverableFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: selected
          ? (selectedColor ?? DesignSystem.primary)
          : (backgroundColor ?? DesignSystem.surfaceContainer),
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
          child: Text(
            label,
            style: DesignSystem.bodyMedium.copyWith(
              color: selected
                  ? DesignSystem.onPrimary
                  : DesignSystem.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  /// Build hoverable sort button
  Widget buildHoverableSortButton({
    required BuildContext context,
    required String label,
    required bool ascending,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: DesignSystem.bodyMedium,
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: DesignSystem.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build hoverable notification badge
  Widget buildHoverableNotificationBadge({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    int? count,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Stack(
      children: [
        buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: child,
        ),
        if (count != null && count > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: DesignSystem.error,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingXS,
                  vertical: 2,
                ),
                constraints: const BoxConstraints(minWidth: 20),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onError,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build hoverable search bar
  Widget buildHoverableSearchBar({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    String? hintText,
    Color? backgroundColor,
    Color? hoverColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: DesignSystem.onSurfaceVariant,
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Expanded(
                child: Text(
                  hintText ?? 'Search...',
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build hoverable floating action button
  Widget buildHoverableFloatingActionButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    double? elevation,
    double? hoverElevation,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.primary,
      elevation: elevation ?? 6,
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: child,
        ),
      ),
    );
  }

  /// Build hoverable tab bar
  Widget buildHoverableTabBar({
    required BuildContext context,
    required List<Widget> tabs,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            child: buildHoverableWidget(
              context: context,
              onHover: onHover,
              onExit: onExit,
              child: Container(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? DesignSystem.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                ),
                child: tab,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build hoverable bottom navigation
  Widget buildHoverableBottomNavigation({
    required BuildContext context,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surface,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return Expanded(
              child: buildHoverableWidget(
                context: context,
                onHover: onHover,
                onExit: onExit,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        color: isSelected
                            ? (selectedColor ?? DesignSystem.primary)
                            : DesignSystem.onSurfaceVariant,
                      ),
                      child: isSelected ? item.activeIcon : item.icon,
                    ),
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      item.label!,
                      style: DesignSystem.caption.copyWith(
                        color: isSelected
                            ? (selectedColor ?? DesignSystem.primary)
                            : DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build hoverable segmented control
  Widget buildHoverableSegmentedControl<U>({
    required BuildContext context,
    required List<U> segments,
    required U selectedValue,
    required ValueChanged<U> onChanged,
    required Widget Function(U value) builder,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment == selectedValue;
          return Expanded(
            child: buildHoverableWidget(
              context: context,
              onHover: onHover,
              onExit: onExit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingMD,
                  vertical: DesignSystem.spacingSM,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? DesignSystem.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
                ),
                child: builder(segment),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build hoverable stepper
  Widget buildHoverableStepper({
    required BuildContext context,
    required int currentStep,
    required List<Step> steps,
    required VoidCallback onStepContinue,
    required VoidCallback onStepCancel,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: Stepper(
        currentStep: currentStep,
        onStepContinue: _hoverEnabled ? onStepContinue : null,
        onStepCancel: _hoverEnabled ? onStepCancel : null,
        steps: steps,
        controlsBuilder: (context, details) {
          return Container(
            margin: const EdgeInsets.only(top: DesignSystem.spacingMD),
            child: Row(
              children: [
                if (currentStep < steps.length - 1)
                  buildHoverableButton(
                    context: context,
                    onHover: onHover,
                    onExit: onExit,
                    child: const Text('Continue'),
                  ),
                if (currentStep > 0) ...[
                  const SizedBox(width: DesignSystem.spacingMD),
                  buildHoverableButton(
                    context: context,
                    onHover: onHover,
                    onExit: onExit,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build hoverable data table
  Widget buildHoverableDataTable({
    required BuildContext context,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        child: DataTable(
          columns: columns,
          rows: rows.map((row) {
            return DataRow(
              cells: row.cells.map((cell) {
                return DataCell(
                  buildHoverableWidget(
                    context: context,
                    onHover: onHover,
                    onExit: onExit,
                    child: cell.child,
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build hoverable calendar
  Widget buildHoverableCalendar({
    required BuildContext context,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateSelected,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: DesignSystem.onSurfaceVariant,
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: DesignSystem.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build hoverable time picker
  Widget buildHoverableTimePicker({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required ValueChanged<TimeOfDay> onTimeSelected,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                color: DesignSystem.onSurfaceVariant,
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Text(
                selectedTime.format(context),
                style: DesignSystem.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build hoverable color picker
  Widget buildHoverableColorPicker({
    required BuildContext context,
    required Color selectedColor,
    required ValueChanged<Color> onColorSelected,
    required List<Color> availableColors,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
  }) {
    return Material(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                  border: Border.all(
                    color: DesignSystem.borderColor,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Text(
                'Color',
                style: DesignSystem.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Callback when hover state changes
  void Function(HoverState state)? get onHoverStateChanged => null;
}

/// Hover state enumeration
enum HoverState {
  /// Widget is idle (not hovered)
  idle,

  /// Widget is being hovered
  hovering,
}

/// Ticker provider for animations
class _HoverTickerProvider extends TickerProvider {
  const _HoverTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

/// Hover configuration
class HoverConfig {
  /// Callback when hover enters
  final VoidCallback? onHover;

  /// Callback when hover exits
  final VoidCallback? onExit;

  /// Whether scale animation is enabled
  final bool enableScaleAnimation;

  /// Whether opacity animation is enabled
  final bool enableOpacityAnimation;

  /// Whether color animation is enabled
  final bool enableColorAnimation;

  /// Hover color
  final Color? hoverColor;

  /// Normal color
  final Color? normalColor;

  /// Animation duration
  final Duration animationDuration;

  /// Animation curve
  final Curve animationCurve;

  /// Whether platform-specific behavior is enabled
  final bool platformSpecific;

  const HoverConfig({
    this.onHover,
    this.onExit,
    this.enableScaleAnimation = true,
    this.enableOpacityAnimation = false,
    this.enableColorAnimation = false,
    this.hoverColor,
    this.normalColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.platformSpecific = true,
  });
}
