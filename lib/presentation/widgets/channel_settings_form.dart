import 'package:flutter/material.dart';
import '../../domain/models/channel_settings.dart';

class ChannelSettingsForm extends StatefulWidget {
  final ChannelSettings initialSettings;
  final Function(ChannelSettings) onSave;

  const ChannelSettingsForm({
    Key? key,
    required this.initialSettings,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ChannelSettingsForm> createState() => _ChannelSettingsFormState();
}

class _ChannelSettingsFormState extends State<ChannelSettingsForm> {
  late bool isPrivate;
  late bool requiresApproval;
  late List<String> contentTypes;
  late Map<String, dynamic> permissions;
  late Map<String, dynamic> notifications;

  @override
  void initState() {
    super.initState();
    isPrivate = widget.initialSettings.isPrivate;
    requiresApproval = widget.initialSettings.allowInvites == false;
    contentTypes = [];
    permissions = {};
    notifications = {};
  }

  void _handleSave() {
    final settings = ChannelSettings(
      channelId: widget.initialSettings.channelId,
      isPrivate: isPrivate,
      allowInvites: !requiresApproval,  // requiresApproval is inverse of allowInvites
      allowChat: true,
      maxParticipants: widget.initialSettings.maxParticipants,
      additionalSettings: {
        'contentTypes': contentTypes,
        ...permissions,
        'notifications': notifications,
      },
    );
    widget.onSave(settings);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Private Channel'),
                    subtitle: const Text(
                      'Only approved members can view and interact with the channel',
                    ),
                    value: isPrivate,
                    onChanged: (value) => setState(() => isPrivate = value),
                  ),
                  SwitchListTile(
                    title: const Text('Requires Approval'),
                    subtitle: const Text(
                      'New members need approval to join the channel',
                    ),
                    value: requiresApproval,
                    onChanged: (value) =>
                        setState(() => requiresApproval = value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Types',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _ContentTypeChip(
                        label: 'Posts',
                        isSelected: contentTypes.contains('posts'),
                        onToggle: (selected) => _toggleContentType('posts'),
                      ),
                      _ContentTypeChip(
                        label: 'Events',
                        isSelected: contentTypes.contains('events'),
                        onToggle: (selected) => _toggleContentType('events'),
                      ),
                      _ContentTypeChip(
                        label: 'Media',
                        isSelected: contentTypes.contains('media'),
                        onToggle: (selected) => _toggleContentType('media'),
                      ),
                      _ContentTypeChip(
                        label: 'Links',
                        isSelected: contentTypes.contains('links'),
                        onToggle: (selected) => _toggleContentType('links'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleContentType(String type) {
    setState(() {
      if (contentTypes.contains(type)) {
        contentTypes.remove(type);
      } else {
        contentTypes.add(type);
      }
    });
  }
}

class _ContentTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onToggle;

  const _ContentTypeChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onToggle,
    );
  }
}
