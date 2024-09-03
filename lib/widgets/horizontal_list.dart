import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';

class HorizontalList extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final VoidCallback onSeeAll;

  const HorizontalList({
    Key? key,
    required this.title,
    required this.items,
    required this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline6),
            TextButton(onPressed: onSeeAll, child: Text('See All')),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200, // Set a fixed width for each item
                child: items[index],
              );
            },
          ),
        ),
      ],
    );
  }
}