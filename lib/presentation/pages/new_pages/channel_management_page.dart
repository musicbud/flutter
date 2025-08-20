import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_state.dart';

class ChannelManagementPage extends StatelessWidget {
  const ChannelManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Channel Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateChannelDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pixiled_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Filter Tabs
              _buildFilterTabs(),
              const SizedBox(height: 24),

              // Channel List
              Expanded(
                child: _buildChannelList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search channels...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildFilterTab('All', true),
        const SizedBox(width: 12),
        _buildFilterTab('My Channels', false),
        const SizedBox(width: 12),
        _buildFilterTab('Public', false),
        const SizedBox(width: 12),
        _buildFilterTab('Private', false),
      ],
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.pinkAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.pinkAccent : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
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
            child: CircularProgressIndicator(color: Colors.pinkAccent),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Mock data for now - replace with actual data from bloc
        final channels = [
          ChannelData('Music Lovers', 'Public', 156, true, Colors.blue),
          ChannelData('Rock Fans', 'Private', 89, false, Colors.red),
          ChannelData('Jazz Club', 'Public', 234, true, Colors.green),
          ChannelData('Classical Music', 'Private', 67, false, Colors.purple),
          ChannelData('Hip Hop', 'Public', 189, true, Colors.orange),
        ];

        return ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, index) {
            return _buildChannelItem(channels[index]);
          },
        );
      },
    );
  }

  Widget _buildChannelItem(ChannelData channel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: channel.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Channel Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: channel.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: channel.color,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: channel.type == 'Public' ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: channel.type == 'Public' ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Text(
                        channel.type,
                        style: TextStyle(
                          color: channel.type == 'Public' ? Colors.green : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${channel.memberCount} members',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              if (channel.isOwner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: const Text(
                    'Owner',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                    onPressed: () => _showEditChannelDialog(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
                    onPressed: () => _showChannelSettingsDialog(),
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
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Create New Channel',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Channel Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                    ),
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditChannelDialog() {
    // Implement edit channel dialog
  }

  void _showChannelSettingsDialog() {
    // Implement channel settings dialog
  }
}

class ChannelData {
  final String name;
  final String type;
  final int memberCount;
  final bool isOwner;
  final Color color;

  ChannelData(this.name, this.type, this.memberCount, this.isOwner, this.color);
}