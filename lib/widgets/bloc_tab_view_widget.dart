import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Configuration for a single tab in BlocTabViewWidget
class BlocTab<B extends StateStreamableSource<S>, S> {
  /// Title of the tab
  final String title;

  /// Optional icon for the tab
  final IconData? icon;

  /// BLoC provider for this tab
  final B Function() blocProvider;

  /// Builder function for tab content
  final Widget Function(BuildContext context, S state) builder;

  /// Optional function to determine if state represents loading
  final bool Function(S state)? isLoading;

  /// Optional custom loading widget
  final Widget? loadingWidget;

  /// Optional badge text to display on tab
  final String? badgeText;

  /// Optional callback when tab is selected
  final void Function()? onTabSelected;

  const BlocTab({
    required this.title,
    this.icon,
    required this.blocProvider,
    required this.builder,
    this.isLoading,
    this.loadingWidget,
    this.badgeText,
    this.onTabSelected,
  });
}

/// A reusable tabbed view widget that integrates with BLoC pattern.
///
/// This widget handles:
/// - Multiple tabs with independent BLoC instances
/// - Per-tab state management
/// - Loading states for each tab
/// - Tab badges for notifications
/// - Lazy loading of tab content
///
/// Example usage:
/// ```dart
/// BlocTabViewWidget(
///   tabs: [
///     BlocTab<PostsBloc, PostsState>(
///       title: 'Posts',
///       icon: Icons.article,
///       blocProvider: () => PostsBloc(),
///       builder: (context, state) {
///         if (state is PostsLoadedState) {
///           return ListView.builder(
///             itemCount: state.posts.length,
///             itemBuilder: (context, index) => PostCard(post: state.posts[index]),
///           );
///         }
///         return Container();
///       },
///       isLoading: (state) => state is PostsLoadingState,
///     ),
///     BlocTab<CommentsBloc, CommentsState>(
///       title: 'Comments',
///       icon: Icons.comment,
///       blocProvider: () => CommentsBloc(),
///       builder: (context, state) {
///         if (state is CommentsLoadedState) {
///           return ListView.builder(
///             itemCount: state.comments.length,
///             itemBuilder: (context, index) => CommentCard(comment: state.comments[index]),
///           );
///         }
///         return Container();
///       },
///       isLoading: (state) => state is CommentsLoadingState,
///       badgeText: '12',
///     ),
///   ],
/// )
/// ```
class BlocTabViewWidget extends StatefulWidget {
  /// List of tabs to display
  final List<BlocTab> tabs;

  /// Initial selected tab index
  final int initialIndex;

  /// Whether tabs should be scrollable
  final bool isScrollable;

  /// Tab bar indicator color
  final Color? indicatorColor;

  /// Tab bar label color
  final Color? labelColor;

  /// Tab bar unselected label color
  final Color? unselectedLabelColor;

  /// Tab bar indicator weight
  final double indicatorWeight;

  /// Whether to show divider below tab bar
  final bool showDivider;

  /// Tab bar elevation
  final double elevation;

  /// Optional app bar title
  final String? appBarTitle;

  /// Optional app bar actions
  final List<Widget>? appBarActions;

  /// Whether to show app bar
  final bool showAppBar;

  /// Optional tab controller
  final TabController? tabController;

  /// Tab bar padding
  final EdgeInsetsGeometry? tabBarPadding;

  /// Tab content padding
  final EdgeInsetsGeometry? contentPadding;

  const BlocTabViewWidget({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 2.0,
    this.showDivider = true,
    this.elevation = 0.0,
    this.appBarTitle,
    this.appBarActions,
    this.showAppBar = false,
    this.tabController,
    this.tabBarPadding,
    this.contentPadding,
  }) : assert(tabs.length > 0, 'At least one tab is required');

  @override
  State<BlocTabViewWidget> createState() => _BlocTabViewWidgetState();
}

class _BlocTabViewWidgetState extends State<BlocTabViewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<dynamic> _blocInstances;

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController ??
        TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.initialIndex,
        );

    // Initialize BLoC instances for each tab
    _blocInstances = widget.tabs.map((tab) => tab.blocProvider()).toList();

    // Listen to tab changes
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    if (widget.tabController == null) {
      _tabController.dispose();
    }
    // Close all BLoC instances
    for (var bloc in _blocInstances) {
      if (bloc is Cubit) {
        bloc.close();
      }
    }
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final tab = widget.tabs[_tabController.index];
      tab.onTabSelected?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: widget.isScrollable,
      indicatorColor: widget.indicatorColor ?? colorScheme.primary,
      labelColor: widget.labelColor ?? colorScheme.primary,
      unselectedLabelColor:
          widget.unselectedLabelColor ?? colorScheme.onSurfaceVariant,
      indicatorWeight: widget.indicatorWeight,
      dividerColor: widget.showDivider ? null : Colors.transparent,
      padding: widget.tabBarPadding,
      tabs: widget.tabs.map((tab) => _buildTab(tab)).toList(),
    );

    final tabBarView = TabBarView(
      controller: _tabController,
      children: widget.tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final bloc = _blocInstances[index];

        return _buildTabWrapper(tab, bloc);
      }).toList(),
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: widget.appBarTitle != null ? Text(widget.appBarTitle!) : null,
          actions: widget.appBarActions,
          elevation: widget.elevation,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: tabBar,
          ),
        ),
        body: tabBarView,
      );
    }

    return Column(
      children: [
        Material(
          elevation: widget.elevation,
          child: tabBar,
        ),
        Expanded(child: tabBarView),
      ],
    );
  }

  Widget _buildTab(BlocTab tab) {
    Widget tabWidget;

    if (tab.icon != null) {
      tabWidget = Tab(
        icon: Icon(tab.icon),
        text: tab.title,
      );
    } else {
      tabWidget = Tab(text: tab.title);
    }

    // Add badge if provided
    if (tab.badgeText != null && tab.badgeText!.isNotEmpty) {
      return Badge(
        label: Text(tab.badgeText!),
        child: tabWidget,
      );
    }

    return tabWidget;
  }

  Widget _buildTabWrapper(BlocTab tab, dynamic bloc) {
    // Cast to proper BLoC type and build content
    return Padding(
      padding: widget.contentPadding ?? EdgeInsets.zero,
      child: _buildTabContentDynamic(tab, bloc),
    );
  }

  Widget _buildTabContentDynamic(BlocTab tab, dynamic bloc) {
    // Use a stream builder to listen to the bloc state
    return StreamBuilder(
      stream: bloc.stream,
      initialData: bloc is StateStreamableSource ? bloc.state : null,
      builder: (context, snapshot) {
        final state = snapshot.data;

        // Show loading indicator if loading state is defined and true
        if (state != null &&
            tab.isLoading != null &&
            tab.isLoading!(state)) {
          return Center(
            child: tab.loadingWidget ?? const CircularProgressIndicator(),
          );
        }

        // Build tab content
        if (state != null) {
          return tab.builder(context, state);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
