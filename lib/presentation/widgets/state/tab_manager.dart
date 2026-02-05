import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A reusable tab manager widget for handling tab switching and content loading.
/// Provides consistent tab styling and state management across the app.
///
/// Features:
/// - Customizable tab items with icons and labels
/// - Content loading for each tab
/// - Loading states for tab content
/// - Consistent styling and animations
/// - Scrollable tabs support
/// - Customizable tab bar styling
class TabManager extends StatefulWidget {
  /// List of tab items to display
  final List<TabItem> tabs;

  /// Builder function for tab content
  final Widget Function(BuildContext context, TabItem tab) contentBuilder;

  /// Initial tab index to select
  final int initialIndex;

  /// Whether tabs should be scrollable
  final bool isScrollable;

  /// Height of the tab bar
  final double tabBarHeight;

  /// Background color of the tab bar
  final Color? tabBarBackgroundColor;

  /// Color of the selected tab indicator
  final Color? indicatorColor;

  /// Text style for tab labels
  final TextStyle? labelStyle;

  /// Text style for selected tab labels
  final TextStyle? selectedLabelStyle;

  /// Padding around the tab content
  final EdgeInsetsGeometry? contentPadding;

  /// Whether to show a loading state while switching tabs
  final bool showLoadingOnTabChange;

  /// Custom loading indicator for tab content
  final Widget? loadingIndicator;

  /// Callback when a tab is selected
  final ValueChanged<int>? onTabChanged;

  /// Controller for the TabController
  final TabController? controller;

  const TabManager({
    super.key,
    required this.tabs,
    required this.contentBuilder,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.tabBarHeight = 48,
    this.tabBarBackgroundColor,
    this.indicatorColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.contentPadding,
    this.showLoadingOnTabChange = false,
    this.loadingIndicator,
    this.onTabChanged,
    this.controller,
  });

  @override
  State<TabManager> createState() => _TabManagerState();
}

class _TabManagerState extends State<TabManager> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = widget.controller ?? TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      _isLoading = widget.showLoadingOnTabChange;
    });

    widget.onTabChanged?.call(_tabController.index);

    // Simulate loading delay if needed
    if (widget.showLoadingOnTabChange) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          height: widget.tabBarHeight,
          color: widget.tabBarBackgroundColor ?? DesignSystem.surface,
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs.map((tab) => _buildTab(tab)).toList(),
            isScrollable: widget.isScrollable,
            indicatorColor: widget.indicatorColor ?? DesignSystem.primary,
            indicatorWeight: 3,
            labelStyle: widget.selectedLabelStyle ?? DesignSystem.labelLarge.copyWith(
              color: DesignSystem.primary,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: widget.labelStyle ?? DesignSystem.labelLarge.copyWith(
              color: DesignSystem.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: DesignSystem.border,
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) {
              return Padding(
                padding: widget.contentPadding ?? EdgeInsets.zero,
                child: _isLoading && widget.showLoadingOnTabChange
                    ? _buildLoadingContent()
                    : widget.contentBuilder(context, tab),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(TabItem tab) {
    return Tab(
      icon: tab.icon != null ? Icon(tab.icon) : null,
      text: tab.label,
      iconMargin: tab.icon != null ? const EdgeInsets.only(bottom: 4) : null,
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: widget.loadingIndicator ?? const CircularProgressIndicator(),
    );
  }
}

/// Represents a single tab item with label and optional icon
class TabItem {
  /// The label text for the tab
  final String label;

  /// Optional icon for the tab
  final IconData? icon;

  /// Optional unique key for the tab
  final String? key;

  /// Optional metadata for the tab
  final Map<String, dynamic>? metadata;

  const TabItem({
    required this.label,
    this.icon,
    this.key,
    this.metadata,
  });
}
