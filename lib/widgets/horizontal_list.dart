import 'package:flutter/material.dart';

class HorizontalList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final Future<void> Function() loadMore;

  const HorizontalList({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.loadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: loadMore,
                );
              }
              return itemBuilder(items[index]);
            },
          ),
        ),
      ],
    );
  }
}