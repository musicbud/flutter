import 'package:flutter/material.dart';
import '../../domain/models/bud_match.dart';
import '../pages/bud_common_items_page.dart';

class BudMatchListItem extends StatelessWidget {
  final BudMatch budMatch;

  const BudMatchListItem({
    Key? key,
    required this.budMatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: budMatch.avatarUrl != null
            ? NetworkImage(budMatch.avatarUrl!)
            : null,
        child: budMatch.avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(budMatch.username),
      subtitle: Text('${budMatch.matchScore}% match'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudCommonItemsPage(
                userId: budMatch.userId,
                username: budMatch.username,
              ),
            ),
          );
        },
      ),
    );
  }
}
