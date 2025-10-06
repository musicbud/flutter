import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/theme/design_system.dart';

/// A mixin that provides comprehensive focus state management for widgets.
///
/// This mixin handles:
/// - Focus state detection and tracking
/// - Keyboard navigation support
/// - Focus animations and visual feedback
/// - Accessibility support for focus states
/// - Focus callbacks and state management
/// - Customizable focus styling and behavior
/// - Memory management for focus nodes
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with FocusMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     setupFocus(
///       onFocus: _handleFocus,
///       onUnfocus: _handleUnfocus,
///       canRequestFocus: true,
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return buildFocusableWidget(
///       context,
///       child: _buildContent(),
///       onFocus: _handleFocus,
///     );
///   }
/// }
/// ```
mixin FocusMixin<T extends StatefulWidget> on State<T> {
  /// Focus node for managing focus state
  late FocusNode _focusNode;

  /// Whether focus is enabled
  bool _focusEnabled = true;

  /// Current focus state
  FocusState _focusState = FocusState.unfocused;

  /// Whether the widget currently has focus
  bool _hasFocus = false;

  /// Focus configuration
  FocusConfig? _focusConfig;

  /// Animation controller for focus effects
  AnimationController? _focusAnimationController;

  /// Scale animation for focus feedback
  Animation<double>? _focusScaleAnimation;

  /// Border animation for focus feedback
  Animation<double>? _focusBorderAnimation;

  /// Whether focus is enabled
  bool get focusEnabled => _focusEnabled;

  /// Current focus state
  FocusState get focusState => _focusState;

  /// Whether the widget currently has focus
  bool get hasFocus => _hasFocus;

  /// Gets the focus node
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _initializeFocusNode();
    _initializeFocusAnimations();
  }

  @override
  void dispose() {
    _disposeFocusNode();
    _disposeFocusAnimations();
    super.dispose();
  }

  /// Initialize focus node
  void _initializeFocusNode() {
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  /// Dispose of focus node
  void _disposeFocusNode() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
  }

  /// Initialize focus animations
  void _initializeFocusAnimations() {
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: const _TickerProvider(),
    );

    _focusScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController!,
      curve: Curves.easeInOut,
    ));

    _focusBorderAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController!,
      curve: Curves.easeInOut,
    ));
  }

  /// Dispose of focus animations
  void _disposeFocusAnimations() {
    _focusAnimationController?.dispose();
  }

  /// Handle focus changes
  void _handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;

    if (hasFocus != _hasFocus) {
      _hasFocus = hasFocus;
      _updateFocusState(hasFocus ? FocusState.focused : FocusState.unfocused);

      if (hasFocus) {
        _startFocusAnimation();
        _focusConfig?.onFocus?.call();
      } else {
        _stopFocusAnimation();
        _focusConfig?.onUnfocus?.call();
      }
    }
  }

  /// Start focus animation
  void _startFocusAnimation() {
    if (_focusAnimationController?.isAnimating ?? false) {
      _focusAnimationController?.stop();
    }
    _focusAnimationController?.forward();
  }

  /// Stop focus animation
  void _stopFocusAnimation() {
    if (_focusAnimationController?.isAnimating ?? false) {
      _focusAnimationController?.reverse();
    }
  }

  /// Update focus state
  void _updateFocusState(FocusState state) {
    _focusState = state;
    onFocusStateChanged?.call(state);
  }

  /// Setup focus configuration
  void setupFocus({
    VoidCallback? onFocus,
    VoidCallback? onUnfocus,
    bool canRequestFocus = true,
    bool skipTraversal = false,
    bool descendantsAreFocusable = true,
    bool autofocus = false,
    FocusOnKeyEventCallback? onKeyEvent,
    String? debugLabel,
  }) {
    _focusConfig = FocusConfig(
      onFocus: onFocus,
      onUnfocus: onUnfocus,
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      descendantsAreFocusable: descendantsAreFocusable,
      autofocus: autofocus,
      onKeyEvent: onKeyEvent,
      debugLabel: debugLabel,
    );

    // Update focus node properties
    _focusNode.canRequestFocus = canRequestFocus;
    _focusNode.skipTraversal = skipTraversal;
    _focusNode.descendantsAreFocusable = descendantsAreFocusable;
    _focusNode.debugLabel = debugLabel;

    if (autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  /// Enable or disable focus
  void setFocusEnabled(bool enabled) {
    _focusEnabled = enabled;
    if (!enabled && _hasFocus) {
      _focusNode.unfocus();
    }
  }

  /// Request focus
  void requestFocus() {
    if (_focusEnabled) {
      _focusNode.requestFocus();
    }
  }

  /// Unfocus
  void unfocus() {
    _focusNode.unfocus();
  }

  /// Next focus
  void nextFocus() {
    _focusNode.nextFocus();
  }

  /// Previous focus
  void previousFocus() {
    _focusNode.previousFocus();
  }

  /// Focus to specific node
  void focusTo(FocusNode node) {
    _focusNode.focusInDirection(TraversalDirection.down);
  }

  /// Build focusable widget
  Widget buildFocusableWidget({
    required BuildContext context,
    required Widget child,
    VoidCallback? onFocus,
    VoidCallback? onUnfocus,
    FocusOnKeyEventCallback? onKeyEvent,
    bool canRequestFocus = true,
    bool skipTraversal = false,
    bool autofocus = false,
  }) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      onKeyEvent: onKeyEvent,
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      autofocus: autofocus,
      child: _focusConfig?.enableAnimations == true
          ? _buildAnimatedFocusChild(child)
          : child,
    );
  }

  /// Build animated focus child
  Widget _buildAnimatedFocusChild(Widget child) {
    if (_focusScaleAnimation == null || _focusBorderAnimation == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _focusScaleAnimation!,
        _focusBorderAnimation!,
      ]),
      builder: (context, child) {
        return Container(
          transform: Matrix4.identity()
            ..scale(_focusScaleAnimation!.value),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: _focusBorderAnimation!.value,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build focusable container
  Widget buildFocusableContainer({
    required BuildContext context,
    required Widget child,
    VoidCallback? onFocus,
    VoidCallback? onUnfocus,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Decoration? focusDecoration,
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
      child: buildFocusableWidget(
        context: context,
        onFocus: onFocus,
        onUnfocus: onUnfocus,
        child: child,
      ),
    );
  }

  /// Build focusable text field
  Widget buildFocusableTextField({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    String? hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: TextFormField(
        controller: controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
            borderSide: BorderSide(
              color: design.designSystemColors.primary,
              width: 2,
            ),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
      ),
    );
  }

  /// Build focusable button
  Widget buildFocusableButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    required VoidCallback onPressed,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? focusColor,
    BorderRadius? borderRadius,
    double? elevation,
    double? focusElevation,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      margin: margin,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: _focusEnabled ? (hasFocus) {
          if (hasFocus) {
            onFocus?.call();
          } else {
            onUnfocus?.call();
          }
        } : null,
        child: ElevatedButton(
          onPressed: _focusEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? design.designSystemColors.primary,
            elevation: elevation ?? 2,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
            ),
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: design.designSystemSpacing.lg,
              vertical: design.designSystemSpacing.md,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable icon button
  Widget buildFocusableIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    required VoidCallback onPressed,
    double? size,
    Color? color,
    Color? focusColor,
    String? semanticLabel,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: IconButton(
        onPressed: _focusEnabled ? onPressed : null,
        icon: icon,
        iconSize: size ?? 24,
        color: color ?? design.designSystemColors.onSurface,
        padding: padding ?? EdgeInsets.all(design.designSystemSpacing.sm),
        tooltip: semanticLabel,
      ),
    );
  }

  /// Build focusable card
  Widget buildFocusableCard({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color? focusColor,
    double? elevation,
    double? focusElevation,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Card(
        margin: margin ?? EdgeInsets.all(design.designSystemSpacing.sm),
        color: color ?? design.designSystemColors.surfaceContainer,
        elevation: elevation ?? 2,
        shape: shape ?? RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        ),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable list item
  Widget buildFocusableListItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? focusColor,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.sm),
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable menu item
  Widget buildFocusableMenuItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        child: Container(
          padding: padding ?? EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable tab
  Widget buildFocusableTab({
    required BuildContext context,
    required Widget child,
    required bool isSelected,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: isSelected
            ? (selectedColor ?? design.designSystemColors.primary)
            : (backgroundColor ?? design.designSystemColors.surfaceContainer),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable dropdown item
  Widget buildFocusableDropdownItem({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable navigation item
  Widget buildFocusableNavigationItem({
    required BuildContext context,
    required Widget child,
    required bool isSelected,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: isSelected
            ? (selectedColor ?? design.designSystemColors.primary)
            : (backgroundColor ?? design.designSystemColors.surfaceContainer),
        child: Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          child: child,
        ),
      ),
    );
  }

  /// Build focusable checkbox
  Widget buildFocusableCheckbox({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? activeColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Checkbox(
        value: value,
        onChanged: _focusEnabled ? (value) => onChanged(value ?? false) : null,
        activeColor: activeColor ?? design.designSystemColors.primary,
      ),
    );
  }

  /// Build focusable radio button
  Widget buildFocusableRadio<T>({
    required BuildContext context,
    required T value,
    required T groupValue,
    required ValueChanged<T> onChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? activeColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final isSelected = value == groupValue;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: _focusEnabled ? (value) => onChanged(value as T) : null,
        activeColor: activeColor ?? design.designSystemColors.primary,
      ),
    );
  }

  /// Build focusable switch
  Widget buildFocusableSwitch({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? activeColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Switch(
        value: value,
        onChanged: _focusEnabled ? onChanged : null,
        activeColor: activeColor ?? design.designSystemColors.primary,
      ),
    );
  }

  /// Build focusable slider
  Widget buildFocusableSlider({
    required BuildContext context,
    required double value,
    required ValueChanged<double> onChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    double min = 0.0,
    double max = 1.0,
    Color? activeColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Slider(
        value: value,
        onChanged: _focusEnabled ? onChanged : null,
        min: min,
        max: max,
        activeColor: activeColor ?? design.designSystemColors.primary,
      ),
    );
  }

  /// Build focusable expansion tile
  Widget buildFocusableExpansionTile({
    required BuildContext context,
    required Widget title,
    required List<Widget> children,
    required bool initiallyExpanded,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        child: ExpansionTile(
          title: title,
          children: children,
          initiallyExpanded: initiallyExpanded,
          backgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
          collapsedBackgroundColor: backgroundColor ?? design.designSystemColors.surfaceContainer,
          childrenPadding: EdgeInsets.all(design.designSystemSpacing.md),
        ),
      ),
    );
  }

  /// Build focusable data table
  Widget buildFocusableDataTable({
    required BuildContext context,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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

  /// Build focusable calendar
  Widget buildFocusableCalendar({
    required BuildContext context,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateSelected,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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

  /// Build focusable time picker
  Widget buildFocusableTimePicker({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required ValueChanged<TimeOfDay> onTimeSelected,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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

  /// Build focusable color picker
  Widget buildFocusableColorPicker({
    required BuildContext context,
    required Color selectedColor,
    required ValueChanged<Color> onColorSelected,
    required List<Color> availableColors,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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

  /// Build focusable rating widget
  Widget buildFocusableRating({
    required BuildContext context,
    required double rating,
    required int maxRating,
    required ValueChanged<double> onRatingChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? activeColor,
    Color? focusColor,
    double? size,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Row(
        children: List.generate(maxRating, (index) {
          final starValue = index + 1;
          final isActive = starValue <= rating;

          return IconButton(
            focusNode: _focusNode,
            onPressed: _focusEnabled ? () => onRatingChanged(starValue.toDouble()) : null,
            icon: Icon(
              isActive ? Icons.star : Icons.star_border,
              color: isActive
                  ? (activeColor ?? design.designSystemColors.warning)
                  : design.designSystemColors.onSurfaceVariant,
            ),
            iconSize: size ?? 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          );
        }),
      ),
    );
  }

  /// Build focusable pagination controls
  Widget buildFocusablePagination({
    required BuildContext context,
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              focusNode: _focusNode,
              onPressed: _focusEnabled && currentPage > 1
                  ? () => onPageChanged(currentPage - 1)
                  : null,
              icon: Icon(Icons.chevron_left),
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.md),
              child: Text(
                '$currentPage / $totalPages',
                style: design.designSystemTypography.bodyMedium,
              ),
            ),
            IconButton(
              focusNode: _focusNode,
              onPressed: _focusEnabled && currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              icon: Icon(Icons.chevron_right),
              padding: EdgeInsets.all(design.designSystemSpacing.sm),
            ),
          ],
        ),
      ),
    );
  }

  /// Build focusable filter chip
  Widget buildFocusableFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: selected
            ? (selectedColor ?? design.designSystemColors.primary)
            : (backgroundColor ?? design.designSystemColors.surfaceContainer),
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

  /// Build focusable sort button
  Widget buildFocusableSortButton({
    required BuildContext context,
    required String label,
    required bool ascending,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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

  /// Build focusable search bar
  Widget buildFocusableSearchBar({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    String? hintText,
    Color? backgroundColor,
    Color? focusColor,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
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
                child: TextField(
                  controller: controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build focusable floating action button
  Widget buildFocusableFloatingActionButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? focusColor,
    double? elevation,
    double? focusElevation,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: FloatingActionButton(
        onPressed: _focusEnabled ? onPressed : null,
        backgroundColor: backgroundColor ?? design.designSystemColors.primary,
        elevation: elevation ?? 6,
        focusElevation: focusElevation ?? 8,
        child: child,
      ),
    );
  }

  /// Build focusable tab bar
  Widget buildFocusableTabBar({
    required BuildContext context,
    required List<Widget> tabs,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == currentIndex;

            return Expanded(
              child: Material(
                color: isSelected
                    ? (selectedColor ?? design.designSystemColors.primary)
                    : Colors.transparent,
                child: InkWell(
                  focusNode: _focusNode,
                  onTap: _focusEnabled ? () => onTap(index) : null,
                  child: Container(
                    padding: EdgeInsets.all(design.designSystemSpacing.md),
                    child: tab,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build focusable bottom navigation
  Widget buildFocusableBottomNavigation({
    required BuildContext context,
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surface,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: design.designSystemSpacing.sm),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: Material(
                  color: isSelected
                      ? (selectedColor ?? design.designSystemColors.primary)
                      : Colors.transparent,
                  child: InkWell(
                    focusNode: _focusNode,
                    onTap: _focusEnabled ? () => onTap(index) : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? design.designSystemColors.onPrimary
                              : design.designSystemColors.onSurfaceVariant,
                        ),
                        SizedBox(height: design.designSystemSpacing.xs),
                        Text(
                          item.label!,
                          style: design.designSystemTypography.caption.copyWith(
                            color: isSelected
                                ? design.designSystemColors.onPrimary
                                : design.designSystemColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Build focusable segmented control
  Widget buildFocusableSegmentedControl<T>({
    required BuildContext context,
    required List<T> segments,
    required T selectedValue,
    required ValueChanged<T> onChanged,
    required Widget Function(T value) builder,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
    Color? selectedColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
        child: Row(
          children: segments.map((segment) {
            final isSelected = segment == selectedValue;
            return Expanded(
              child: Material(
                color: isSelected
                    ? (selectedColor ?? design.designSystemColors.primary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
                child: InkWell(
                  focusNode: _focusNode,
                  onTap: _focusEnabled ? () => onChanged(segment) : null,
                  borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.designSystemSpacing.md,
                      vertical: design.designSystemSpacing.sm,
                    ),
                    child: builder(segment),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build focusable stepper
  Widget buildFocusableStepper({
    required BuildContext context,
    required int currentStep,
    required List<Step> steps,
    required VoidCallback onStepContinue,
    required VoidCallback onStepCancel,
    required VoidCallback? onFocus,
    required VoidCallback? onUnfocus,
    Color? backgroundColor,
    Color? focusColor,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: _focusEnabled ? (hasFocus) {
        if (hasFocus) {
          onFocus?.call();
        } else {
          onUnfocus?.call();
        }
      } : null,
      child: Material(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
        child: Stepper(
          currentStep: currentStep,
          onStepContinue: _focusEnabled ? onStepContinue : null,
          onStepCancel: _focusEnabled ? onStepCancel : null,
          steps: steps,
          controlsBuilder: (context, details) {
            return Container(
              margin: EdgeInsets.only(top: design.designSystemSpacing.md),
              child: Row(
                children: [
                  if (currentStep < steps.length - 1)
                    Focus(
                      focusNode: _focusNode,
                      child: ElevatedButton(
                        onPressed: _focusEnabled ? details.onStepContinue : null,
                        child: Text('Continue'),
                      ),
                    ),
                  if (currentStep > 0) ...[
                    SizedBox(width: design.designSystemSpacing.md),
                    Focus(
                      focusNode: _focusNode,
                      child: ElevatedButton(
                        onPressed: _focusEnabled ? details.onStepCancel : null,
                        child: Text('Back'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Callback when focus state changes
  void Function(FocusState state)? get onFocusStateChanged => null;
}

/// Focus state enumeration
enum FocusState {
  /// Widget is not focused
  unfocused,

  /// Widget is focused
  focused,
}

/// Ticker provider for animations
class _TickerProvider extends TickerProvider {
  const _TickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

/// Focus configuration
class FocusConfig {
  /// Callback when focus is gained
  final VoidCallback? onFocus;

  /// Callback when focus is lost
  final VoidCallback? onUnfocus;

  /// Whether the widget can request focus
  final bool canRequestFocus;

  /// Whether to skip traversal
  final bool skipTraversal;

  /// Whether descendants are focusable
  final bool descendantsAreFocusable;

  /// Whether to autofocus
  final bool autofocus;

  /// Whether animations are enabled
  final bool enableAnimations;

  /// Key event handler
  final FocusOnKeyEventCallback? onKeyEvent;

  /// Debug label
  final String? debugLabel;

  const FocusConfig({
    this.onFocus,
    this.onUnfocus,
    this.canRequestFocus = true,
    this.skipTraversal = false,
    this.descendantsAreFocusable = true,
    this.autofocus = false,
    this.enableAnimations = true,
    this.onKeyEvent,
    this.debugLabel,
  });
}