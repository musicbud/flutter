import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

class StoriesRequested extends StoryEvent {
  final int page;

  const StoriesRequested({this.page = 1});

  @override
  List<Object> get props => [page];
}

class StoriesLoadMoreRequested extends StoryEvent {}

class StoriesRefreshRequested extends StoryEvent {}

class StoryLikeToggled extends StoryEvent {
  final String storyId;

  const StoryLikeToggled(this.storyId);

  @override
  List<Object> get props => [storyId];
}

class StoryCommentAdded extends StoryEvent {
  final String storyId;
  final String comment;

  const StoryCommentAdded({
    required this.storyId,
    required this.comment,
  });

  @override
  List<Object> get props => [storyId, comment];
}

class StoryShared extends StoryEvent {
  final String storyId;

  const StoryShared(this.storyId);

  @override
  List<Object> get props => [storyId];
}
