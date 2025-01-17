import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/widgets/bud_match_list_item.dart';
import 'package:musicbud_flutter/utils/string_extensions.dart';

class BudsPage extends StatefulWidget {
  final int initialCategoryIndex;

  const BudsPage({Key? key, this.initialCategoryIndex = 0}) : super(key: key);

  @override
  _BudsPageState createState() => _BudsPageState();
}

class _BudsPageState extends State<BudsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'liked/artists',
    'liked/tracks',
    'liked/genres',
    'top/artists',
    'top/tracks',
    'top/genres',
    'played/tracks'
  ]; // Removed 'liked/aio'

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
          tabs: _categories.map((category) => Tab(text: _getCategoryTitle(category))).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) => _BudsList(category: category)).toList(),
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
  late Future<List<BudMatch>> _budsFuture;

  @override
  void initState() {
    super.initState();
    _budsFuture = _fetchBuds();
  }

  Future<List<BudMatch>> _fetchBuds() async {
    final apiService = ApiService();
    try {
      return await apiService.getBuds(widget.category);
    } catch (e) {
      print('Error fetching buds from ${widget.category}: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BudMatch>>(
      future: _budsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No buds found for ${widget.category}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return BudMatchListItem(budMatch: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

