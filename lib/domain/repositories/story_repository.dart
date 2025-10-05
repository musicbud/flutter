import '../../models/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories({int page = 1});
  Future<void> likeStory(String storyId);
  Future<void> unlikeStory(String storyId);
  Future<void> addStoryComment(String storyId, String comment);
  Future<void> shareStory(String storyId);
  Future<void> createStory(String content, List<String> mediaUrls);
  Future<void> deleteStory(String storyId);
  Future<void> reportStory(String storyId, String reason);
}
