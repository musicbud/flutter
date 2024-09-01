import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';

class HorizontalList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const HorizontalList({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
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
          height: 200, // Set a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(items[index]),
          ),
        ),
      ],
    );
  }
}