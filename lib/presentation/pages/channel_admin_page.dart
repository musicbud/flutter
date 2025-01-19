import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';

class ChannelAdminPage extends StatefulWidget {
  final int channelId;

  const ChannelAdminPage({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  _ChannelAdminPageState createState() => _ChannelAdminPageState();
}

class _ChannelAdminPageState extends State<ChannelAdminPage> {
  bool isAdmin = false;
  bool isModerator = false;
  bool isMember = false;
  final TextEditingController _addMemberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ChatBloc>().add(ChatChannelRolesChecked(widget.channelId));
    context
        .read<ChatBloc>()
        .add(ChatChannelDashboardRequested(widget.channelId));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _performAdminAction(String action, int userId) {
    context.read<ChatBloc>().add(ChatAdminActionPerformed(
          channelId: widget.channelId,
          action: action,
          userId: userId,
        ));
  }

  void _addChannelMember() {
    if (_addMemberController.text.isNotEmpty) {
      context.read<ChatBloc>().add(ChatChannelMemberAdded(
            channelId: widget.channelId,
            username: _addMemberController.text,
          ));
      _addMemberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatChannelRolesLoaded) {
          setState(() {
            isAdmin = state.roles['is_admin'] ?? false;
            isModerator = state.roles['is_moderator'] ?? false;
            isMember = state.roles['is_member'] ?? false;
          });
        } else if (state is ChatAdminActionSuccess) {
          _fetchData(); // Refresh data after successful action
          _showSnackBar('Action completed successfully');
        } else if (state is ChatFailure) {
          _showSnackBar('Error: ${state.error}');
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final dashboardData =
            state is ChatChannelDashboardLoaded ? state.dashboard : {};

        return Scaffold(
          appBar: AppBar(
            title: const Text('Channel Administration'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAdmin || isModerator) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Member',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addChannelMember,
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (dashboardData['members'] != null) ...[
                    const Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (dashboardData['members'] as List).length,
                      itemBuilder: (context, index) {
                        final member = dashboardData['members'][index];
                        return Card(
                          child: ListTile(
                            title: Text(member['username'] ?? ''),
                            subtitle: Text(member['role'] ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isAdmin && member['role'] != 'admin') ...[
                                  IconButton(
                                    icon:
                                        const Icon(Icons.admin_panel_settings),
                                    onPressed: () => _performAdminAction(
                                        'make_admin', member['id']),
                                    tooltip: 'Make Admin',
                                  ),
                                ],
                                if ((isAdmin || isModerator) &&
                                    member['role'] != 'moderator') ...[
                                  IconButton(
                                    icon: const Icon(Icons.security),
                                    onPressed: () => _performAdminAction(
                                        'add_moderator', member['id']),
                                    tooltip: 'Make Moderator',
                                  ),
                                ],
                                if (isAdmin || isModerator) ...[
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () => _performAdminAction(
                                        'remove_user', member['id']),
                                    tooltip: 'Remove User',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _addMemberController.dispose();
    super.dispose();
  }
}
