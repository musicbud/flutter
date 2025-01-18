import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/presentation/pages/bud_common_items_page.dart';

class BudMatchListItem extends StatelessWidget {
  final BudMatch budMatch;

  const BudMatchListItem({Key? key, required this.budMatch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(budMatch.bud.username),
      subtitle: Text('Similarity: ${budMatch.similarityScore.toStringAsFixed(2)}'),
      onTap: () {
        if (budMatch.bud.uid.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudCommonItemsPage(
                budId: budMatch.bud.uid,
                budName: budMatch.bud.username,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to view this bud\'s profile')),
          );
        }
      },
    );
  }
}
