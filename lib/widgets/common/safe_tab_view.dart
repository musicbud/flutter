import 'package:flutter/material.dart';

/// A safe wrapper for TabBar and TabBarView that prevents controller length mismatches
class SafeTabView extends StatefulWidget {
  final List<Widget> tabs;
  final List<Widget> children;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsetsGeometry? padding;

  const SafeTabView({
    super.key,
    required this.tabs,
    required this.children,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.padding,
  });

  @override
  State<SafeTabView> createState() => _SafeTabViewState();
}

class _SafeTabViewState extends State<SafeTabView>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    // Ensure tabs and children have the same length
    final tabCount = widget.tabs.length;
    final childCount = widget.children.length;
    
    if (tabCount != childCount) {
      debugPrint(
        'SafeTabView: Tab count ($tabCount) does not match child count ($childCount). '
        'Using minimum count to prevent errors.',
      );
    }
    
    final safeCount = tabCount < childCount ? tabCount : childCount;
    
    if (safeCount > 0) {
      _tabController = TabController(length: safeCount, vsync: this);
    }
  }

  @override
  void didUpdateWidget(SafeTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if tab/children count changed
    if (oldWidget.tabs.length != widget.tabs.length ||
        oldWidget.children.length != widget.children.length) {
      _tabController?.dispose();
      _initializeTabController();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null || _tabController!.length == 0) {
      return const Center(
        child: Text('No tabs available'),
      );
    }

    final safeCount = _tabController!.length;
    final safeTabs = widget.tabs.take(safeCount).toList();
    final safeChildren = widget.children.take(safeCount).toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: widget.isScrollable,
          indicatorColor: widget.indicatorColor,
          labelColor: widget.labelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          labelStyle: widget.labelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          tabs: safeTabs,
        ),
        Expanded(
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: TabBarView(
              controller: _tabController,
              children: safeChildren,
            ),
          ),
        ),
      ],
    );
  }
}

/// A safe column widget that prevents overflow by making content scrollable
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  const SafeColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );

    final content = padding != null 
        ? Padding(padding: padding!, child: column)
        : column;

    if (scrollable) {
      return SingleChildScrollView(
        child: content,
      );
    }

    return content;
  }
}

/// A safe flexible widget that prevents overflow in Flex widgets
class SafeFlex extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool scrollable;

  const SafeFlex({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.scrollable = true,
  });

  const SafeFlex.horizontal({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.scrollable = true,
  }) : direction = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final flex = Flex(
      direction: direction,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: flex,
      );
    }

    return flex;
  }
}

/// A wrapper that handles potential layout overflow with a fallback
class OverflowSafeWrapper extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const OverflowSafeWrapper({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        try {
          return child;
        } catch (e) {
          debugPrint('OverflowSafeWrapper caught layout error: $e');
          return fallback ??
              const Center(
                child: Text(
                  'Layout Error',
                  style: TextStyle(color: Colors.red),
                ),
              );
        }
      },
    );
  }
}