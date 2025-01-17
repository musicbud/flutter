import 'package:flutter/material.dart';
import 'package:musicbud_flutter/pages/buds_page.dart';
import 'package:musicbud_flutter/utils/string_extensions.dart';

class BudsCategoryPage extends StatelessWidget {
  final List<String> _availableCategories = [
    'liked/artists',
    'liked/tracks',
    'liked/genres',
    'top/artists',
    'top/tracks',
    'top/genres',
    'liked/aio',
    'played/tracks'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bud Categories')),
      body: ListView.builder(
        itemCount: _availableCategories.length,
        itemBuilder: (context, index) {
          String category = _availableCategories[index];
          return _buildCategoryTile(context, _getCategoryTitle(category), index);
        },
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String title, int index) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BudsPage(initialCategoryIndex: index),
          ),
        );
      },
    );
  }

  String _getCategoryTitle(String category) {
    return category.split('/').map((word) => word.capitalize()).join(' ');
  }
}
