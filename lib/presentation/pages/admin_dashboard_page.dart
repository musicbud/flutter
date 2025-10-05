import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/admin/admin_bloc.dart';
import '../blocs/admin/admin_event.dart';
import '../blocs/admin/admin_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminBloc>()
                ..add(GetAdminStatsEvent())
                ..add(const GetRecentActionsEvent())
                ..add(GetSystemSettingsEvent());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AdminBloc, AdminState>(
            listenWhen: (previous, current) => current is AdminActionSuccess,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Action completed successfully')),
              );
            },
          ),
          BlocListener<AdminBloc, AdminState>(
            listenWhen: (previous, current) => current is AdminError,
            listener: (context, state) {
              if (state is AdminError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AdminBloc>()
              ..add(GetAdminStatsEvent())
              ..add(const GetRecentActionsEvent())
              ..add(GetSystemSettingsEvent());
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsSection(),
                  SizedBox(height: 24),
                  _RecentActionsSection(),
                  SizedBox(height: 24),
                  _SystemSettingsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (previous, current) =>
          current is AdminLoading ||
          current is AdminStatsLoaded ||
          current is AdminError,
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingIndicator();
        } else if (state is AdminStatsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  StatsCard(
                    title: 'User Stats',
                    stats: state.stats.userStats,
                    icon: Icons.people,
                  ),
                  StatsCard(
                    title: 'Content Stats',
                    stats: state.stats.contentStats,
                    icon: Icons.article,
                  ),
                  StatsCard(
                    title: 'Engagement',
                    stats: state.stats.engagementStats,
                    icon: Icons.trending_up,
                  ),
                  StatsCard(
                    title: 'System',
                    stats: state.stats.systemStats,
                    icon: Icons.computer,
                  ),
                ],
              ),
            ],
          );
        } else if (state is AdminError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<AdminBloc>().add(GetAdminStatsEvent()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showEditSettingsDialog(BuildContext context, String key, dynamic value) {
    final TextEditingController controller = TextEditingController(text: value.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Setting: $key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = controller.text;
              // Update the setting through the BLoC
              final updatedSettings = Map<String, dynamic>.from(
                (context.read<AdminBloc>().state as SystemSettingsLoaded).settings,
              );
              updatedSettings[key] = newValue;

              context.read<AdminBloc>().add(
                UpdateSystemSettingsEvent(updatedSettings),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _RecentActionsSection extends StatelessWidget {
  const _RecentActionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (previous, current) =>
          current is AdminLoading ||
          current is AdminActionsLoaded ||
          current is AdminError,
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingIndicator();
        } else if (state is AdminActionsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Actions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.actions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final action = state.actions[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(action.actionType),
                      subtitle: Text(
                        'Target ID: ${action.targetId}\nPerformed by: ${action.performedBy}',
                      ),
                      trailing: Text(
                        action.timestamp.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is AdminError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<AdminBloc>().add(const GetRecentActionsEvent()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SystemSettingsSection extends StatelessWidget {
  const _SystemSettingsSection({Key? key}) : super(key: key);

  void _showEditSettingsDialog(BuildContext context, String key, dynamic value) {
    final TextEditingController controller = TextEditingController(text: value.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Setting: $key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = controller.text;
              // Update the setting through the BLoC
              final updatedSettings = Map<String, dynamic>.from(
                (context.read<AdminBloc>().state as SystemSettingsLoaded).settings,
              );
              updatedSettings[key] = newValue;

              context.read<AdminBloc>().add(
                UpdateSystemSettingsEvent(updatedSettings),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (previous, current) =>
          current is AdminLoading ||
          current is SystemSettingsLoaded ||
          current is AdminError,
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingIndicator();
        } else if (state is SystemSettingsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.settings.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditSettingsDialog(context, entry.key, entry.value);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else if (state is AdminError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<AdminBloc>().add(GetSystemSettingsEvent()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
