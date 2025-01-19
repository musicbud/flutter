import 'package:equatable/equatable.dart';
import '../../models/story.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoadingMore extends StoryState {
  final List<Story> currentStories;

  const StoryLoadingMore(this.currentStories);

  @override
  List<Object> get props => [currentStories];
}

class StoryLoaded extends StoryState {
  final List<Story> stories;
  final bool hasReachedEnd;
  final int currentPage;

  const StoryLoaded({
    required this.stories,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [stories, hasReachedEnd, currentPage];

  StoryLoaded copyWith({
    List<Story>? stories,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return StoryLoaded(
      stories: stories ?? this.stories,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class StoryLikeStatusChanged extends StoryState {
  final String storyId;
  final bool isLiked;

  const StoryLikeStatusChanged({
    required this.storyId,
    required this.isLiked,
  });

  @override
  List<Object> get props => [storyId, isLiked];
}

class StoryCommentAddedState extends StoryState {
  final String storyId;
  final String comment;

  const StoryCommentAddedState({
    required this.storyId,
    required this.comment,
  });

  @override
  List<Object> get props => [storyId, comment];
}

class StorySharedState extends StoryState {
  final String storyId;

  const StorySharedState(this.storyId);

  @override
  List<Object> get props => [storyId];
}

class StoryFailure extends StoryState {
  final String error;

  const StoryFailure(this.error);

  @override
  List<Object> get props => [error];
}
