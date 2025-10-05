import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/domain/models/channel_dashboard.dart';

class ChannelDashboardPage extends StatefulWidget {
  final String channelId;

  const ChannelDashboardPage({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  ChannelDashboardPageState createState() => ChannelDashboardPageState();
}

class ChannelDashboardPageState extends State<ChannelDashboardPage> {
  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() {
    context
        .read<ChatBloc>()
        .add(ChatChannelDashboardRequested(widget.channelId));
  }

  void _performAdminAction(String action, String userId) {
    context.read<ChatBloc>().add(ChatAdminActionPerformed(
          channelId: widget.channelId,
          action: action,
          userId: userId,
        ));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatAdminActionSuccess) {
          _showSnackBar('Action completed successfully');
          _fetchDashboardData(); // Refresh data after successful action
        } else if (state is ChatError) {
          _showSnackBar('Error: ${state.message}');
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final dashboardData =
            state is ChatChannelDashboardLoaded ? state.dashboard : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Channel Dashboard'),
          ),
          body: dashboardData == null
              ? const Center(child: Text('Failed to load dashboard data'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Channel Statistics',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Total Members: ${dashboardData.userStats['total']}'),
                        const SizedBox(height: 8),
                        Text(
                            'Total Messages: ${dashboardData.messageStats['total']}'),
                        const SizedBox(height: 16),
                        Text(
                          'Active Members:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ..._buildMembersList(dashboardData),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  List<Widget> _buildMembersList(ChannelDashboard dashboardData) {
    return dashboardData.activeUsers.map((user) {
      String role = user.role;

      return Card(
        child: ListTile(
          title: Text(user.username),
          subtitle: Text(role),
          trailing: role != 'admin'
              ? PopupMenuButton<String>(
                  onSelected: (String action) =>
                      _performAdminAction(action, user.id),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    if (role == 'member')
                      const PopupMenuItem<String>(
                        value: 'add_moderator',
                        child: Text('Promote to Moderator'),
                      ),
                    const PopupMenuItem<String>(
                      value: 'remove_user',
                      child: Text('Remove from Channel'),
                    ),
                  ],
                )
              : null,
        ),
      );
    }).toList();
  }
}
