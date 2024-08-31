import 'package:musicbud_flutter/models/common_item.dart';

class CategorizedCommonItems {
  final String category;
  final List<CommonItem> items;

  CategorizedCommonItems({required this.category, required this.items});
}
