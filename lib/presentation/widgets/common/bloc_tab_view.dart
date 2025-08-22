import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import 'app_scaffold.dart';
import 'app_app_bar.dart';

/// A dynamic tab view component that integrates with the BLoC pattern
class BlocTabView<TBloc extends Bloc<TEvent, TState>, TState, TEvent> extends StatefulWidget {
  final String title;
  final List<BlocTab<TState, TEvent>> tabs;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;

  const BlocTabView({
    Key? key,
    required this.title,
    required this.tabs,
    this.showAppBar = true,
    this.appBarActions,
    this.padding,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  State<BlocTabView<TBloc, TState, TEvent>> createState() => _BlocTabViewState<TBloc, TState, TEvent>();
}

class _BlocTabViewState<TBloc extends Bloc<TEvent, TState>, TState, TEvent> extends State<BlocTabView<TBloc, TState, TEvent>>
    with TickerProviderStateMixin, PageMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial tab data
    if (widget.tabs.isNotEmpty && widget.tabs[0].loadEvent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TBloc>().add(widget.tabs[0].loadEvent!);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });

      final currentTab = widget.tabs[_currentTabIndex];
      if (currentTab.loadEvent != null) {
        context.read<TBloc>().add(currentTab.loadEvent!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: widget.showAppBar
          ? AppAppBar(
              title: widget.title,
              actions: widget.appBarActions,
            )
          : null,
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabBarView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: widget.tabs.map((tab) => Tab(
          text: tab.title,
          icon: tab.icon,
        )).toList(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return BlocBuilder<TBloc, TState>(
      builder: (context, state) {
        return TabBarView(
          controller: _tabController,
          children: widget.tabs.map((tab) => _buildTabContent(tab, state)).toList(),
        );
      },
    );
  }

  Widget _buildTabContent(BlocTab<TState, TEvent> tab, TState state) {
    // Handle loading state
    if (tab.isLoading != null && tab.isLoading!(state)) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle error state
    if (tab.isError != null && tab.isError!(state)) {
      final errorMessage = tab.getErrorMessage?.call(state) ?? 'An error occurred';
      return _buildErrorWidget(errorMessage);
    }

    // Handle custom state widget
    if (tab.customStateWidget != null) {
      final customWidget = tab.customStateWidget!(state);
      if (customWidget != null) {
        return customWidget;
      }
    }

    // Build main content
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: tab.builder(context, state),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.errorColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Configuration for a single tab in BlocTabView
class BlocTab<TState, TEvent> {
  final String title;
  final Widget? icon;
  final Widget Function(BuildContext context, TState state) builder;
  final TEvent? loadEvent;
  final bool Function(TState state)? isLoading;
  final bool Function(TState state)? isError;
  final String Function(TState state)? getErrorMessage;
  final Widget Function(TState state)? customStateWidget;

  const BlocTab({
    required this.title,
    required this.builder,
    this.icon,
    this.loadEvent,
    this.isLoading,
    this.isError,
    this.getErrorMessage,
    this.customStateWidget,
  });
}

/// Simplified category-based tab view for common use cases
class CategoryTabView<TBloc extends Bloc<TEvent, TState>, TState, TEvent, TItem> extends StatefulWidget {
  final String title;
  final List<String> categories;
  final TEvent Function(String category) getCategoryEvent;
  final List<TItem> Function(TState state, String category) getItems;
  final bool Function(TState state) isLoading;
  final bool Function(TState state) isError;
  final String Function(TState state)? getErrorMessage;
  final Widget Function(BuildContext context, TItem item, int index) itemBuilder;
  final String Function(String category)? getCategoryTitle;
  final int initialCategoryIndex;
  final bool showAppBar;
  final List<Widget>? appBarActions;

  const CategoryTabView({
    Key? key,
    required this.title,
    required this.categories,
    required this.getCategoryEvent,
    required this.getItems,
    required this.isLoading,
    required this.isError,
    required this.itemBuilder,
    this.getErrorMessage,
    this.getCategoryTitle,
    this.initialCategoryIndex = 0,
    this.showAppBar = true,
    this.appBarActions,
  }) : super(key: key);

  @override
  State<CategoryTabView<TBloc, TState, TEvent, TItem>> createState() =>
      _CategoryTabViewState<TBloc, TState, TEvent, TItem>();
}

class _CategoryTabViewState<TBloc extends Bloc<TEvent, TState>, TState, TEvent, TItem>
    extends State<CategoryTabView<TBloc, TState, TEvent, TItem>> with TickerProviderStateMixin, PageMixin {
  late TabController _tabController;
  late String _currentCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
      initialIndex: widget.initialCategoryIndex,
    );
    _currentCategory = widget.categories[widget.initialCategoryIndex];
    _tabController.addListener(_onTabChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TBloc>().add(widget.getCategoryEvent(_currentCategory));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentCategory = widget.categories[_tabController.index];
      });

      context.read<TBloc>().add(widget.getCategoryEvent(_currentCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: widget.showAppBar
          ? AppAppBar(
              title: widget.title,
              actions: widget.appBarActions,
            )
          : null,
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.categories.length > 4,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: widget.categories.map((category) => Tab(
          text: widget.getCategoryTitle?.call(category) ?? category,
        )).toList(),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<TBloc, TState>(
      builder: (context, state) {
        if (widget.isLoading(state)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.isError(state)) {
          final errorMessage = widget.getErrorMessage?.call(state) ?? 'An error occurred';
          return _buildErrorWidget(errorMessage);
        }

        final items = widget.getItems(state, _currentCategory);

        if (items.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => widget.itemBuilder(context, items[index], index),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.errorColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category',
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}