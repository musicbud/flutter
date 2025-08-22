import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../domain/models/channel.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class ChannelManagementPage extends StatefulWidget {
  const ChannelManagementPage({super.key});

  @override
  State<ChannelManagementPage> createState() => _ChannelManagementPageState();
}

class _ChannelManagementPageState extends State<ChannelManagementPage> {
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _channelDescriptionController = TextEditingController();
  bool _isPrivateChannel = false;

  @override
  void initState() {
    super.initState();
    // Load channels when page initializes
    context.read<ChatBloc>().add(ChatChannelListRequested());
  }

  @override
  void dispose() {
    _channelNameController.dispose();
    _channelDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Channel Management',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateChannelDialog(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLimitationsNotice(),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChannelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationsNotice() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Channel management is limited. You can only create channels and view basic information. Advanced features like editing, deleting, and member management are not supported by the API.',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterTab('All', true),
          const SizedBox(width: 12),
          _buildFilterTab('My Channels', false),
          const SizedBox(width: 12),
          _buildFilterTab('Public', false),
          const SizedBox(width: 12),
          _buildFilterTab('Private', false),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        // Filter functionality is not implemented due to API limitations
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtering is not supported by the API'),
            backgroundColor: Colors.orange,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppConstants.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppConstants.primaryColor : AppConstants.borderColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : AppConstants.textSecondaryColor,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildChannelList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _getUserFriendlyErrorMessage(state.error),
                  style: TextStyle(color: AppConstants.textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (_isServerError(state.error))
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      'The server is experiencing issues. This is not a problem with your app.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Retry',
                  onPressed: () {
                    context.read<ChatBloc>().add(ChatChannelListRequested());
                  },
                ),
              ],
            ),
          );
        }

        if (state is ChatChannelListLoaded) {
          if (state.channels.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.channels.length,
            itemBuilder: (context, index) {
              return _buildChannelItem(state.channels[index]);
            },
          );
        }

        // Default state - show empty state
        return _buildEmptyState();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No channels found',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first channel to get started',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Create Channel',
            onPressed: () => _showCreateChannelDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelItem(Channel channel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Channel Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: AppConstants.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Channel Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      channel.name,
                      style: TextStyle(
                        color: AppConstants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: channel.type == 'private'
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: channel.type == 'private' ? Colors.orange : Colors.green,
                        ),
                      ),
                      child: Text(
                        channel.type == 'private' ? 'Private' : 'Public',
                        style: TextStyle(
                          color: channel.type == 'private' ? Colors.orange : Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  channel.description ?? 'No description',
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppConstants.primaryColor),
                ),
                child: Text(
                  'View',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppConstants.textSecondaryColor, size: 20),
                    onPressed: () => _showEditNotSupported(),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: AppConstants.textSecondaryColor, size: 20),
                    onPressed: () => _showSettingsNotSupported(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceColor,
        title: Text(
          'Create New Channel',
          style: TextStyle(color: AppConstants.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _channelNameController,
              labelText: 'Channel Name',
              hintText: 'Enter channel name',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _channelDescriptionController,
              labelText: 'Description',
              hintText: 'Enter channel description',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isPrivateChannel,
                  onChanged: (value) {
                    setState(() {
                      _isPrivateChannel = value ?? false;
                    });
                  },
                  activeColor: AppConstants.primaryColor,
                ),
                Text(
                  'Private Channel',
                  style: TextStyle(color: AppConstants.textColor),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          ),
          AppButton(
            text: 'Create',
            onPressed: () => _createChannel(context),
          ),
        ],
      ),
    );
  }

  void _createChannel(BuildContext context) {
    final name = _channelNameController.text.trim();
    final description = _channelDescriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a channel name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create channel using the chat bloc
    context.read<ChatBloc>().add(ChatChannelCreated(
      name: name,
      description: description,
      isPrivate: _isPrivateChannel,
    ));

    // Clear controllers
    _channelNameController.clear();
    _channelDescriptionController.clear();
    _isPrivateChannel = false;

    // Close dialog
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Channel created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditNotSupported() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Channel editing is not supported by the API'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showSettingsNotSupported() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Channel settings are not supported by the API'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _getUserFriendlyErrorMessage(String error) {
    if (_isServerError(error)) {
      return 'Server Error: The chat service is temporarily unavailable';
    }
    if (error.contains('Failed to get channels')) {
      return 'Unable to load channels at this time';
    }
    return 'Error: $error';
  }

  bool _isServerError(String error) {
    return error.contains('Server error') ||
           error.contains('500') ||
           error.contains('temporarily unavailable');
  }
}