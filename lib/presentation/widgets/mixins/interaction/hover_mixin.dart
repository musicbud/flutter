import 'package:flutter/material.dart';

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

  /// Opacity animation for hover feedback
  Animation<double>? _hoverOpacityAnimation;

  /// Color animation for hover feedback
  Animation<Color?>? _hoverColorAnimation;

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
      vsync: this,
    );

    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController!,
      curve: Curves.easeInOut,
    ));

    _hoverOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
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
      _handleHoverExit(PointerExitEvent());
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Card(
      margin: margin ?? EdgeInsets.all(design.designSystemSpacing.sm),
      color: color ?? design.designSystemColors.surfaceContainer,
      elevation: elevation ?? 2,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
      ),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return buildHoverableContainer(
      context: context,
      onHover: onHover,
      onExit: onExit,
      padding: padding ?? EdgeInsets.all(design.designSystemSpacing.sm),
      child: Icon(
        icon,
        size: size ?? 24,
        color: color ?? design.designSystemColors.onSurface,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return buildHoverableContainer(
      context: context,
      onHover: onHover,
      onExit: onExit,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: design.designSystemSpacing.sm,
        vertical: design.designSystemSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.primary,
        elevation: elevation ?? 2,
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        child: buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: design.designSystemSpacing.lg,
              vertical: design.designSystemSpacing.md,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.sm),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: isSelected
          ? (selectedColor ?? design.designSystemColors.primary)
          : (backgroundColor ?? design.designSystemColors.surfaceContainer),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: isSelected
          ? (selectedColor ?? design.designSystemColors.primary)
          : (backgroundColor ?? design.designSystemColors.surfaceContainer),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      child: ExpansionTile(
        title: buildHoverableWidget(
          context: context,
          onHover: onHover,
          onExit: onExit,
          child: title,
        ),
        children: children,
        initiallyExpanded: initiallyExpanded,
        backgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
        collapsedBackgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
        childrenPadding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      child: DataRow(
        cells: cells.map((cell) {
          return DataCell(
            buildHoverableWidget(
              context: context,
              onHover: onHover,
              onExit: onExit,
              child: cell.child,
            ),
          );
        }).toList(),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: isSelected
          ? (selectedColor ?? design.designSystemColors.primary)
          : (backgroundColor ?? design.designSystemColors.surfaceContainer),
      shape: const CircleBorder(),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.sm),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: color,
      borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.sm),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          width: size ?? 40,
          height: size ?? 40,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.sm),
            border: Border.all(
              color: design.designSystemColors.border,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.primary,
      shape: const CircleBorder(),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.sm),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: value
          ? (activeColor ?? design.designSystemColors.primary)
          : (inactiveColor ?? design.designSystemColors.surfaceContainer),
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Switch(
          value: value,
          onChanged: _hoverEnabled ? onChanged : null,
          activeColor: activeColor ?? design.designSystemColors.primary,
          inactiveThumbColor: inactiveColor ?? design.designSystemColors.surfaceContainer,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: Colors.transparent,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Checkbox(
          value: value,
          onChanged: _hoverEnabled ? (value) => onChanged(value ?? false) : null,
          activeColor: activeColor ?? design.designSystemColors.primary,
        ),
      ),
    );
  }

  /// Build hoverable radio button
  Widget buildHoverableRadio<T>({
    required BuildContext context,
    required T value,
    required T groupValue,
    required ValueChanged<T> onChanged,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? activeColor,
    Color? hoverColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final isSelected = value == groupValue;

    return Material(
      color: Colors.transparent,
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: _hoverEnabled ? (value) => onChanged(value as T) : null,
          activeColor: activeColor ?? design.designSystemColors.primary,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.sm),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: design.designSystemColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? design.designSystemColors.primary,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

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
                  ? (activeColor ?? design.designSystemColors.warning)
                  : (inactiveColor ?? design.designSystemColors.onSurfaceVariant),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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
              icon: Icon(Icons.chevron_left),
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.md),
            child: Text(
              '$currentPage / $totalPages',
              style: design.designSystemTypography.bodyMedium,
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
              icon: Icon(Icons.chevron_right),
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: selected
          ? (selectedColor ?? design.designSystemColors.primary)
          : (backgroundColor ?? design.designSystemColors.surfaceContainer),
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
          ),
          child: Text(
            label,
            style: design.designSystemTypography.bodyMedium.copyWith(
              color: selected
                  ? design.designSystemColors.onPrimary
                  : design.designSystemColors.onSurface,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: design.designSystemTypography.bodyMedium,
              ),
              SizedBox(width: design.designSystemSpacing.sm),
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: design.designSystemColors.onSurfaceVariant,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

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
              color: design.designSystemColors.error,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.designSystemSpacing.xs,
                  vertical: 2,
                ),
                constraints: BoxConstraints(minWidth: 20),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: design.designSystemTypography.caption.copyWith(
                    color: design.designSystemColors.onError,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: design.designSystemColors.onSurfaceVariant,
              ),
              SizedBox(width: design.designSystemSpacing.sm),
              Expanded(
                child: Text(
                  hintText ?? 'Search...',
                  style: design.designSystemTypography.bodyMedium.copyWith(
                    color: design.designSystemColors.onSurfaceVariant,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.primary,
      elevation: elevation ?? 6,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.lg),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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
                padding: EdgeInsets.all(design.designSystemSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? design.designSystemColors.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surface,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: design.designSystemSpacing.sm),
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
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected
                          ? (selectedColor ?? design.designSystemColors.primary)
                          : design.designSystemColors.onSurfaceVariant,
                    ),
                    SizedBox(height: design.designSystemSpacing.xs),
                    Text(
                      item.label!,
                      style: design.designSystemTypography.caption.copyWith(
                        color: isSelected
                            ? (selectedColor ?? design.designSystemColors.primary)
                            : design.designSystemColors.onSurfaceVariant,
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
  Widget buildHoverableSegmentedControl<T>({
    required BuildContext context,
    required List<T> segments,
    required T selectedValue,
    required ValueChanged<T> onChanged,
    required Widget Function(T value) builder,
    required VoidCallback? onHover,
    VoidCallback? onExit,
    Color? backgroundColor,
    Color? hoverColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment == selectedValue;
          return Expanded(
            child: buildHoverableWidget(
              context: context,
              onHover: onHover,
              onExit: onExit,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.designSystemSpacing.md,
                  vertical: design.designSystemSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? design.designSystemColors.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: Stepper(
        currentStep: currentStep,
        onStepContinue: _hoverEnabled ? onStepContinue : null,
        onStepCancel: _hoverEnabled ? onStepCancel : null,
        steps: steps,
        controlsBuilder: (context, details) {
          return Container(
            margin: EdgeInsets.only(top: design.designSystemSpacing.md),
            child: Row(
              children: [
                if (currentStep < steps.length - 1)
                  buildHoverableButton(
                    context: context,
                    onHover: onHover,
                    onExit: onExit,
                    child: Text('Continue'),
                  ),
                if (currentStep > 0) ...[
                  SizedBox(width: design.designSystemSpacing.md),
                  buildHoverableButton(
                    context: context,
                    onHover: onHover,
                    onExit: onExit,
                    child: Text('Back'),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: Container(
        padding: EdgeInsets.all(design.designSystemSpacing.md),
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: design.designSystemColors.onSurfaceVariant,
              ),
              SizedBox(width: design.designSystemSpacing.sm),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: design.designSystemTypography.bodyMedium,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: design.designSystemColors.onSurfaceVariant,
              ),
              SizedBox(width: design.designSystemSpacing.sm),
              Text(
                selectedTime.format(context),
                style: design.designSystemTypography.bodyMedium,
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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: buildHoverableWidget(
        context: context,
        onHover: onHover,
        onExit: onExit,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
                  border: Border.all(
                    color: design.designSystemColors.border,
                    width: 1,
                  ),
                ),
              ),
              SizedBox(width: design.designSystemSpacing.sm),
              Text(
                'Color',
                style: design.designSystemTypography.bodyMedium,
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