import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/common_item.dart';
import 'package:musicbud_flutter/models/categorized_common_items.dart';

class CommonItemsPage extends StatefulWidget {
  final String budId;
  final ApiService apiService;

  const CommonItemsPage({
    Key? key,
    required this.budId,
    required this.apiService,
  }) : super(key: key);

  @override
  _CommonItemsPageState createState() => _CommonItemsPageState();
}

class _CommonItemsPageState extends State<CommonItemsPage> {
  late Future<List<CategorizedCommonItems>> _commonItemsFuture;

  @override
  void initState() {
    super.initState();
    _commonItemsFuture = widget.apiService.getAllCommonItems(widget.budId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Common Items'),
      ),
      body: FutureBuilder<List<CategorizedCommonItems>>(
        future: _commonItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No common items found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return _buildCategorySection(category);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCategorySection(CategorizedCommonItems category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category.category,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: category.items.length,
          itemBuilder: (context, index) {
            final item = category.items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: item.artist != null ? Text(item.artist!) : null,
              leading: item.imageUrl != null
                  ? Image.network(item.imageUrl!, width: 50, height: 50)
                  : null,
            );
          },
        ),
        Divider(),
      ],
    );
  }
}
