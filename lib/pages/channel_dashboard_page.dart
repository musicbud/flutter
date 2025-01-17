import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelDashboardPage extends StatefulWidget {
  final int channelId;
  final ChatService chatService;

  const ChannelDashboardPage({
    Key? key,
    required this.channelId,
    required this.chatService,
  }) : super(key: key);

  @override
  _ChannelDashboardPageState createState() => _ChannelDashboardPageState();
}

class _ChannelDashboardPageState extends State<ChannelDashboardPage> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.getChannelDashboardData(widget.channelId);
      if (!mounted) return;

      setState(() {
        _dashboardData = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching dashboard data: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('Failed to load dashboard data. Please try again.')),
      );
    }
  }

  Future<void> _performAdminAction(String action, int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await widget.chatService
          .performAdminAction(widget.channelId, action, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        _fetchDashboardData(); // Refresh the data after performing an action
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Error performing admin action: $e');
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dashboardData == null
              ? const Center(child: Text('Failed to load dashboard data'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Channel Name: ${_dashboardData!['channel_name']}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Total Members: ${_dashboardData!['members'].length}'),
                        const SizedBox(height: 8),
                        Text(
                            'Total Messages: ${_dashboardData!['messages'].length}'),
                        const SizedBox(height: 16),
                        Text(
                          'Members:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ..._buildMembersList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  List<Widget> _buildMembersList() {
    final List<dynamic> members = _dashboardData!['members'] ?? [];
    final List<dynamic> admins = _dashboardData!['admins'] ?? [];
    final List<dynamic> moderators = _dashboardData!['moderators'] ?? [];

    return members.map((member) {
      String role = 'Member';
      if (admins.any((admin) => admin['id'] == member['id'])) {
        role = 'Admin';
      } else if (moderators.any((mod) => mod['id'] == member['id'])) {
        role = 'Moderator';
      }

      return ListTile(
        title: Text(member['username']),
        subtitle: Text(role),
        trailing: role != 'Admin'
            ? PopupMenuButton<String>(
                onSelected: (String action) =>
                    _performAdminAction(action, member['id']),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  if (role == 'Member')
                    const PopupMenuItem<String>(
                      value: 'promote',
                      child: Text('Promote to Moderator'),
                    ),
                  const PopupMenuItem<String>(
                    value: 'remove',
                    child: Text('Remove from Channel'),
                  ),
                ],
              )
            : null,
      );
    }).toList();
  }
}
