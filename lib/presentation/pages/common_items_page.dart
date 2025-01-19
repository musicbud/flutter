import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/common_items/common_items_bloc.dart';
import '../../blocs/common_items/common_items_event.dart';
import '../../blocs/common_items/common_items_state.dart';
import '../widgets/loading_indicator.dart';

class CommonItemsPage<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function(int page, String? query) fetchItems;
  final Widget Function(BuildContext, T) itemBuilder;
  final bool enableSearch;

  const CommonItemsPage({
    super.key,
    required this.title,
    required this.fetchItems,
    required this.itemBuilder,
    this.enableSearch = false,
  });

  @override
  State<CommonItemsPage<T>> createState() => _CommonItemsPageState<T>();
}

class _CommonItemsPageState<T> extends State<CommonItemsPage<T>> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final CommonItemsBloc<T> _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CommonItemsBloc<T>(fetchItems: widget.fetchItems);
    _loadItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _loadItems() {
    _bloc.add(const CommonItemsRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _bloc.add(CommonItemsLoadMoreRequested());
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _bloc.add(CommonItemsRefreshRequested());
    } else {
      _bloc.add(CommonItemsSearchRequested(query));
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            if (widget.enableSearch)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: _ItemSearchDelegate<T>(
                      itemBuilder: widget.itemBuilder,
                      onSearch: (query) =>
                          _bloc.add(CommonItemsSearchRequested(query)),
                    ),
                  );
                },
              ),
          ],
        ),
        body: BlocConsumer<CommonItemsBloc<T>, CommonItemsState<T>>(
          listener: (context, state) {
            if (state is CommonItemsFailure<T>) {
              _showErrorSnackBar(state.error);
            }
          },
          builder: (context, state) {
            if (state is CommonItemsInitial<T>) {
              _loadItems();
              return const LoadingIndicator();
            }

            if (state is CommonItemsLoading<T>) {
              return const LoadingIndicator();
            }

            if (state is CommonItemsLoaded<T> ||
                state is CommonItemsLoadingMore<T>) {
              final items = state is CommonItemsLoaded<T>
                  ? state.items
                  : (state as CommonItemsLoadingMore<T>).currentItems;

              return RefreshIndicator(
                onRefresh: () async {
                  _bloc.add(CommonItemsRefreshRequested());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length +
                      (state is CommonItemsLoadingMore<T> ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: LoadingIndicator(),
                        ),
                      );
                    }

                    return widget.itemBuilder(context, items[index]);
                  },
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}

class _ItemSearchDelegate<T> extends SearchDelegate<void> {
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(String) onSearch;

  _ItemSearchDelegate({
    required this.itemBuilder,
    required this.onSearch,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return BlocBuilder<CommonItemsBloc<T>, CommonItemsState<T>>(
      builder: (context, state) {
        if (state is CommonItemsLoading<T>) {
          return const LoadingIndicator();
        }

        if (state is CommonItemsLoaded<T>) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('No results found'),
            );
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return itemBuilder(context, state.items[index]);
            },
          );
        }

        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
