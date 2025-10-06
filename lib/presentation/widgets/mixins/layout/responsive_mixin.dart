
import 'package:flutter/material.dart';

/// A mixin that provides responsive design capabilities for widgets.
///
/// This mixin handles:
/// - Screen size detection and breakpoints
/// - Responsive layout calculations
/// - Adaptive sizing and spacing
/// - Orientation-aware layouts
/// - Platform-specific adaptations
/// - Responsive typography scaling
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with ResponsiveMixin {
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       width: responsiveValue(
///         context,
///         mobile: 320,
///         tablet: 768,
///         desktop: 1024,
///       ),
///       padding: responsivePadding(context),
///     );
///   }
/// }
/// ```
mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  /// Responsive breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  static const double largeDesktopBreakpoint = 1440;

  /// Current screen information
  late MediaQueryData _mediaQuery;

  /// Whether the current screen is mobile size
  bool get isMobile => _mediaQuery.size.width < tabletBreakpoint;

  /// Whether the current screen is tablet size
  bool get isTablet => _mediaQuery.size.width >= tabletBreakpoint &&
                       _mediaQuery.size.width < desktopBreakpoint;

  /// Whether the current screen is desktop size
  bool get isDesktop => _mediaQuery.size.width >= desktopBreakpoint;

  /// Whether the current screen is large desktop size
  bool get isLargeDesktop => _mediaQuery.size.width >= largeDesktopBreakpoint;

  /// Current screen width
  double get screenWidth => _mediaQuery.size.width;

  /// Current screen height
  double get screenHeight => _mediaQuery.size.height;

  /// Current device orientation
  Orientation get orientation => _mediaQuery.orientation;

  /// Whether the device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// Whether the device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// Screen size category
  ScreenSize get screenSize {
    final width = screenWidth;
    if (width < tabletBreakpoint) return ScreenSize.mobile;
    if (width < desktopBreakpoint) return ScreenSize.tablet;
    if (width < largeDesktopBreakpoint) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaQuery = MediaQuery.of(context);
  }

  /// Get responsive value based on screen size
  T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final currentSize = screenSize;

    switch (currentSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive double value with smooth scaling
  double responsiveDouble({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveValue<double>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive padding based on screen size
  EdgeInsetsGeometry responsivePadding({
    required BuildContext context,
    EdgeInsetsGeometry? mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
    EdgeInsetsGeometry? largeDesktop,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final defaultMobile = EdgeInsets.all(design.designSystemSpacing.md);
    final defaultTablet = EdgeInsets.all(design.designSystemSpacing.lg);
    final defaultDesktop = EdgeInsets.all(design.designSystemSpacing.xl);

    return responsiveValue<EdgeInsetsGeometry>(
      context: context,
      mobile: mobile ?? defaultMobile,
      tablet: tablet ?? defaultTablet,
      desktop: desktop ?? defaultDesktop,
      largeDesktop: largeDesktop ?? EdgeInsets.all(design.designSystemSpacing.xxl),
    );
  }

  /// Get responsive margin based on screen size
  EdgeInsetsGeometry responsiveMargin({
    required BuildContext context,
    EdgeInsetsGeometry? mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
    EdgeInsetsGeometry? largeDesktop,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final defaultMobile = EdgeInsets.all(design.designSystemSpacing.sm);
    final defaultTablet = EdgeInsets.all(design.designSystemSpacing.md);
    final defaultDesktop = EdgeInsets.all(design.designSystemSpacing.lg);

    return responsiveValue<EdgeInsetsGeometry>(
      context: context,
      mobile: mobile ?? defaultMobile,
      tablet: tablet ?? defaultTablet,
      desktop: desktop ?? defaultDesktop,
      largeDesktop: largeDesktop ?? EdgeInsets.all(design.designSystemSpacing.xl),
    );
  }

  /// Get responsive font size based on screen size
  double responsiveFontSize({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    final baseSize = responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );

    // Scale font size based on screen width for better readability
    final scaleFactor = _getFontScaleFactor();
    return baseSize * scaleFactor;
  }

  /// Get responsive icon size based on screen size
  double responsiveIconSize({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive border radius based on screen size
  BorderRadius responsiveBorderRadius({
    required BuildContext context,
    BorderRadius? mobile,
    BorderRadius? tablet,
    BorderRadius? desktop,
    BorderRadius? largeDesktop,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    final defaultMobile = BorderRadius.circular(design.designSystemRadius.sm);
    final defaultTablet = BorderRadius.circular(design.designSystemRadius.md);
    final defaultDesktop = BorderRadius.circular(design.designSystemRadius.lg);

    return responsiveValue<BorderRadius>(
      context: context,
      mobile: mobile ?? defaultMobile,
      tablet: tablet ?? defaultTablet,
      desktop: desktop ?? defaultDesktop,
      largeDesktop: largeDesktop ?? BorderRadius.circular(design.designSystemRadius.xl),
    );
  }

  /// Get responsive grid cross axis count
  int responsiveGridCount({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue<int>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? (mobile + 1).clamp(1, 6),
      desktop: desktop ?? (tablet ?? mobile + 2).clamp(1, 8),
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile + 3).clamp(1, 12),
    );
  }

  /// Get responsive main axis spacing for grids
  double responsiveMainAxisSpacing({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? design.designSystemSpacing.lg,
      desktop: desktop ?? design.designSystemSpacing.xl,
      largeDesktop: largeDesktop ?? design.designSystemSpacing.xxl,
    );
  }

  /// Get responsive cross axis spacing for grids
  double responsiveCrossAxisSpacing({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? design.designSystemSpacing.md,
      desktop: desktop ?? design.designSystemSpacing.lg,
      largeDesktop: largeDesktop ?? design.designSystemSpacing.xl,
    );
  }

  /// Get responsive child aspect ratio for grids
  double responsiveChildAspectRatio({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive container width
  double responsiveWidth({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive container height
  double responsiveHeight({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive max width constraint
  double responsiveMaxWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? 1200,
      largeDesktop: largeDesktop ?? 1600,
    );
  }

  /// Get responsive min width constraint
  double responsiveMinWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get font scale factor based on screen size
  double _getFontScaleFactor() {
    switch (screenSize) {
      case ScreenSize.mobile:
        return 1.0;
      case ScreenSize.tablet:
        return 1.1;
      case ScreenSize.desktop:
        return 1.2;
      case ScreenSize.largeDesktop:
        return 1.3;
    }
  }

  /// Build responsive layout based on screen size
  Widget buildResponsiveLayout({
    required BuildContext context,
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? largeDesktop,
  }) {
    return responsiveValue<Widget>(
      context: context,
      mobile: mobile ?? const SizedBox.shrink(),
      tablet: tablet ?? mobile ?? const SizedBox.shrink(),
      desktop: desktop ?? tablet ?? mobile ?? const SizedBox.shrink(),
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? const SizedBox.shrink(),
    );
  }

  /// Get responsive text style based on screen size
  TextStyle responsiveTextStyle({
    required BuildContext context,
    required TextStyle mobile,
    TextStyle? tablet,
    TextStyle? desktop,
    TextStyle? largeDesktop,
  }) {
    return responsiveValue<TextStyle>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile.copyWith(fontSize: (mobile.fontSize ?? 14) * 1.1),
      desktop: desktop ?? (tablet ?? mobile).copyWith(fontSize: (mobile.fontSize ?? 14) * 1.2),
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile).copyWith(fontSize: (mobile.fontSize ?? 14) * 1.3),
    );
  }

  /// Get responsive elevation based on screen size
  double responsiveElevation({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? (tablet ?? mobile) * 1.4,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) * 1.6,
    );
  }

  /// Get responsive border width based on screen size
  double responsiveBorderWidth({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive opacity based on screen size
  double responsiveOpacity({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive animation duration based on screen size
  Duration responsiveAnimationDuration({
    required BuildContext context,
    required Duration mobile,
    Duration? tablet,
    Duration? desktop,
    Duration? largeDesktop,
  }) {
    return responsiveValue<Duration>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? (tablet ?? mobile) * 1.4,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) * 1.6,
    );
  }

  /// Get responsive animation curve based on screen size
  Curve responsiveAnimationCurve({
    required BuildContext context,
    required Curve mobile,
    Curve? tablet,
    Curve? desktop,
    Curve? largeDesktop,
  }) {
    return responsiveValue<Curve>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive scroll physics based on screen size
  ScrollPhysics responsiveScrollPhysics({
    required BuildContext context,
    required ScrollPhysics mobile,
    ScrollPhysics? tablet,
    ScrollPhysics? desktop,
    ScrollPhysics? largeDesktop,
  }) {
    return responsiveValue<ScrollPhysics>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive page size for pagination
  int responsivePageSize({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue<int>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? (mobile * 2).clamp(1, 50),
      desktop: desktop ?? (tablet ?? mobile * 3).clamp(1, 100),
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile * 4).clamp(1, 200),
    );
  }

  /// Get responsive number of visible items
  int responsiveVisibleItemCount({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue<int>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? (mobile + 2).clamp(1, 20),
      desktop: desktop ?? (tablet ?? mobile + 4).clamp(1, 30),
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile + 6).clamp(1, 50),
    );
  }

  /// Get responsive container constraints
  BoxConstraints responsiveConstraints({
    required BuildContext context,
    double? mobileMinWidth,
    double? mobileMaxWidth,
    double? mobileMinHeight,
    double? mobileMaxHeight,
    double? tabletMinWidth,
    double? tabletMaxWidth,
    double? tabletMinHeight,
    double? tabletMaxHeight,
    double? desktopMinWidth,
    double? desktopMaxWidth,
    double? desktopMinHeight,
    double? desktopMaxHeight,
    double? largeDesktopMinWidth,
    double? largeDesktopMaxWidth,
    double? largeDesktopMinHeight,
    double? largeDesktopMaxHeight,
  }) {
    return BoxConstraints(
      minWidth: responsiveMinWidth(context: context, mobile: mobileMinWidth),
      maxWidth: responsiveMaxWidth(context: context, mobile: mobileMaxWidth),
      minHeight: responsiveDouble(
        context: context,
        mobile: mobileMinHeight ?? 0,
        tablet: tabletMinHeight ?? 0,
        desktop: desktopMinHeight ?? 0,
        largeDesktop: largeDesktopMinHeight ?? 0,
      ),
      maxHeight: responsiveDouble(
        context: context,
        mobile: mobileMaxHeight ?? double.infinity,
        tablet: tabletMaxHeight ?? double.infinity,
        desktop: desktopMaxHeight ?? double.infinity,
        largeDesktop: largeDesktopMaxHeight ?? double.infinity,
      ),
    );
  }

  /// Get responsive aspect ratio
  double responsiveAspectRatio({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive alignment based on screen size
  Alignment responsiveAlignment({
    required BuildContext context,
    required Alignment mobile,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveValue<Alignment>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive main axis alignment for flex layouts
  MainAxisAlignment responsiveMainAxisAlignment({
    required BuildContext context,
    required MainAxisAlignment mobile,
    MainAxisAlignment? tablet,
    MainAxisAlignment? desktop,
    MainAxisAlignment? largeDesktop,
  }) {
    return responsiveValue<MainAxisAlignment>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive cross axis alignment for flex layouts
  CrossAxisAlignment responsiveCrossAxisAlignment({
    required BuildContext context,
    required CrossAxisAlignment mobile,
    CrossAxisAlignment? tablet,
    CrossAxisAlignment? desktop,
    CrossAxisAlignment? largeDesktop,
  }) {
    return responsiveValue<CrossAxisAlignment>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive main axis size for flex layouts
  MainAxisSize responsiveMainAxisSize({
    required BuildContext context,
    required MainAxisSize mobile,
    MainAxisSize? tablet,
    MainAxisSize? desktop,
    MainAxisSize? largeDesktop,
  }) {
    return responsiveValue<MainAxisSize>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive flex factor
  int responsiveFlex({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue<int>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive text direction
  TextDirection responsiveTextDirection({
    required BuildContext context,
    required TextDirection mobile,
    TextDirection? tablet,
    TextDirection? desktop,
    TextDirection? largeDesktop,
  }) {
    return responsiveValue<TextDirection>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive text baseline
  TextBaseline responsiveTextBaseline({
    required BuildContext context,
    required TextBaseline mobile,
    TextBaseline? tablet,
    TextBaseline? desktop,
    TextBaseline? largeDesktop,
  }) {
    return responsiveValue<TextBaseline>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive vertical direction
  VerticalDirection responsiveVerticalDirection({
    required BuildContext context,
    required VerticalDirection mobile,
    VerticalDirection? tablet,
    VerticalDirection? desktop,
    VerticalDirection? largeDesktop,
  }) {
    return responsiveValue<VerticalDirection>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive clip behavior
  Clip responsiveClipBehavior({
    required BuildContext context,
    required Clip mobile,
    Clip? tablet,
    Clip? desktop,
    Clip? largeDesktop,
  }) {
    return responsiveValue<Clip>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive hit test behavior
  HitTestBehavior responsiveHitTestBehavior({
    required BuildContext context,
    required HitTestBehavior mobile,
    HitTestBehavior? tablet,
    HitTestBehavior? desktop,
    HitTestBehavior? largeDesktop,
  }) {
    return responsiveValue<HitTestBehavior>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive stack fit
  StackFit responsiveStackFit({
    required BuildContext context,
    required StackFit mobile,
    StackFit? tablet,
    StackFit? desktop,
    StackFit? largeDesktop,
  }) {
    return responsiveValue<StackFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive overflow behavior
  Overflow responsiveOverflow({
    required BuildContext context,
    required Overflow mobile,
    Overflow? tablet,
    Overflow? desktop,
    Overflow? largeDesktop,
  }) {
    return responsiveValue<Overflow>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive axis for scrollable widgets
  Axis responsiveScrollDirection({
    required BuildContext context,
    required Axis mobile,
    Axis? tablet,
    Axis? desktop,
    Axis? largeDesktop,
  }) {
    return responsiveValue<Axis>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive scroll controller behavior
  ScrollController responsiveScrollController({
    required BuildContext context,
    bool mobileKeepAlive = false,
    bool tabletKeepAlive = false,
    bool desktopKeepAlive = true,
    bool largeDesktopKeepAlive = true,
  }) {
    return ScrollController(keepScrollOffset: responsiveValue<bool>(
      context: context,
      mobile: mobileKeepAlive,
      tablet: tabletKeepAlive,
      desktop: desktopKeepAlive,
      largeDesktop: largeDesktopKeepAlive,
    ));
  }

  /// Get responsive sliver grid delegate
  SliverGridDelegate responsiveSliverGridDelegate({
    required BuildContext context,
    required SliverGridDelegate mobile,
    SliverGridDelegate? tablet,
    SliverGridDelegate? desktop,
    SliverGridDelegate? largeDesktop,
  }) {
    return responsiveValue<SliverGridDelegate>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive sliver grid delegate with fixed cross axis count
  SliverGridDelegateWithFixedCrossAxisCount responsiveSliverGridDelegateWithFixedCrossAxisCount({
    required BuildContext context,
    required int mobileCrossAxisCount,
    int? tabletCrossAxisCount,
    int? desktopCrossAxisCount,
    int? largeDesktopCrossAxisCount,
    double mobileMainAxisSpacing = 0.0,
    double? tabletMainAxisSpacing,
    double? desktopMainAxisSpacing,
    double? largeDesktopMainAxisSpacing,
    double mobileCrossAxisSpacing = 0.0,
    double? tabletCrossAxisSpacing,
    double? desktopCrossAxisSpacing,
    double? largeDesktopCrossAxisSpacing,
    double mobileChildAspectRatio = 1.0,
    double? tabletChildAspectRatio,
    double? desktopChildAspectRatio,
    double? largeDesktopChildAspectRatio,
  }) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: responsiveGridCount(
        context: context,
        mobile: mobileCrossAxisCount,
        tablet: tabletCrossAxisCount,
        desktop: desktopCrossAxisCount,
        largeDesktop: largeDesktopCrossAxisCount,
      ),
      mainAxisSpacing: responsiveMainAxisSpacing(
        context: context,
        mobile: mobileMainAxisSpacing,
        tablet: tabletMainAxisSpacing,
        desktop: desktopMainAxisSpacing,
        largeDesktop: largeDesktopMainAxisSpacing,
      ),
      crossAxisSpacing: responsiveCrossAxisSpacing(
        context: context,
        mobile: mobileCrossAxisSpacing,
        tablet: tabletCrossAxisSpacing,
        desktop: desktopCrossAxisSpacing,
        largeDesktop: largeDesktopCrossAxisSpacing,
      ),
      childAspectRatio: responsiveChildAspectRatio(
        context: context,
        mobile: mobileChildAspectRatio,
        tablet: tabletChildAspectRatio,
        desktop: desktopChildAspectRatio,
        largeDesktop: largeDesktopChildAspectRatio,
      ),
    );
  }

  /// Get responsive sliver grid delegate with max cross axis extent
  SliverGridDelegateWithMaxCrossAxisExtent responsiveSliverGridDelegateWithMaxCrossAxisExtent({
    required BuildContext context,
    required double mobileMaxCrossAxisExtent,
    double? tabletMaxCrossAxisExtent,
    double? desktopMaxCrossAxisExtent,
    double? largeDesktopMaxCrossAxisExtent,
    double mobileMainAxisSpacing = 0.0,
    double? tabletMainAxisSpacing,
    double? desktopMainAxisSpacing,
    double? largeDesktopMainAxisSpacing,
    double mobileCrossAxisSpacing = 0.0,
    double? tabletCrossAxisSpacing,
    double? desktopCrossAxisSpacing,
    double? largeDesktopCrossAxisSpacing,
    double mobileChildAspectRatio = 1.0,
    double? tabletChildAspectRatio,
    double? desktopChildAspectRatio,
    double? largeDesktopChildAspectRatio,
  }) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: responsiveDouble(
        context: context,
        mobile: mobileMaxCrossAxisExtent,
        tablet: tabletMaxCrossAxisExtent,
        desktop: desktopMaxCrossAxisExtent,
        largeDesktop: largeDesktopMaxCrossAxisExtent,
      ),
      mainAxisSpacing: responsiveMainAxisSpacing(
        context: context,
        mobile: mobileMainAxisSpacing,
        tablet: tabletMainAxisSpacing,
        desktop: desktopMainAxisSpacing,
        largeDesktop: largeDesktopMainAxisSpacing,
      ),
      crossAxisSpacing: responsiveCrossAxisSpacing(
        context: context,
        mobile: mobileCrossAxisSpacing,
        tablet: tabletCrossAxisSpacing,
        desktop: desktopCrossAxisSpacing,
        largeDesktop: largeDesktopCrossAxisSpacing,
      ),
      childAspectRatio: responsiveChildAspectRatio(
        context: context,
        mobile: mobileChildAspectRatio,
        tablet: tabletChildAspectRatio,
        desktop: desktopChildAspectRatio,
        largeDesktop: largeDesktopChildAspectRatio,
      ),
    );
  }

  /// Get responsive list view builder
  ListView responsiveListView({
    required BuildContext context,
    required NullableIndexedWidgetBuilder mobileItemBuilder,
    NullableIndexedWidgetBuilder? tabletItemBuilder,
    NullableIndexedWidgetBuilder? desktopItemBuilder,
    NullableIndexedWidgetBuilder? largeDesktopItemBuilder,
    int? mobileItemCount,
    int? tabletItemCount,
    int? desktopItemCount,
    int? largeDesktopItemCount,
    ScrollPhysics? mobilePhysics,
    ScrollPhysics? tabletPhysics,
    ScrollPhysics? desktopPhysics,
    ScrollPhysics? largeDesktopPhysics,
    bool mobileShrinkWrap = false,
    bool? tabletShrinkWrap,
    bool? desktopShrinkWrap,
    bool? largeDesktopShrinkWrap,
    ScrollController? scrollController,
  }) {
    return ListView.builder(
      itemBuilder: responsiveValue<NullableIndexedWidgetBuilder>(
        context: context,
        mobile: mobileItemBuilder,
        tablet: tabletItemBuilder ?? mobileItemBuilder,
        desktop: desktopItemBuilder ?? tabletItemBuilder ?? mobileItemBuilder,
        largeDesktop: largeDesktopItemBuilder ?? desktopItemBuilder ?? tabletItemBuilder ?? mobileItemBuilder,
      ),
      itemCount: responsiveValue<int?>(
        context: context,
        mobile: mobileItemCount,
        tablet: tabletItemCount ?? mobileItemCount,
        desktop: desktopItemCount ?? tabletItemCount ?? mobileItemCount,
        largeDesktop: largeDesktopItemCount ?? desktopItemCount ?? tabletItemCount ?? mobileItemCount,
      ),
      physics: responsiveScrollPhysics(
        context: context,
        mobile: mobilePhysics ?? const AlwaysScrollableScrollPhysics(),
        tablet: tabletPhysics ?? const AlwaysScrollableScrollPhysics(),
        desktop: desktopPhysics ?? const AlwaysScrollableScrollPhysics(),
        largeDesktop: largeDesktopPhysics ?? const AlwaysScrollableScrollPhysics(),
      ),
      shrinkWrap: responsiveValue<bool>(
        context: context,
        mobile: mobileShrinkWrap,
        tablet: tabletShrinkWrap ?? mobileShrinkWrap,
        desktop: desktopShrinkWrap ?? tabletShrinkWrap ?? mobileShrinkWrap,
        largeDesktop: largeDesktopShrinkWrap ?? desktopShrinkWrap ?? tabletShrinkWrap ?? mobileShrinkWrap,
      ),
      controller: scrollController,
    );
  }

  /// Get responsive grid view builder
  GridView responsiveGridView({
    required BuildContext context,
    required SliverGridDelegate mobileGridDelegate,
    SliverGridDelegate? tabletGridDelegate,
    SliverGridDelegate? desktopGridDelegate,
    SliverGridDelegate? largeDesktopGridDelegate,
    required NullableIndexedWidgetBuilder mobileItemBuilder,
    NullableIndexedWidgetBuilder? tabletItemBuilder,
    NullableIndexedWidgetBuilder? desktopItemBuilder,
    NullableIndexedWidgetBuilder? largeDesktopItemBuilder,
    int? mobileItemCount,
    int? tabletItemCount,
    int? desktopItemCount,
    int? largeDesktopItemCount,
    ScrollPhysics? mobilePhysics,
    ScrollPhysics? tabletPhysics,
    ScrollPhysics? desktopPhysics,
    ScrollPhysics? largeDesktopPhysics,
    bool mobileShrinkWrap = false,
    bool? tabletShrinkWrap,
    bool? desktopShrinkWrap,
    bool? largeDesktopShrinkWrap,
    ScrollController? scrollController,
  }) {
    return GridView.builder(
      gridDelegate: responsiveSliverGridDelegate(
        context: context,
        mobile: mobileGridDelegate,
        tablet: tabletGridDelegate ?? mobileGridDelegate,
        desktop: desktopGridDelegate ?? tabletGridDelegate ?? mobileGridDelegate,
        largeDesktop: largeDesktopGridDelegate ?? desktopGridDelegate ?? tabletGridDelegate ?? mobileGridDelegate,
      ),
      itemBuilder: responsiveValue<NullableIndexedWidgetBuilder>(
        context: context,
        mobile: mobileItemBuilder,
        tablet: tabletItemBuilder ?? mobileItemBuilder,
        desktop: desktopItemBuilder ?? tabletItemBuilder ?? mobileItemBuilder,
        largeDesktop: largeDesktopItemBuilder ?? desktopItemBuilder ?? tabletItemBuilder ?? mobileItemBuilder,
      ),
      itemCount: responsiveValue<int?>(
        context: context,
        mobile: mobileItemCount,
        tablet: tabletItemCount ?? mobileItemCount,
        desktop: desktopItemCount ?? tabletItemCount ?? mobileItemCount,
        largeDesktop: largeDesktopItemCount ?? desktopItemCount ?? tabletItemCount ?? mobileItemCount,
      ),
      physics: responsiveScrollPhysics(
        context: context,
        mobile: mobilePhysics ?? const AlwaysScrollableScrollPhysics(),
        tablet: tabletPhysics ?? const AlwaysScrollableScrollPhysics(),
        desktop: desktopPhysics ?? const AlwaysScrollableScrollPhysics(),
        largeDesktop: largeDesktopPhysics ?? const AlwaysScrollableScrollPhysics(),
      ),
      shrinkWrap: responsiveValue<bool>(
        context: context,
        mobile: mobileShrinkWrap,
        tablet: tabletShrinkWrap ?? mobileShrinkWrap,
        desktop: desktopShrinkWrap ?? tabletShrinkWrap ?? mobileShrinkWrap,
        largeDesktop: largeDesktopShrinkWrap ?? desktopShrinkWrap ?? tabletShrinkWrap ?? mobileShrinkWrap,
      ),
      controller: scrollController,
    );
  }

  /// Get responsive wrap cross axis alignment
  WrapCrossAlignment responsiveWrapCrossAxisAlignment({
    required BuildContext context,
    required WrapCrossAlignment mobile,
    WrapCrossAlignment? tablet,
    WrapCrossAlignment? desktop,
    WrapCrossAlignment? largeDesktop,
  }) {
    return responsiveValue<WrapCrossAlignment>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive wrap alignment
  WrapAlignment responsiveWrapAlignment({
    required BuildContext context,
    required WrapAlignment mobile,
    WrapAlignment? tablet,
    WrapAlignment? desktop,
    WrapAlignment? largeDesktop,
  }) {
    return responsiveValue<WrapAlignment>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive wrap spacing
  double responsiveWrapSpacing({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive wrap run spacing
  double responsiveWrapRunSpacing({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive positioned fill
  double responsivePositionedFill({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive positioned width factor
  double responsivePositionedWidthFactor({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 1.0,
      tablet: tablet ?? 1.0,
      desktop: desktop ?? 1.0,
      largeDesktop: largeDesktop ?? 1.0,
    );
  }

  /// Get responsive positioned height factor
  double responsivePositionedHeightFactor({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 1.0,
      tablet: tablet ?? 1.0,
      desktop: desktop ?? 1.0,
      largeDesktop: largeDesktop ?? 1.0,
    );
  }

  /// Get responsive positioned left
  double responsivePositionedLeft({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive positioned top
  double responsivePositionedTop({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive positioned right
  double responsivePositionedRight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive positioned bottom
  double responsivePositionedBottom({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive sized box width
  double responsiveSizedBoxWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive sized box height
  double responsiveSizedBoxHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive divider thickness
  double responsiveDividerThickness({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive divider height
  double responsiveDividerHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 16,
      tablet: tablet ?? 24,
      desktop: desktop ?? 32,
      largeDesktop: largeDesktop ?? 48,
    );
  }

  /// Get responsive divider indent
  double responsiveDividerIndent({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive divider end indent
  double responsiveDividerEndIndent({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? 0,
      tablet: tablet ?? 0,
      desktop: desktop ?? 0,
      largeDesktop: largeDesktop ?? 0,
    );
  }

  /// Get responsive card elevation
  double responsiveCardElevation({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? (tablet ?? mobile) * 2,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) * 2.5,
    );
  }

  /// Get responsive app bar elevation
  double responsiveAppBarElevation({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile + 1,
      desktop: desktop ?? (tablet ?? mobile) + 2,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) + 3,
    );
  }

  /// Get responsive bottom navigation elevation
  double responsiveBottomNavigationElevation({
    required BuildContext context,
    double mobile = 8.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive floating action button elevation
  double responsiveFloatingActionButtonElevation({
    required BuildContext context,
    double mobile = 6.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive dialog elevation
  double responsiveDialogElevation({
    required BuildContext context,
    double mobile = 24.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive menu elevation
  double responsiveMenuElevation({
    required BuildContext context,
    double mobile = 8.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveElevation(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive tooltip wait duration
  Duration responsiveTooltipWaitDuration({
    required BuildContext context,
    Duration mobile = const Duration(milliseconds: 500),
    Duration? tablet,
    Duration? desktop,
    Duration? largeDesktop,
  }) {
    return responsiveAnimationDuration(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive tooltip show duration
  Duration responsiveTooltipShowDuration({
    required BuildContext context,
    Duration mobile = const Duration(milliseconds: 1500),
    Duration? tablet,
    Duration? desktop,
    Duration? largeDesktop,
  }) {
    return responsiveAnimationDuration(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? (tablet ?? mobile) * 1.4,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) * 1.6,
    );
  }

  /// Get responsive snack bar duration
  Duration responsiveSnackBarDuration({
    required BuildContext context,
    Duration mobile = const Duration(milliseconds: 4000),
    Duration? tablet,
    Duration? desktop,
    Duration? largeDesktop,
  }) {
    return responsiveAnimationDuration(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive animation duration
  Duration responsiveAnimationDuration({
    required BuildContext context,
    Duration mobile = const Duration(milliseconds: 200),
    Duration? tablet,
    Duration? desktop,
    Duration? largeDesktop,
  }) {
    return responsiveAnimationDuration(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? (tablet ?? mobile) * 1.4,
      largeDesktop: largeDesktop ?? (desktop ?? tablet ?? mobile) * 1.6,
    );
  }

  /// Get responsive animation curve
  Curve responsiveAnimationCurve({
    required BuildContext context,
    Curve mobile = Curves.easeInOut,
    Curve? tablet,
    Curve? desktop,
    Curve? largeDesktop,
  }) {
    return responsiveAnimationCurve(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive haptic feedback intensity
  double responsiveHapticFeedbackIntensity({
    required BuildContext context,
    double mobile = 0.5,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive sound volume
  double responsiveSoundVolume({
    required BuildContext context,
    double mobile = 0.7,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive brightness
  Brightness responsiveBrightness({
    required BuildContext context,
    Brightness mobile = Brightness.light,
    Brightness? tablet,
    Brightness? desktop,
    Brightness? largeDesktop,
  }) {
    return responsiveValue<Brightness>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive color opacity
  double responsiveColorOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive blur radius
  double responsiveBlurRadius({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive spread radius
  double responsiveSpreadRadius({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive offset X
  double responsiveOffsetX({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive offset Y
  double responsiveOffsetY({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive scale factor
  double responsiveScaleFactor({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive rotation angle
  double responsiveRotationAngle({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive skew X
  double responsiveSkewX({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive skew Y
  double responsiveSkewY({
    required BuildContext context,
    double mobile = 0.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive matrix4 transform
  Matrix4 responsiveMatrix4Transform({
    required BuildContext context,
    Matrix4? mobile,
    Matrix4? tablet,
    Matrix4? desktop,
    Matrix4? largeDesktop,
  }) {
    return responsiveValue<Matrix4>(
      context: context,
      mobile: mobile ?? Matrix4.identity(),
      tablet: tablet ?? Matrix4.identity(),
      desktop: desktop ?? Matrix4.identity(),
      largeDesktop: largeDesktop ?? Matrix4.identity(),
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image filter quality
  FilterQuality responsiveDecorationImageFilterQuality({
    required BuildContext context,
    FilterQuality mobile = FilterQuality.low,
    FilterQuality? tablet,
    FilterQuality? desktop,
    FilterQuality? largeDesktop,
  }) {
    return responsiveValue<FilterQuality>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image invert colors
  bool responsiveDecorationImageInvertColors({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image is anti alias
  bool responsiveDecorationImageIsAntiAlias({
    required BuildContext context,
    bool mobile = true,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color filter
  ColorFilter? responsiveDecorationImageColorFilter({
    required BuildContext context,
    ColorFilter? mobile,
    ColorFilter? tablet,
    ColorFilter? desktop,
    ColorFilter? largeDesktop,
  }) {
    return responsiveValue<ColorFilter?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image blend mode
  BlendMode responsiveDecorationImageBlendMode({
    required BuildContext context,
    BlendMode mobile = BlendMode.srcOver,
    BlendMode? tablet,
    BlendMode? desktop,
    BlendMode? largeDesktop,
  }) {
    return responsiveValue<BlendMode>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image rect
  Rect responsiveDecorationImageRect({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image filter quality
  FilterQuality responsiveDecorationImageFilterQuality({
    required BuildContext context,
    FilterQuality mobile = FilterQuality.low,
    FilterQuality? tablet,
    FilterQuality? desktop,
    FilterQuality? largeDesktop,
  }) {
    return responsiveValue<FilterQuality>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image invert colors
  bool responsiveDecorationImageInvertColors({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image is anti alias
  bool responsiveDecorationImageIsAntiAlias({
    required BuildContext context,
    bool mobile = true,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color filter
  ColorFilter? responsiveDecorationImageColorFilter({
    required BuildContext context,
    ColorFilter? mobile,
    ColorFilter? tablet,
    ColorFilter? desktop,
    ColorFilter? largeDesktop,
  }) {
    return responsiveValue<ColorFilter?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image blend mode
  BlendMode responsiveDecorationImageBlendMode({
    required BuildContext context,
    BlendMode mobile = BlendMode.srcOver,
    BlendMode? tablet,
    BlendMode? desktop,
    BlendMode? largeDesktop,
  }) {
    return responsiveValue<BlendMode>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image rect
  Rect responsiveDecorationImageRect({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemantics({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image opacity
  double responsiveDecorationImageOpacity({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveColorOpacity(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image color
  Color? responsiveDecorationImageColor({
    required BuildContext context,
    Color? mobile,
    Color? tablet,
    Color? desktop,
    Color? largeDesktop,
  }) {
    return responsiveValue<Color?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image width
  double? responsiveDecorationImageWidth({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image height
  double? responsiveDecorationImageHeight({
    required BuildContext context,
    double? mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveDouble(
      context: context,
      mobile: mobile ?? double.infinity,
      tablet: tablet ?? double.infinity,
      desktop: desktop ?? double.infinity,
      largeDesktop: largeDesktop ?? double.infinity,
    );
  }

  /// Get responsive decoration image scale
  double responsiveDecorationImageScale({
    required BuildContext context,
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveScaleFactor(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image alignment
  Alignment responsiveDecorationImageAlignment({
    required BuildContext context,
    Alignment mobile = Alignment.center,
    Alignment? tablet,
    Alignment? desktop,
    Alignment? largeDesktop,
  }) {
    return responsiveAlignment(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image repeat
  ImageRepeat responsiveDecorationImageRepeat({
    required BuildContext context,
    ImageRepeat mobile = ImageRepeat.noRepeat,
    ImageRepeat? tablet,
    ImageRepeat? desktop,
    ImageRepeat? largeDesktop,
  }) {
    return responsiveValue<ImageRepeat>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image fit
  BoxFit responsiveDecorationImageFit({
    required BuildContext context,
    BoxFit mobile = BoxFit.cover,
    BoxFit? tablet,
    BoxFit? desktop,
    BoxFit? largeDesktop,
  }) {
    return responsiveValue<BoxFit>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image center slice
  Rect responsiveDecorationImageCenterSlice({
    required BuildContext context,
    Rect? mobile,
    Rect? tablet,
    Rect? desktop,
    Rect? largeDesktop,
  }) {
    return responsiveValue<Rect>(
      context: context,
      mobile: mobile ?? Rect.zero,
      tablet: tablet ?? mobile ?? Rect.zero,
      desktop: desktop ?? tablet ?? mobile ?? Rect.zero,
      largeDesktop: largeDesktop ?? desktop ?? tablet ?? mobile ?? Rect.zero,
    );
  }

  /// Get responsive decoration image match text direction
  bool responsiveDecorationImageMatchTextDirection({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image gapless playback
  bool responsiveDecorationImageGaplessPlayback({
    required BuildContext context,
    bool mobile = false,
    bool? tablet,
    bool? desktop,
    bool? largeDesktop,
  }) {
    return responsiveValue<bool>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image semantic label
  String? responsiveDecorationImageSemanticLabel({
    required BuildContext context,
    String? mobile,
    String? tablet,
    String? desktop,
    String? largeDesktop,
  }) {
    return responsiveValue<String?>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? mobile,
      largeDesktop: largeDesktop ?? mobile,
    );
  }

  /// Get responsive decoration image exclude from semantics
  bool responsiveDecorationImageExcludeFromSemanti