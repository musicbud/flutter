import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/widgets/track_list_item.dart';
import 'package:musicbud_flutter/widgets/artist_list_item.dart';
import 'package:musicbud_flutter/widgets/genre_list_item.dart';
import 'package:musicbud_flutter/widgets/album_list_item.dart';

class CommonItemsPage<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function(int page) fetchItems;
  final Widget Function(BuildContext, T) itemBuilder;

  const CommonItemsPage({
    Key? key,
    required this.title,
    required this.fetchItems,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _CommonItemsPageState<T> createState() => _CommonItemsPageState<T>();
}

class _CommonItemsPageState<T> extends State<CommonItemsPage<T>> {
  List<T> _items = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_isLoading || !_hasMoreItems) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await widget.fetchItems(_currentPage);
      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _isLoading = false;
          _currentPage++;
          _hasMoreItems = newItems.isNotEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_items.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_error != null && _items.isEmpty) {
      return Center(child: Text('Error: $_error'));
    } else if (_items.isEmpty) {
      return Center(child: Text('No items found'));
    } else {
      return ListView.builder(
        itemCount: _items.length + (_hasMoreItems ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              _loadItems(); // Load more items when reaching the end
              return SizedBox.shrink();
            }
          }
          return widget.itemBuilder(context, _items[index]);
        },
      );
    }
  }
}
