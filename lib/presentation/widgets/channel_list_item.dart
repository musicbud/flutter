import 'package:flutter/material.dart';
import '../../../models/channel.dart';

class ChannelListItem extends StatelessWidget {
  final Channel channel;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChannelListItem({
    Key? key,
    required this.channel,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(channel.name[0].toUpperCase()),
        ),
        title: Text(channel.name),
        subtitle: Text(
          channel.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${channel.stats.totalParticipants} members',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (onEdit != null) ...[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
            if (onDelete != null) ...[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
