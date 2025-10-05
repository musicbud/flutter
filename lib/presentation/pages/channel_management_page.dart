import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/channel.dart';
import '../blocs/channel/channel_bloc.dart';
import '../blocs/channel/channel_event.dart';
import '../blocs/channel/channel_state.dart';
import '../widgets/channel_list_item.dart';
import '../widgets/channel_stats_card.dart';
import '../widgets/channel_settings_form.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';

class ChannelManagementPage extends StatefulWidget {
  const ChannelManagementPage({Key? key}) : super(key: key);

  @override
  State<ChannelManagementPage> createState() => _ChannelManagementPageState();
}

class _ChannelManagementPageState extends State<ChannelManagementPage> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;
  int _currentPage = 0;
  bool _hasMoreChannels = true;

  @override
  void initState() {
    super.initState();
    _loadInitialChannels();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialChannels() {
    context.read<ChannelBloc>().add(
          const GetChannelsEvent(
            limit: _pageSize,
            offset: 0,
          ),
        );
  }

  void _loadMoreChannels() {
    if (_hasMoreChannels) {
      _currentPage++;
      context.read<ChannelBloc>().add(
            GetChannelsEvent(
              limit: _pageSize,
              offset: _currentPage * _pageSize,
            ),
          );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreChannels();
    }
  }

  void _showCreateChannelDialog() {
    // TODO: Implement channel creation dialog
  }

  void _showChannelSettings(Channel channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Scaffold(
          appBar: AppBar(
            title: Text('${channel.name} Settings'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                ChannelStatsCard(stats: channel.stats),
                const SizedBox(height: 16),
                ChannelSettingsForm(
                  initialSettings: channel.settings,
                  onSave: (settings) {
                    context.read<ChannelBloc>().add(
                          UpdateChannelSettingsEvent(channel.id, settings),
                        );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Channel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Channel'),
        content: Text(
          'Are you sure you want to delete "${channel.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ChannelBloc>().add(DeleteChannelEvent(channel.id));
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialChannels,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateChannelDialog,
          ),
        ],
      ),
      body: BlocConsumer<ChannelBloc, ChannelState>(
        listenWhen: (previous, current) =>
            current is ChannelOperationSuccess || current is ChannelError,
        listener: (context, state) {
          if (state is ChannelOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            if (state.message.contains('deleted')) {
              _loadInitialChannels();
            }
          } else if (state is ChannelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChannelLoading && _currentPage == 0) {
            return const LoadingIndicator();
          } else if (state is ChannelsLoaded) {
            _hasMoreChannels = state.channels.length >= _pageSize;
            return RefreshIndicator(
              onRefresh: () async => _loadInitialChannels(),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.channels.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.channels.length) {
                    return _hasMoreChannels
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final channel = state.channels[index];
                  return ChannelListItem(
                    channel: channel,
                    onTap: () => _showChannelSettings(channel),
                    onEdit: () => _showChannelSettings(channel),
                    onDelete: () => _showDeleteConfirmation(channel),
                  );
                },
              ),
            );
          } else if (state is ChannelError && _currentPage == 0) {
            return ErrorView(
              message: state.message,
              onRetry: _loadInitialChannels,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
