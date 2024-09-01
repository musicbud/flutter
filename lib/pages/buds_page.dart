import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/pages/common_items_page.dart';

class BudsPage extends StatefulWidget {
  final ApiService apiService;

  const BudsPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _BudsPageState createState() => _BudsPageState();
}

class _BudsPageState extends State<BudsPage> {
  Map<String, List<BudMatch>> _budCategories = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBuds();
  }

  Future<void> _loadBuds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final categories = {
        'Top Tracks': '/bud/top/tracks',
        'Top Artists': '/bud/top/artists',
        'Top Genres': '/bud/top/genres',
        'Liked Albums': '/bud/liked/albums',
        'Liked Tracks': '/bud/liked/tracks',
        'Liked Artists': '/bud/liked/artists',
        'Liked Genres': '/bud/liked/genres',
        'Played Tracks': '/bud/played/tracks',
        'Top Anime': '/bud/top/anime',
        'Top Manga': '/bud/top/manga',
      };

      for (var entry in categories.entries) {
        final buds = await widget.apiService.getBuds(entry.value);
        if (buds.isNotEmpty) {
          _budCategories[entry.key] = buds;
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load buds: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_budCategories.isEmpty) {
      return Center(child: Text('No buds found in any category.'));
    }

    return ListView.builder(
      itemCount: _budCategories.length,
      itemBuilder: (context, index) {
        final category = _budCategories.keys.elementAt(index);
        final budMatches = _budCategories[category]!;
        return _buildCategorySection(category, budMatches);
      },
    );
  }

  Widget _buildCategorySection(String category, List<BudMatch> budMatches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: budMatches.length,
          itemBuilder: (context, index) {
            final budMatch = budMatches[index];
            final bud = budMatch.bud;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: bud.photoUrl != null ? NetworkImage(bud.photoUrl!) : null,
                child: bud.photoUrl == null ? Text(bud.username[0].toUpperCase()) : null,
              ),
              title: Text(bud.displayName ?? bud.username),
              subtitle: Text('Similarity: ${budMatch.similarityScore.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommonItemsPage(
                      budId: bud.uid,
                      apiService: widget.apiService,
                    ),
                  ),
                );
              },
            );
          },
        ),
        Divider(),
      ],
    );
  }
}

