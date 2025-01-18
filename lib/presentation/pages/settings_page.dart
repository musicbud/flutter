import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        OutlinedListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Account'),
          subtitle: const Text('Manage your account settings'),
          onTap: () {
            // Handle account settings tap
          },
        ),
        OutlinedListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Manage your notification settings'),
          onTap: () {
            // Handle notifications settings tap
          },
        ),
        OutlinedListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Privacy'),
          subtitle: const Text('Manage your privacy settings'),
          onTap: () {
            // Handle privacy settings tap
          },
        ),
        OutlinedListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          subtitle: const Text('Get help and support'),
          onTap: () {
            // Handle help & support tap
          },
        ),
        OutlinedListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          subtitle: const Text('Learn more about the app'),
          onTap: () {
            // Handle about tap
          },
        ),
      ],
    );
  }
}

class OutlinedListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final VoidCallback onTap;

  const OutlinedListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        onTap: onTap,
      ),
    );
  }
}