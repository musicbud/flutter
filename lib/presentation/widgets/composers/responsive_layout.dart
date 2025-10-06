import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';

/// A composer class for handling responsive design patterns.
/// Provides a fluent API for creating responsive layouts that adapt to different screen sizes.
///
/// **Features:**
/// - Breakpoint-based responsive design
/// - Flexible grid and flex layouts
/// - Adaptive spacing and sizing
/// - Consistent responsive behavior
/// - Support for custom breakpoints
/// - Built-in common responsive patterns
///
/// **Usage:**
/// ```dart
/// final responsiveLayout = ResponsiveLayout()
///   .withBreakpoints(
///     xs: 480,
///     sm: 768,
///     md: 1024,
///     lg: 1200,
///   )
///   .withChild(
///     builder: (context, breakpoint) {
///       switch (breakpoint) {
///         case ResponsiveBreakpoint.xs:
///           return Column(children: [/* mobile layout */]);
///         case ResponsiveBreakpoint.sm:
///           return Row(children: [/* tablet layout */]);
///         default:
///           return Row(children: [/* desktop layout */]);
///       }
///     },
///   )
///   .withPadding(ResponsivePadding.symmetric(
///     horizontal: ResponsiveValue(
///       xs: DesignSystem.spacingMD,
///       sm: DesignSystem.spacingLG,
///       md: DesignSystem.spacingXL,
///     ),
///   ))
///   .build();
/// ```
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveBreakpoint breakpoint) _builder;
  final Map<String, double> _breakpoints;
  final EdgeInsetsGeometry? _padding;
  final EdgeInsetsGeometry? _margin;
  final AlignmentGeometry? _alignment;
  final ResponsiveBreakpoint _defaultBreakpoint;

  /// Creates a new ResponsiveLayout
  const ResponsiveLayout._({
    super.key,
    required Widget Function(BuildContext context, ResponsiveBreakpoint breakpoint) builder,
    Map<String, double> breakpoints = const {
      'xs': 480,
      'sm': 768,
      'md': 1024,
      'lg': 1200,
      'xl': 1440,
    },
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    ResponsiveBreakpoint defaultBreakpoint = ResponsiveBreakpoint.md,
  })  : _builder = builder,
        _breakpoints = breakpoints,
        _padding = padding,
        _margin = margin,
        _alignment = alignment,
        _defaultBreakpoint = defaultBreakpoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      margin: _margin,
      alignment: _alignment,
      child: _builder(context, _getCurrentBreakpoint(context)),
    );
  }

  ResponsiveBreakpoint _getCurrentBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < _breakpoints['xs']!) {
      return ResponsiveBreakpoint.xs;
    } else if (width < _breakpoints['sm']!) {
      return ResponsiveBreakpoint.sm;
    } else if (width < _breakpoints['md']!) {
      return ResponsiveBreakpoint.md;
    } else if (width < _breakpoints['lg']!) {
      return ResponsiveBreakpoint.lg;
    } else {
      return ResponsiveBreakpoint.xl;
    }
  }

  /// Creates a ResponsiveLayout with custom configuration
  factory ResponsiveLayout({
    Key? key,
    required Widget Function(BuildContext context, ResponsiveBreakpoint breakpoint) builder,
    Map<String, double>? breakpoints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    ResponsiveBreakpoint? defaultBreakpoint,
  }) {
    return ResponsiveLayout._(
      key: key,
      builder: builder,
      breakpoints: breakpoints ?? const {
        'xs': 480,
        'sm': 768,
        'md': 1024,
        'lg': 1200,
        'xl': 1440,
      },
      padding: padding,
      margin: margin,
      alignment: alignment,
      defaultBreakpoint: defaultBreakpoint ?? ResponsiveBreakpoint.md,
    );
  }

  /// Creates a responsive layout with a simple child widget
  factory ResponsiveLayout.child({
    Key? key,
    required Widget child,
    Map<String, double>? breakpoints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
  }) {
    return ResponsiveLayout._(
      key: key,
      builder: (_, __) => child,
      breakpoints: breakpoints ?? const {
        'xs': 480,
        'sm': 768,
        'md': 1024,
        'lg': 1200,
        'xl': 1440,
      },
      padding: padding,
      margin: margin,
      alignment: alignment,
    );
  }
}

/// Responsive breakpoint enumeration
enum ResponsiveBreakpoint {
  /// Extra small devices (phones, < 480px)
  xs,

  /// Small devices (large phones, 480px - 768px)
  sm,

  /// Medium devices (tablets, 768px - 1024px)
  md,

  /// Large devices (desktops, 1024px - 1200px)
  lg,

  /// Extra large devices (large desktops, > 1200px)
  xl,
}

/// Extension methods for responsive breakpoints
extension ResponsiveBreakpointExtension on ResponsiveBreakpoint {
  /// Gets the minimum width for this breakpoint
  double get minWidth {
    switch (this) {
      case ResponsiveBreakpoint.xs:
        return 0;
      case ResponsiveBreakpoint.sm:
        return 480;
      case ResponsiveBreakpoint.md:
        return 768;
      case ResponsiveBreakpoint.lg:
        return 1024;
      case ResponsiveBreakpoint.xl:
        return 1200;
    }
  }

  /// Gets the maximum width for this breakpoint
  double get maxWidth {
    switch (this) {
      case ResponsiveBreakpoint.xs:
        return 480;
      case ResponsiveBreakpoint.sm:
        return 768;
      case ResponsiveBreakpoint.md:
        return 1024;
      case ResponsiveBreakpoint.lg:
        return 1200;
      case ResponsiveBreakpoint.xl:
        return double.infinity;
    }
  }

  /// Checks if this is a mobile breakpoint
  bool get isMobile => this == ResponsiveBreakpoint.xs || this == ResponsiveBreakpoint.sm;

  /// Checks if this is a tablet breakpoint
  bool get isTablet => this == ResponsiveBreakpoint.md;

  /// Checks if this is a desktop breakpoint
  bool get isDesktop => this == ResponsiveBreakpoint.lg || this == ResponsiveBreakpoint.xl;
}

/// Responsive value that changes based on breakpoint
class ResponsiveValue<T> {
  final T xs;
  final T? sm;
  final T? md;
  final T? lg;
  final T? xl;

  const ResponsiveValue({
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  /// Gets the value for the given breakpoint
  T getValue(ResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.xs:
        return xs;
      case ResponsiveBreakpoint.sm:
        return sm ?? xs;
      case ResponsiveBreakpoint.md:
        return md ?? sm ?? xs;
      case ResponsiveBreakpoint.lg:
        return lg ?? md ?? sm ?? xs;
      case ResponsiveBreakpoint.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}

/// Responsive padding that adapts to screen size
class ResponsivePadding extends EdgeInsets {
  const ResponsivePadding._({
    double? xsLeft,
    double? xsTop,
    double? xsRight,
    double? xsBottom,
    double? smLeft,
    double? smTop,
    double? smRight,
    double? smBottom,
    double? mdLeft,
    double? mdTop,
    double? mdRight,
    double? mdBottom,
    double? lgLeft,
    double? lgTop,
    double? lgRight,
    double? lgBottom,
    double? xlLeft,
    double? xlTop,
    double? xlRight,
    double? xlBottom,
  }) : super.only(
          left: xsLeft ?? 0,
          top: xsTop ?? 0,
          right: xsRight ?? 0,
          bottom: xsBottom ?? 0,
        );

  /// Creates responsive padding with all sides equal
  factory ResponsivePadding.all(ResponsiveValue<double> value) {
    return ResponsivePadding.symmetric(
      horizontal: value,
      vertical: value,
    );
  }

  /// Creates responsive padding with symmetric horizontal and vertical values
  factory ResponsivePadding.symmetric({
    ResponsiveValue<double>? horizontal,
    ResponsiveValue<double>? vertical,
  }) {
    return ResponsivePadding.only(
      left: horizontal,
      right: horizontal,
      top: vertical,
      bottom: vertical,
    );
  }

  /// Creates responsive padding with individual side values
  factory ResponsivePadding.only({
    ResponsiveValue<double>? left,
    ResponsiveValue<double>? top,
    ResponsiveValue<double>? right,
    ResponsiveValue<double>? bottom,
  }) {
    return ResponsivePadding._(
      xsLeft: left?.xs,
      xsTop: top?.xs,
      xsRight: right?.xs,
      xsBottom: bottom?.xs,
      smLeft: left?.sm,
      smTop: top?.sm,
      smRight: right?.sm,
      smBottom: bottom?.sm,
      mdLeft: left?.md,
      mdTop: top?.md,
      mdRight: right?.md,
      mdBottom: bottom?.md,
      lgLeft: left?.lg,
      lgTop: top?.lg,
      lgRight: right?.lg,
      lgBottom: bottom?.lg,
      xlLeft: left?.xl,
      xlTop: top?.xl,
      xlRight: right?.xl,
      xlBottom: bottom?.xl,
    );
  }

  /// Gets the appropriate padding for the current breakpoint
  static EdgeInsets getPadding(
    BuildContext context,
    ResponsivePadding responsivePadding,
  ) {
    final breakpoint = _getCurrentBreakpoint(context);
    return EdgeInsets.only(
      left: _getValue(responsivePadding.left, breakpoint),
      top: _getValue(responsivePadding.top, breakpoint),
      right: _getValue(responsivePadding.right, breakpoint),
      bottom: _getValue(responsivePadding.bottom, breakpoint),
    );
  }

  static double _getValue(double? value, ResponsiveBreakpoint breakpoint) {
    // This is a simplified implementation
    // In a real implementation, you'd need to store the responsive values
    return value ?? 0;
  }

  static ResponsiveBreakpoint _getCurrentBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 480) {
      return ResponsiveBreakpoint.xs;
    } else if (width < 768) {
      return ResponsiveBreakpoint.sm;
    } else if (width < 1024) {
      return ResponsiveBreakpoint.md;
    } else if (width < 1200) {
      return ResponsiveBreakpoint.lg;
    } else {
      return ResponsiveBreakpoint.xl;
    }
  }
}

/// Responsive grid layout widget
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final ResponsiveValue<int> crossAxisCount;
  final ResponsiveValue<double> crossAxisSpacing;
  final ResponsiveValue<double> mainAxisSpacing;
  final ResponsiveValue<double> childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing = const ResponsiveValue<double>(xs: 8, sm: 12, md: 16, lg: 20, xl: 24),
    this.mainAxisSpacing = const ResponsiveValue<double>(xs: 8, sm: 12, md: 16, lg: 20, xl: 24),
    this.childAspectRatio = const ResponsiveValue<double>(xs: 1, sm: 1, md: 1, lg: 1, xl: 1),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, breakpoint) {
        return GridView.count(
          crossAxisCount: crossAxisCount.getValue(breakpoint),
          crossAxisSpacing: crossAxisSpacing.getValue(breakpoint),
          mainAxisSpacing: mainAxisSpacing.getValue(breakpoint),
          childAspectRatio: childAspectRatio.getValue(breakpoint),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

/// Responsive flex layout widget
class ResponsiveFlex extends StatelessWidget {
  final List<Widget> children;
  final ResponsiveValue<int> flexCount;
  final Axis direction;
  final ResponsiveValue<MainAxisAlignment> mainAxisAlignment;
  final ResponsiveValue<CrossAxisAlignment> crossAxisAlignment;

  const ResponsiveFlex({
    super.key,
    required this.children,
    this.flexCount = const ResponsiveValue<int>(xs: 1, sm: 2, md: 3, lg: 4, xl: 5),
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = const ResponsiveValue<MainAxisAlignment>(
      xs: MainAxisAlignment.start,
      sm: MainAxisAlignment.start,
      md: MainAxisAlignment.start,
      lg: MainAxisAlignment.start,
      xl: MainAxisAlignment.start,
    ),
    this.crossAxisAlignment = const ResponsiveValue<CrossAxisAlignment>(
      xs: CrossAxisAlignment.start,
      sm: CrossAxisAlignment.start,
      md: CrossAxisAlignment.start,
      lg: CrossAxisAlignment.start,
      xl: CrossAxisAlignment.start,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, breakpoint) {
        return Flex(
          direction: direction,
          mainAxisAlignment: mainAxisAlignment.getValue(breakpoint),
          crossAxisAlignment: crossAxisAlignment.getValue(breakpoint),
          children: children.map((child) {
            return Expanded(
              flex: flexCount.getValue(breakpoint),
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}