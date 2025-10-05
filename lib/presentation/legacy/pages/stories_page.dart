import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/story/story_bloc.dart';
import '../../blocs/story/story_event.dart';
import '../../blocs/story/story_state.dart';
import '../../models/story.dart';
import '../widgets/loading_indicator.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadStories();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  void _toggleLike(String storyId) {
    context.read<StoryBloc>().add(StoryLikeToggled(storyId));
  }

  void _addComment(String storyId, String comment) {
    context.read<StoryBloc>().add(
          StoryCommentAdded(
            storyId: storyId,
            comment: comment,
          ),
        );
  }

  void _shareStory(String storyId) {
    context.read<StoryBloc>().add(StoryShared(storyId));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showCommentDialog(String storyId) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Enter your comment',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                _addComment(storyId, commentController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(Story story) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: story.userAvatarUrl != null
                  ? NetworkImage(story.userAvatarUrl!)
                  : null,
              child: story.userAvatarUrl == null
                  ? Text(story.username[0].toUpperCase())
                  : null,
            ),
            title: Text(story.username),
            subtitle: Text(
              story.createdAt.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(story.content),
          ),
          if (story.mediaUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: story.mediaUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.network(
                      story.mediaUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          OverflowBar(
            spacing: 8,
            children: [
              IconButton(
                icon: Icon(
                  story.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: story.isLiked ? Colors.red : null,
                ),
                onPressed: () => _toggleLike(story.id),
              ),
              Text('${story.likesCount}'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _showCommentDialog(story.id),
              ),
              Text('${story.commentsCount}'),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareStory(story.id),
              ),
              Text('${story.sharesCount}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StoryBloc>().add(StoriesRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryFailure) {
            _showErrorSnackBar(state.error);
          } else if (state is StoryLikeStatusChanged) {
            _showErrorSnackBar(
              state.isLiked ? 'Added to favorites' : 'Removed from favorites',
            );
          } else if (state is StoryCommentAddedState) {
            _showErrorSnackBar('Comment added successfully');
          } else if (state is StorySharedState) {
            _showErrorSnackBar('Story shared successfully');
          }
        },
        builder: (context, state) {
          if (state is StoryInitial) {
            _loadStories();
            return const LoadingIndicator();
          }

          if (state is StoryLoading) {
            return const LoadingIndicator();
          }

          if (state is StoryLoaded || state is StoryLoadingMore) {
            final stories = state is StoryLoaded
                ? state.stories
                : (state as StoryLoadingMore).currentStories;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StoryBloc>().add(StoriesRefreshRequested());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: stories.length + (state is StoryLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == stories.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LoadingIndicator(),
                      ),
                    );
                  }

                  return _buildStoryCard(stories[index]);
                },
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
