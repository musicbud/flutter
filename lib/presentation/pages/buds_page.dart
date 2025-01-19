import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/bud/bud_bloc.dart';
import 'package:musicbud_flutter/blocs/bud/bud_event.dart';
import 'package:musicbud_flutter/blocs/bud/bud_state.dart';
import 'package:musicbud_flutter/models/bud.dart';
import 'package:musicbud_flutter/presentation/widgets/bud_match_list_item.dart';
import 'package:musicbud_flutter/utils/string_extensions.dart';

class BudsPage extends StatefulWidget {
  final int initialCategoryIndex;

  const BudsPage({Key? key, this.initialCategoryIndex = 0}) : super(key: key);

  @override
  _BudsPageState createState() => _BudsPageState();
}

class _BudsPageState extends State<BudsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'liked/artists',
    'liked/tracks',
    'liked/genres',
    'top/artists',
    'top/tracks',
    'top/genres',
    'played/tracks'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
      initialIndex: widget.initialCategoryIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buds'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories
              .map((category) => Tab(text: _getCategoryTitle(category)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories
            .map((category) => _BudsList(category: category))
            .toList(),
      ),
    );
  }

  String _getCategoryTitle(String category) {
    return category.split('/').map((word) => word.capitalize()).join(' ');
  }
}

class _BudsList extends StatefulWidget {
  final String category;

  const _BudsList({Key? key, required this.category}) : super(key: key);

  @override
  __BudsListState createState() => __BudsListState();
}

class __BudsListState extends State<_BudsList> {
  @override
  void initState() {
    super.initState();
    _fetchBuds();
  }

  void _fetchBuds() {
    final event = _getCategoryEvent(widget.category);
    if (event != null) {
      context.read<BudBloc>().add(event);
    }
  }

  BudEvent? _getCategoryEvent(String category) {
    switch (category) {
      case 'liked/artists':
        return BudsByLikedArtistsRequested();
      case 'liked/tracks':
        return BudsByLikedTracksRequested();
      case 'liked/genres':
        return BudsByLikedGenresRequested();
      case 'top/artists':
        return BudsByTopArtistsRequested();
      case 'top/tracks':
        return BudsByTopTracksRequested();
      case 'top/genres':
        return BudsByTopGenresRequested();
      case 'played/tracks':
        return BudsByPlayedTracksRequested();
      default:
        return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudBloc, BudState>(
      listener: (context, state) {
        if (state is BudFailure) {
          _showSnackBar('Error: ${state.error}');
        }
      },
      builder: (context, state) {
        if (state is BudLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BudsLoaded) {
          if (state.buds.isEmpty) {
            return Center(child: Text('No buds found for ${widget.category}'));
          }

          return ListView.builder(
            itemCount: state.buds.length,
            itemBuilder: (context, index) {
              return BudMatchListItem(budMatch: state.buds[index]);
            },
          );
        }

        return const Center(child: Text('Failed to load buds'));
      },
    );
  }
}
