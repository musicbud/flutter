import 'package:flutter/material.dart';
import '../../domain/models/bud_match.dart';
import '../pages/bud_common_items_page.dart';

class BudMatchListItem extends StatelessWidget {
  final BudMatch budMatch;

  const BudMatchListItem({Key? key, required this.budMatch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: budMatch.avatarUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(budMatch.avatarUrl!),
            )
          : const CircleAvatar(
              child: Icon(Icons.person),
            ),
      title: Text(budMatch.username),
      subtitle: Text('Match Score: ${budMatch.matchScore.toStringAsFixed(2)}'),
      onTap: () {
        if (budMatch.id.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudCommonItemsPage(
                budId: budMatch.id,
                budName: budMatch.username,
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
