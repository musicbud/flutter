import 'package:flutter/material.dart';

class HorizontalList<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Future<void> Function() loadMore;

  const HorizontalList({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.loadMore,
  }) : super(key: key);

  @override
  _HorizontalListState<T> createState() => _HorizontalListState<T>();
}

class _HorizontalListState<T> extends State<HorizontalList<T>> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.items.length) {
                return _buildLoadMoreButton();
              }
              return widget.itemBuilder(widget.items[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _isLoading ? null : _loadMore,
          child: _isLoading ? CircularProgressIndicator() : Text('Load More'),
        ),
      ),
    );
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await widget.loadMore();

    setState(() {
      _isLoading = false;
    });
  }
}