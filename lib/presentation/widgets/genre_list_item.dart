import 'package:flutter/material.dart';
import '../../../models/genre.dart';

class GenreListItem extends StatelessWidget {
  final Genre genre;
  final VoidCallback? onTap;

  const GenreListItem({
    Key? key,
    required this.genre,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              genre.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}