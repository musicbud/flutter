import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/// A mixin that provides comprehensive tap and gesture handling for widgets.
///
/// This mixin handles:
/// - Tap gesture detection and callbacks
/// - Haptic feedback for user interactions
/// - Button press animations and visual feedback
/// - Debouncing and throttling for rapid taps
/// - Long press and double tap detection
/// - Accessibility support for interactions
/// - Customizable tap behavior and styling
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with TapHandlerMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     setupTapHandler(
///       onTap: _handleTap,
///       onLongPress: _handleLongPress,
///       onDoubleTap: _handleDoubleTap,
///       enableHapticFeedback: true,
///     );
///   }
///
///   void _handleTap() {
///     // Handle tap
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return buildTappableWidget(
///       context,
///       child: _buildContent(),
///       onTap: _handleTap,
///     );
///   }
/// }
/// ```
mixin TapHandlerMixin<T extends StatefulWidget> on State<T> {
  /// Whether tap handling is enabled
  bool _tapHandlingEnabled = true;

  /// Whether haptic feedback is enabled
  bool _hapticFeedbackEnabled = true;

  /// Whether visual feedback is enabled
  bool _visualFeedbackEnabled = true;

  /// Current tap state
  TapState _tapState = TapState.idle;

  /// Tap configuration
  TapConfig? _tapConfig;

  /// Debounce timer for preventing rapid taps
  Timer? _debounceTimer;

  /// Animation controller for tap feedback
  AnimationController? _tapAnimationController;

  /// Scale animation for tap feedback
  Animation<double>? _tapScaleAnimation;

  /// Whether the widget is currently pressed
  bool _isPressed = false;

  /// Whether tap handling is enabled
  bool get tapHandlingEnabled => _tapHandlingEnabled;

  /// Whether haptic feedback is enabled
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;

  /// Whether visual feedback is enabled
  bool get visualFeedbackEnabled => _visualFeedbackEnabled;

  /// Current tap state
  TapState get tapState => _tapState;

  /// Whether the widget is currently pressed
  bool get isPressed => _isPressed;

  @override
  void initState() {
    super.initState();
    _initializeTapAnimations();
  }

  @override
  void dispose() {
    _disposeTapAnimations();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Initialize tap animations
  void _initializeTapAnimations() {
    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this as TickerProvider,
    );

    _tapScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _tapAnimationController!,
      curve: Curves.easeInOut,
    ));
  }

  /// Dispose of tap animations
  void _disposeTapAnimations() {
    _tapAnimationController?.dispose();
  }

  /// Setup tap handler with configuration
  void setupTapHandler({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    VoidCallback? onTapDown,
    VoidCallback? onTapUp,
    VoidCallback? onTapCancel,
    bool enableHapticFeedback = true,
    bool enableVisualFeedback = true,
    bool enableDebouncing = false,
    Duration debounceDuration = const Duration(milliseconds: 300),
    HapticFeedbackType hapticType = HapticFeedbackType.light,
    Duration longPressDuration = const Duration(milliseconds: 500),
    bool enableLongPress = true,
    bool enableDoubleTap = false,
  }) {
    _hapticFeedbackEnabled = enableHapticFeedback;
    _visualFeedbackEnabled = enableVisualFeedback;

    _tapConfig = TapConfig(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      enableDebouncing: enableDebouncing,
      debounceDuration: debounceDuration,
      hapticType: hapticType,
      longPressDuration: longPressDuration,
      enableLongPress: enableLongPress,
      enableDoubleTap: enableDoubleTap,
    );
  }

  /// Handle tap gesture
  void _handleTap() {
    if (!_tapHandlingEnabled || _tapConfig?.onTap == null) return;

    // Check for debouncing
    if (_tapConfig?.enableDebouncing == true) {
      if (_debounceTimer?.isActive ?? false) return;

      _debounceTimer = Timer(_tapConfig!.debounceDuration, () {});
    }

    // Provide haptic feedback
    if (_hapticFeedbackEnabled) {
      _triggerHapticFeedback();
    }

    // Execute tap callback
    _tapConfig!.onTap!();

    // Update tap state
    _updateTapState(TapState.tapped);
  }

  /// Handle long press gesture
  void _handleLongPress() {
    if (!_tapHandlingEnabled || _tapConfig?.onLongPress == null) return;

    // Provide haptic feedback
    if (_hapticFeedbackEnabled) {
      _triggerHapticFeedback(HapticFeedbackType.medium);
    }

    // Execute long press callback
    _tapConfig!.onLongPress!();

    // Update tap state
    _updateTapState(TapState.longPressed);
  }

  /// Handle double tap gesture
  void _handleDoubleTap() {
    if (!_tapHandlingEnabled || _tapConfig?.onDoubleTap == null) return;

    // Provide haptic feedback
    if (_hapticFeedbackEnabled) {
      _triggerHapticFeedback(HapticFeedbackType.light);
    }

    // Execute double tap callback
    _tapConfig!.onDoubleTap!();

    // Update tap state
    _updateTapState(TapState.doubleTapped);
  }

  /// Handle tap down gesture
  void _handleTapDown(TapDownDetails details) {
    if (!_tapHandlingEnabled) return;

    _isPressed = true;
    _updateTapState(TapState.pressed);

    // Start visual feedback animation
    if (_visualFeedbackEnabled) {
      _startPressAnimation();
    }

    // Execute tap down callback
    _tapConfig?.onTapDown?.call();
  }

  /// Handle tap up gesture
  void _handleTapUp(TapUpDetails details) {
    if (!_tapHandlingEnabled) return;

    _isPressed = false;

    // Stop visual feedback animation
    if (_visualFeedbackEnabled) {
      _stopPressAnimation();
    }

    // Execute tap up callback
    _tapConfig?.onTapUp?.call();
  }

  /// Handle tap cancel gesture
  void _handleTapCancel() {
    if (!_tapHandlingEnabled) return;

    _isPressed = false;
    _updateTapState(TapState.idle);

    // Stop visual feedback animation
    if (_visualFeedbackEnabled) {
      _stopPressAnimation();
    }

    // Execute tap cancel callback
    _tapConfig?.onTapCancel?.call();
  }

  /// Trigger haptic feedback
  void _triggerHapticFeedback([HapticFeedbackType type = HapticFeedbackType.light]) {
    if (!_hapticFeedbackEnabled) return;

    try {
      switch (type) {
        case HapticFeedbackType.light:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selection:
          HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.vibrate:
          HapticFeedback.vibrate();
          break;
      }
    } catch (e) {
      // Haptic feedback may not be available on all platforms
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Start press animation
  void _startPressAnimation() {
    if (_tapAnimationController?.isAnimating ?? false) {
      _tapAnimationController?.stop();
    }
    _tapAnimationController?.forward();
  }

  /// Stop press animation
  void _stopPressAnimation() {
    if (_tapAnimationController?.isAnimating ?? false) {
      _tapAnimationController?.reverse();
    }
  }

  /// Update tap state
  void _updateTapState(TapState state) {
    _tapState = state;
    onTapStateChanged?.call(state);
  }

  /// Enable or disable tap handling
  void setTapHandlingEnabled(bool enabled) {
    _tapHandlingEnabled = enabled;
    if (!enabled) {
      _handleTapCancel();
    }
  }

  /// Enable or disable haptic feedback
  void setHapticFeedbackEnabled(bool enabled) {
    _hapticFeedbackEnabled = enabled;
  }

  /// Enable or disable visual feedback
  void setVisualFeedbackEnabled(bool enabled) {
    _visualFeedbackEnabled = enabled;
  }

  /// Build tappable widget with gesture detection
  Widget buildTappableWidget({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    bool excludeFromSemantics = false,
  }) {
    return GestureDetector(
      onTap: _tapHandlingEnabled ? (onTap ?? _handleTap) : null,
      onLongPress: (_tapHandlingEnabled && _tapConfig?.enableLongPress == true)
          ? (onLongPress ?? _handleLongPress)
          : null,
      onDoubleTap: (_tapHandlingEnabled && _tapConfig?.enableDoubleTap == true)
          ? (onDoubleTap ?? _handleDoubleTap)
          : null,
      onTapDown: _tapHandlingEnabled ? _handleTapDown : null,
      onTapUp: _tapHandlingEnabled ? _handleTapUp : null,
      onTapCancel: _tapHandlingEnabled ? _handleTapCancel : null,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      child: _visualFeedbackEnabled
          ? _buildAnimatedChild(child)
          : child,
    );
  }

  /// Build animated child for visual feedback
  Widget _buildAnimatedChild(Widget child) {
    if (_tapScaleAnimation == null) return child;

    return AnimatedBuilder(
      animation: _tapScaleAnimation!,
      builder: (context, child) {
        return Transform.scale(
          scale: _tapScaleAnimation!.value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build tappable container with custom styling
  Widget buildTappableContainer({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Decoration? pressedDecoration,
    double? width,
    double? height,
    Alignment? alignment,
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      child: buildTappableWidget(
        context: context,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        behavior: behavior,
        child: child,
      ),
    );
  }

  /// Build tappable card with material design
  Widget buildTappableCard({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color? pressedColor,
    double? elevation,
    double? pressedElevation,
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
      child: buildTappableWidget(
        context: context,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build tappable icon button
  Widget buildTappableIcon({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    double? size,
    Color? color,
    Color? pressedColor,
    String? semanticLabel,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return buildTappableContainer(
      context: context,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      padding: padding ?? EdgeInsets.all(design.designSystemSpacing.sm),
      child: Icon(
        icon,
        size: size ?? 24,
        color: color ?? design.designSystemColors.onSurface,
        semanticLabel: semanticLabel,
      ),
    );
  }

  /// Build tappable text with highlight effect
  Widget buildTappableText({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    Color? highlightColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return buildTappableContainer(
      context: context,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
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

  /// Build tappable list item
  Widget buildTappableListItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        onLongPress: (_tapHandlingEnabled && _tapConfig?.enableLongPress == true)
            ? onLongPress ?? _handleLongPress
            : null,
        splashColor: splashColor ?? design.designSystemColors.primary.withValues(alpha: 0.1),
        highlightColor: highlightColor ?? design.designSystemColors.primary.withValues(alpha: 0.05),
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.sm),
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build tappable button with custom styling
  Widget buildTappableButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? pressedBackgroundColor,
    BorderRadius? borderRadius,
    double? elevation,
    double? pressedElevation,
    bool enableScaleAnimation = true,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.primary,
        elevation: elevation ?? 2,
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        child: InkWell(
          onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
          onLongPress: (_tapHandlingEnabled && _tapConfig?.enableLongPress == true)
              ? onLongPress ?? _handleLongPress
              : null,
          onDoubleTap: (_tapHandlingEnabled && _tapConfig?.enableDoubleTap == true)
              ? onDoubleTap ?? _handleDoubleTap
              : null,
          borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: design.designSystemSpacing.lg,
              vertical: design.designSystemSpacing.md,
            ),
            child: enableScaleAnimation && _visualFeedbackEnabled
                ? _buildAnimatedChild(child)
                : child,
          ),
        ),
      ),
    );
  }

  /// Build tappable avatar/circular widget
  Widget buildTappableAvatar({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? radius,
    Color? backgroundColor,
    Color? pressedBackgroundColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        onLongPress: (_tapHandlingEnabled && _tapConfig?.enableLongPress == true)
            ? onLongPress ?? _handleLongPress
            : null,
        borderRadius: BorderRadius.circular(radius ?? 24),
        child: Container(
          width: (radius ?? 24) * 2,
          height: (radius ?? 24) * 2,
          alignment: Alignment.center,
          child: _visualFeedbackEnabled
              ? _buildAnimatedChild(child)
              : child,
        ),
      ),
    );
  }

  /// Build tappable chip/tag widget
  Widget buildTappableChip({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? pressedBackgroundColor,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        onLongPress: (_tapHandlingEnabled && _tapConfig?.enableLongPress == true)
            ? onLongPress ?? _handleLongPress
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.xl),
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
          ),
          child: _visualFeedbackEnabled
              ? _buildAnimatedChild(child)
              : child,
        ),
      ),
    );
  }

  /// Build tappable switch/toggle
  Widget buildTappableSwitch({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? inactiveColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: value
          ? (activeColor ?? design.designSystemColors.primary)
          : (inactiveColor ?? design.designSystemColors.surfaceContainer),
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? () => onChanged(!value) : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.sm),
          child: Icon(
            value ? Icons.toggle_on : Icons.toggle_off,
            color: value
                ? design.designSystemColors.onPrimary
                : design.designSystemColors.onSurfaceVariant,
            size: 32,
          ),
        ),
      ),
    );
  }

  /// Build tappable checkbox
  Widget buildTappableCheckbox({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? checkColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _tapHandlingEnabled ? () => onChanged(!value) : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.xs),
          child: Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            color: value
                ? (activeColor ?? design.designSystemColors.primary)
                : design.designSystemColors.onSurfaceVariant,
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Build tappable radio button
  Widget buildTappableRadio<U>({
    required BuildContext context,
    required U value,
    required U groupValue,
    required ValueChanged<U> onChanged,
    Color? activeColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final isSelected = value == groupValue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _tapHandlingEnabled ? () => onChanged(value) : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.sm),
          child: Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected
                ? (activeColor ?? design.designSystemColors.primary)
                : design.designSystemColors.onSurfaceVariant,
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Build tappable slider
  Widget buildTappableSlider({
    required BuildContext context,
    required double value,
    required ValueChanged<double> onChanged,
    double min = 0.0,
    double max = 1.0,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _tapHandlingEnabled ? () {
          // Handle tap on slider track to set value to 50%
          // This provides basic functionality for tapping on slider track
          onChanged(0.5);
        } : null,
        child: Slider(
          value: value,
          onChanged: _tapHandlingEnabled ? onChanged : null,
          min: min,
          max: max,
          activeColor: activeColor ?? design.designSystemColors.primary,
          inactiveColor: inactiveColor ?? design.designSystemColors.surfaceContainer,
          thumbColor: thumbColor ?? design.designSystemColors.primary,
        ),
      ),
    );
  }

  /// Build tappable dropdown
  Widget buildTappableDropdown<U>({
    required BuildContext context,
    required U value,
    required List<DropdownMenuItem<U>> items,
    required ValueChanged<U> onChanged,
    Color? backgroundColor,
    Color? pressedColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? () {
          // Show dropdown menu
          _showDropdownMenu(context, items, onChanged);
        } : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
            vertical: design.designSystemSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  items.firstWhere((item) => item.value == value).child.toString(),
                  style: design.designSystemTypography.bodyMedium,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: design.designSystemColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show dropdown menu
  void _showDropdownMenu<T>(
    BuildContext context,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T> onChanged,
  ) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Convert DropdownMenuItem to PopupMenuItem for showMenu
    final popupItems = items.map<PopupMenuItem<T>>((item) {
      return PopupMenuItem<T>(
        value: item.value,
        child: item.child,
      );
    }).toList();

    showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200, // Menu height
      ),
      items: popupItems,
    ).then((value) {
      if (value != null) {
        onChanged(value);
      }
    });
  }

  /// Build tappable segmented control
  Widget buildTappableSegmentedControl<U>({
    required BuildContext context,
    required List<U> segments,
    required U selectedValue,
    required ValueChanged<U> onChanged,
    required Widget Function(U value) builder,
    Color? backgroundColor,
    Color? selectedColor,
    Color? pressedColor,
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
            child: InkWell(
              onTap: _tapHandlingEnabled ? () => onChanged(segment) : null,
              borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
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

  /// Build tappable stepper
  Widget buildTappableStepper({
    required BuildContext context,
    required int currentStep,
    required List<Step> steps,
    required VoidCallback onStepContinue,
    required VoidCallback onStepCancel,
    Color? activeColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: Stepper(
        currentStep: currentStep,
        onStepContinue: _tapHandlingEnabled ? onStepContinue : null,
        onStepCancel: _tapHandlingEnabled ? onStepCancel : null,
        steps: steps,
        controlsBuilder: (context, details) {
          return Container(
            margin: EdgeInsets.only(top: design.designSystemSpacing.md),
            child: Row(
              children: [
                if (currentStep < steps.length - 1)
                  buildTappableButton(
                    context: context,
                    onTap: details.onStepContinue,
                    child: const Text('Continue'),
                  ),
                if (currentStep > 0) ...[
                  SizedBox(width: design.designSystemSpacing.md),
                  buildTappableButton(
                    context: context,
                    onTap: details.onStepCancel,
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

  /// Build tappable tab bar
  Widget buildTappableTabBar({
    required BuildContext context,
    required List<Widget> tabs,
    required int currentIndex,
    required ValueChanged<int> onTap,
    Color? backgroundColor,
    Color? selectedColor,
    Color? pressedColor,
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
            child: InkWell(
              onTap: _tapHandlingEnabled ? () => onTap(index) : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.designSystemSpacing.md,
                  vertical: design.designSystemSpacing.sm,
                ),
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

  /// Build tappable bottom navigation
  Widget buildTappableBottomNavigation({
    required BuildContext context,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
    Color? backgroundColor,
    Color? selectedColor,
    Color? pressedColor,
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
              child: InkWell(
                onTap: _tapHandlingEnabled ? () => onTap(index) : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? ((item.activeIcon ?? item.icon) as IconData? ?? Icons.home)
                          : (item.icon as IconData? ?? Icons.home),
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

  /// Build tappable floating action button
  Widget buildTappableFloatingActionButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
    double? elevation,
    double? pressedElevation,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.primary,
      elevation: elevation ?? 6,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.lg),
          child: _visualFeedbackEnabled
              ? _buildAnimatedChild(child)
              : child,
        ),
      ),
    );
  }

  /// Build tappable search bar
  Widget buildTappableSearchBar({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback? onTap,
    String? hintText,
    Color? backgroundColor,
    Color? pressedColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
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

  /// Build tappable notification badge
  Widget buildTappableNotificationBadge({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    int? count,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Stack(
      children: [
        buildTappableWidget(
          context: context,
          onTap: onTap,
          child: child,
        ),
        if (count != null && count > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: design.designSystemColors.error,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
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
          ),
      ],
    );
  }

  /// Build tappable progress indicator
  Widget buildTappableProgressIndicator({
    required BuildContext context,
    required double value,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
    Color? progressColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
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

  /// Build tappable rating widget
  Widget buildTappableRating({
    required BuildContext context,
    required double rating,
    required int maxRating,
    required ValueChanged<double> onRatingChanged,
    Color? activeColor,
    Color? inactiveColor,
    double? size,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Row(
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        final isActive = starValue <= rating;

        return InkWell(
          onTap: _tapHandlingEnabled ? () => onRatingChanged(starValue.toDouble()) : null,
          child: Icon(
            isActive ? Icons.star : Icons.star_border,
            color: isActive
                ? (activeColor ?? design.designSystemColors.warning)
                : (inactiveColor ?? design.designSystemColors.onSurfaceVariant),
            size: size ?? 24,
          ),
        );
      }),
    );
  }

  /// Build tappable pagination controls
  Widget buildTappablePagination({
    required BuildContext context,
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _tapHandlingEnabled && currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
            child: Container(
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
              child: Icon(
                Icons.chevron_left,
                color: currentPage > 1
                    ? design.designSystemColors.onSurface
                    : design.designSystemColors.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.md),
            child: Text(
              '$currentPage / $totalPages',
              style: design.designSystemTypography.bodyMedium,
            ),
          ),
          InkWell(
            onTap: _tapHandlingEnabled && currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
            child: Container(
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
              child: Icon(
                Icons.chevron_right,
                color: currentPage < totalPages
                    ? design.designSystemColors.onSurface
                    : design.designSystemColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build tappable filter chip
  Widget buildTappableFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? selectedColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: selected
          ? (selectedColor ?? design.designSystemColors.primary)
          : (backgroundColor ?? design.designSystemColors.surfaceContainer),
      borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
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

  /// Build tappable sort button
  Widget buildTappableSortButton({
    required BuildContext context,
    required String label,
    required bool ascending,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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

  /// Build tappable menu item
  Widget buildTappableMenuItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build tappable expansion tile
  Widget buildTappableExpansionTile({
    required BuildContext context,
    required Widget title,
    required List<Widget> children,
    required bool initiallyExpanded,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: ExpansionTile(
        title: title,
        children: children,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: _tapHandlingEnabled ? (expanded) {
          if (expanded && onTap != null) {
            onTap();
          }
        } : null,
        backgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
        collapsedBackgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
        childrenPadding: EdgeInsets.all(design.designSystemSpacing.md),
      ),
    );
  }

  /// Build tappable data table
  Widget buildTappableDataTable({
    required BuildContext context,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    required VoidCallback? onTap,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? onTap ?? _handleTap : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: DataTable(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }

  /// Build tappable calendar
  Widget buildTappableCalendar({
    required BuildContext context,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateSelected,
    Color? backgroundColor,
    Color? selectedColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? () {
          _showDatePicker(context, selectedDate, onDateSelected);
        } : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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

  /// Show date picker
  void _showDatePicker(
    BuildContext context,
    DateTime selectedDate,
    ValueChanged<DateTime> onDateSelected,
  ) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((date) {
      if (date != null) {
        onDateSelected(date);
      }
    });
  }

  /// Build tappable time picker
  Widget buildTappableTimePicker({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required ValueChanged<TimeOfDay> onTimeSelected,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? () {
          _showTimePicker(context, selectedTime, onTimeSelected);
        } : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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

  /// Show time picker
  void _showTimePicker(
    BuildContext context,
    TimeOfDay selectedTime,
    ValueChanged<TimeOfDay> onTimeSelected,
  ) {
    showTimePicker(
      context: context,
      initialTime: selectedTime,
    ).then((time) {
      if (time != null) {
        onTimeSelected(time);
      }
    });
  }

  /// Build tappable color picker
  Widget buildTappableColorPicker({
    required BuildContext context,
    required Color selectedColor,
    required ValueChanged<Color> onColorSelected,
    List<Color>? availableColors,
    Color? backgroundColor,
    Color? pressedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final colors = availableColors ?? [
      design.designSystemColors.primary,
      design.designSystemColors.secondary,
      design.designSystemColors.error,
      design.designSystemColors.success,
      design.designSystemColors.warning,
      design.designSystemColors.info,
    ];

    return Material(
      color: backgroundColor ?? design.designSystemColors.surfaceContainer,
      borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      child: InkWell(
        onTap: _tapHandlingEnabled ? () {
          _showColorPicker(context, colors, selectedColor, onColorSelected);
        } : null,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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

  /// Show color picker
  void _showColorPicker(
    BuildContext context,
    List<Color> colors,
    Color selectedColor,
    ValueChanged<Color> onColorSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Color'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              return InkWell(
                onTap: () {
                  onColorSelected(color);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color == selectedColor
                          ? Colors.white
                          : Colors.grey,
                      width: color == selectedColor ? 3 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Callback when tap state changes
  void Function(TapState state)? get onTapStateChanged => null;
}

/// Tap state enumeration
enum TapState {
  /// Widget is idle (not pressed)
  idle,

  /// Widget is being pressed
  pressed,

  /// Widget was tapped
  tapped,

  /// Widget was long pressed
  longPressed,

  /// Widget was double tapped
  doubleTapped,
}

/// Tap configuration
class TapConfig {
  /// Callback when widget is tapped
  final VoidCallback? onTap;

  /// Callback when widget is long pressed
  final VoidCallback? onLongPress;

  /// Callback when widget is double tapped
  final VoidCallback? onDoubleTap;

  /// Callback when tap down occurs
  final VoidCallback? onTapDown;

  /// Callback when tap up occurs
  final VoidCallback? onTapUp;

  /// Callback when tap is cancelled
  final VoidCallback? onTapCancel;

  /// Whether debouncing is enabled
  final bool enableDebouncing;

  /// Debounce duration
  final Duration debounceDuration;

  /// Haptic feedback type
  final HapticFeedbackType hapticType;

  /// Long press duration
  final Duration longPressDuration;

  /// Whether long press is enabled
  final bool enableLongPress;

  /// Whether double tap is enabled
  final bool enableDoubleTap;

  const TapConfig({
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.enableDebouncing = false,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.hapticType = HapticFeedbackType.light,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.enableLongPress = true,
    this.enableDoubleTap = false,
  });
}

/// Haptic feedback types
enum HapticFeedbackType {
  /// Light impact feedback
  light,

  /// Medium impact feedback
  medium,

  /// Heavy impact feedback
  heavy,

  /// Selection click feedback
  selection,

  /// Vibration feedback
  vibrate,
}