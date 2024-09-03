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
  final Widget Function(T item) buildListItem;

  const CommonItemsPage({
    Key? key,
    required this.title,
    required this.fetchItems,
    required this.buildListItem,
  }) : super(key: key);

  @override
  _CommonItemsPageState<T> createState() => _CommonItemsPageState<T>();
}

class _CommonItemsPageState<T> extends State<CommonItemsPage<T>> {
  List<T> _items = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final newItems = await widget.fetchItems(_currentPage);
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading items: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return widget.buildListItem(_items[index]);
          } else if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            _loadItems();
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
