import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelAdminPage extends StatefulWidget {
  final ChatService chatService;
  final int channelId;

  const ChannelAdminPage(
      {Key? key, required this.chatService, required this.channelId})
      : super(key: key);

  @override
  _ChannelAdminPageState createState() => _ChannelAdminPageState();
}

class _ChannelAdminPageState extends State<ChannelAdminPage> {
  Map<String, dynamic> channelData = {};
  Map<String, dynamic> dashboardData = {};
  List<dynamic> channelUsers = [];
  bool isLoading = true;
  bool isAdmin = false;
  bool isModerator = false;
  bool isMember = false;
  final TextEditingController _addMemberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchChannelData();
  }

  Future<void> _fetchChannelData() async {
    try {
      final roles =
          await widget.chatService.checkChannelRoles(widget.channelId);
      final dashboard =
          await widget.chatService.getChannelDashboardData(widget.channelId);

      setState(() {
        isAdmin = roles['is_admin'] ?? false;
        isModerator = roles['is_moderator'] ?? false;
        isMember = roles['is_member'] ?? false;
        dashboardData = dashboard;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channel data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeAdmin(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.removeAdmin(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Admin removed successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error removing admin: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to remove admin')));
    }
  }

  Future<void> _removeUser(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await widget.chatService
          .removeChannelMember(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User removed successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error removing user: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to remove user')));
    }
  }

  Future<void> _addChannelMember() async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_addMemberController.text.isNotEmpty) {
      try {
        final response = await widget.chatService
            .addChannelMember(widget.channelId, _addMemberController.text);
        if (!mounted) return;

        if (response['status'] == 'success') {
          _addMemberController.clear();
          _fetchChannelData();
          scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Member added successfully')));
        } else {
          scaffoldMessenger.showSnackBar(SnackBar(
              content:
                  Text('Error: ${response['message'] ?? 'Unknown error'}')));
        }
      } catch (e) {
        print('Error adding channel member: $e');
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Error: Unable to add member')));
      }
    }
  }

  Future<void> _makeAdmin(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.makeAdmin(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User made admin successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error making user admin: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to make user admin')));
    }
  }

  Future<void> _addModerator(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.addModerator(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Moderator added successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error adding moderator: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to add moderator')));
    }
  }

  Future<void> _removeModerator(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.removeModerator(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Moderator removed successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error removing moderator: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to remove moderator')));
    }
  }

  Future<void> _acceptUser(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.acceptUser(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User accepted successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error accepting user: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to accept user')));
    }
  }

  Future<void> _kickUser(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.kickUser(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User kicked successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error kicking user: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to kick user')));
    }
  }

  Future<void> _blockUser(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.blockUser(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User blocked successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error blocking user: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to block user')));
    }
  }

  Future<void> _unblockUser(int userId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.unblockUser(widget.channelId, userId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('User unblocked successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error unblocking user: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to unblock user')));
    }
  }

  Future<void> _deleteMessage(int messageId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response =
          await widget.chatService.deleteMessage(widget.channelId, messageId);
      if (!mounted) return;

      if (response['status'] == 'success') {
        _fetchChannelData();
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Message deleted successfully')));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error: ${response['message'] ?? 'Unknown error'}')));
      }
    } catch (e) {
      print('Error deleting message: $e');
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: Unable to delete message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Admin'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isAdmin || isModerator
              ? _buildAdminContent()
              : const Center(
                  child:
                      Text('You do not have permission to access this page.')),
    );
  }

  Widget _buildAdminContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Channel Dashboard',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildDashboardInfo(),
            const SizedBox(height: 24),
            Text('Channel Members',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildMembersList(),
            const SizedBox(height: 24),
            Text('Add New Member',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildAddMemberForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Channel Name: ${dashboardData['channel_name'] ?? 'N/A'}'),
            Text(
                'Total Members: ${(dashboardData['members'] as List?)?.length ?? 'N/A'}'),
            Text(
                'Total Messages: ${(dashboardData['messages'] as List?)?.length ?? 'N/A'}'),
            Text(
                'Admins: ${(dashboardData['admins'] as List?)?.length ?? 'N/A'}'),
            Text(
                'Moderators: ${(dashboardData['moderators'] as List?)?.length ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    List<Map<String, dynamic>> allMembers = [];

    // Add admins
    allMembers.addAll((dashboardData['admins'] as List? ?? [])
        .map((admin) => {...admin, 'role': 'Admin'}));

    // Add moderators
    allMembers.addAll((dashboardData['moderators'] as List? ?? [])
        .map((mod) => {...mod, 'role': 'Moderator'}));

    // Add regular members (excluding those already added as admins or moderators)
    Set adminModIds = Set.from(allMembers.map((m) => m['id']));
    allMembers.addAll((dashboardData['members'] as List? ?? [])
        .where((member) => !adminModIds.contains(member['id']))
        .map((member) => {...member, 'role': 'Member'}));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allMembers.length,
        itemBuilder: (context, index) {
          final user = allMembers[index];
          return ListTile(
            title: Text(user['username'] ?? 'Unknown User'),
            subtitle: Text(user['role'] ?? 'Member'),
            trailing: isAdmin ? _buildAdminActions(user) : null,
          );
        },
      ),
    );
  }

  Widget _buildAdminActions(Map<String, dynamic> user) {
    if (user['role'] == 'Admin') {
      // Don't show remove option for the current user
      if (user['username'] == widget.chatService.currentUsername) {
        return const SizedBox
            .shrink(); // Return an empty SizedBox instead of null
      }
      return IconButton(
        icon: const Icon(Icons.admin_panel_settings_outlined),
        onPressed: () => _removeAdmin(user['id']),
        tooltip: 'Remove Admin',
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.person_remove_outlined),
        onPressed: () => _removeUser(user['id']),
        tooltip: 'Remove User',
      );
    }
  }

  Widget _buildAddMemberForm() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _addMemberController,
            decoration: const InputDecoration(
              hintText: 'Enter username',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _addChannelMember,
          child: const Text('Add Member'),
        ),
      ],
    );
  }
}
