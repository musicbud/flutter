import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const OutlinedCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
