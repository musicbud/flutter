import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/story/story_bloc.dart';
import '../../../blocs/story/story_event.dart';
import '../../../blocs/story/story_state.dart';
import '../../../domain/models/story.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  String? _selectedStoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(_onScroll);

    // Load initial data
    _loadStories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _loadStories() {
    context.read<StoryBloc>().add(const StoriesRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<StoryBloc>().add(StoriesLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Stories',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateStoryDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        tabs: const [
          Tab(text: 'All Stories'),
          Tab(text: 'My Stories'),
          Tab(text: 'Trending'),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllStoriesTab(),
        _buildMyStoriesTab(),
        _buildTrendingStoriesTab(),
      ],
    );
  }

  Widget _buildAllStoriesTab() {
    return BlocConsumer<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state is StoryFailure) {
          _showErrorSnackBar(state.error);
        } else if (state is StoryCreated) {
          _showSuccessSnackBar('Story created successfully');
        } else if (state is StoryLiked) {
          _showSuccessSnackBar('Story liked');
        } else if (state is StoryCommentAdded) {
          _showSuccessSnackBar('Comment added');
        }
      },
      builder: (context, state) {
        if (state is StoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StoriesLoaded) {
          return _buildStoriesList(state.stories);
        }

        if (state is StoryFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No stories found'));
      },
    );
  }

  Widget _buildMyStoriesTab() {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        if (state is StoriesLoaded) {
          final myStories = state.stories.where((story) => story.isMyStory).toList();
          return _buildStoriesList(myStories, showActions: true);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No stories yet',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Create your first story to get started',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendingStoriesTab() {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        if (state is StoriesLoaded) {
          final trendingStories = state.stories
              .where((story) => story.likesCount > 10 || story.commentsCount > 5)
              .toList()
            ..sort((a, b) => (b.likesCount + b.commentsCount)
                .compareTo(a.likesCount + a.commentsCount));
          return _buildStoriesList(trendingStories);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No trending stories',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Stories with high engagement will appear here',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoriesList(List<Story> stories, {bool showActions = false}) {
    if (stories.isEmpty) {
      return const Center(
        child: Text(
          'No stories found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(story, showActions: showActions);
      },
    );
  }

  Widget _buildStoryCard(Story story, {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppConstants.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Story Header
          _buildStoryHeader(story),

          // Story Content
          _buildStoryContent(story),

          // Story Actions
          _buildStoryActions(story),

          // Story Comments
          if (story.comments.isNotEmpty) _buildStoryComments(story),

          // Add Comment Section
          _buildAddCommentSection(story),
        ],
      ),
    );
  }

  Widget _buildStoryHeader(Story story) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
            backgroundImage: story.authorAvatarUrl != null
                ? NetworkImage(story.authorAvatarUrl!)
                : null,
            child: story.authorAvatarUrl == null
                ? Text(
                    story.authorName.isNotEmpty ? story.authorName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.authorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(story.createdAt),
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (story.isMyStory)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              onSelected: (value) => _handleStoryAction(value, story.id),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStoryContent(Story story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (story.title.isNotEmpty) ...[
            Text(
              story.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (story.content.isNotEmpty)
            Text(
              story.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          if (story.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                story.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white70,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ],
          if (story.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: story.tags.map((tag) => Chip(
                label: Text(
                  tag,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.white),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoryActions(Story story) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildActionButton(
            Icons.favorite,
            story.isLiked ? Icons.favorite : Icons.favorite_border,
            '${story.likesCount}',
            story.isLiked ? Colors.red : Colors.white70,
            () => _toggleLike(story.id),
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            Icons.comment,
            Icons.comment,
            '${story.commentsCount}',
            Colors.white70,
            () => _showComments(story.id),
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            Icons.share,
            Icons.share,
            'Share',
            Colors.white70,
            () => _shareStory(story.id),
          ),
          const Spacer(),
          if (story.musicInfo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.primaryColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    story.musicInfo!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    IconData activeIcon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon == activeIcon ? activeIcon : icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryComments(Story story) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments (${story.comments.length})',
            style: TextStyle(
              color: AppConstants.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...story.comments.take(3).map((comment) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
                  child: Text(
                    comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          if (story.comments.length > 3)
            TextButton(
              onPressed: () => _showAllComments(story.id),
              child: Text(
                'View all ${story.comments.length} comments',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection(Story story) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _commentController,
              hintText: 'Add a comment...',
              onSubmitted: (value) => _addComment(story.id, value),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _addComment(story.id, _commentController.text),
            icon: const Icon(
              Icons.send,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading stories',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: _loadStories,
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    }
    if (difference.inDays == 1) return 'yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  // Action methods
  void _showCreateStoryDialog() {
    // Implement create story dialog
  }

  void _showFilterDialog() {
    // Implement filter dialog
  }

  void _toggleLike(String storyId) {
    context.read<StoryBloc>().add(StoryLikeToggled(storyId));
  }

  void _showComments(String storyId) {
    // Implement show comments logic
  }

  void _shareStory(String storyId) {
    context.read<StoryBloc>().add(StoryShared(storyId));
  }

  void _addComment(String storyId, String comment) {
    if (comment.trim().isNotEmpty) {
      context.read<StoryBloc>().add(StoryCommentAdded(
        storyId: storyId,
        comment: comment.trim(),
      ));
      _commentController.clear();
    }
  }

  void _showAllComments(String storyId) {
    // Implement show all comments logic
  }

  void _handleStoryAction(String action, String storyId) {
    switch (action) {
      case 'edit':
        // Implement edit story logic
        break;
      case 'delete':
        _showDeleteConfirmation(storyId);
        break;
    }
  }

  void _showDeleteConfirmation(String storyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Story'),
        content: const Text('Are you sure you want to delete this story?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<StoryBloc>().add(StoryDeleted(storyId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}