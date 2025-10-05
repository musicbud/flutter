import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final String? title;
  final List<Widget> items;
  final VoidCallback? onSeeAll;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const HorizontalList({
    Key? key,
    this.title,
    required this.items,
    this.onSeeAll,
    this.spacing = 8.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('See All'),
                  ),
              ],
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: items.expand((child) => [child, SizedBox(width: spacing)]).toList()
              ..removeLast(), // Remove the last spacing
          ),
        ),
      ],
    );
  }
}