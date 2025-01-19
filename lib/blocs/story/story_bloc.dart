import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/story_repository.dart';
import '../../models/story.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository _storyRepository;
  static const int _pageSize = 20;

  StoryBloc({
    required StoryRepository storyRepository,
  })  : _storyRepository = storyRepository,
        super(StoryInitial()) {
    on<StoriesRequested>(_onStoriesRequested);
    on<StoriesLoadMoreRequested>(_onStoriesLoadMoreRequested);
    on<StoriesRefreshRequested>(_onStoriesRefreshRequested);
    on<StoryLikeToggled>(_onStoryLikeToggled);
    on<StoryCommentAdded>(_onStoryCommentAdded);
    on<StoryShared>(_onStoryShared);
  }

  Future<void> _onStoriesRequested(
    StoriesRequested event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    try {
      final stories = await _storyRepository.getStories(page: event.page);
      final hasReachedEnd = stories.length < _pageSize;
      emit(StoryLoaded(
        stories: stories,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(StoryFailure(e.toString()));
    }
  }

  Future<void> _onStoriesLoadMoreRequested(
    StoriesLoadMoreRequested event,
    Emitter<StoryState> emit,
  ) async {
    if (state is StoryLoaded) {
      final currentState = state as StoryLoaded;
      if (currentState.hasReachedEnd) return;

      emit(StoryLoadingMore(currentState.stories));
      try {
        final nextPage = currentState.currentPage + 1;
        final moreStories = await _storyRepository.getStories(page: nextPage);
        final hasReachedEnd = moreStories.length < _pageSize;

        emit(currentState.copyWith(
          stories: [...currentState.stories, ...moreStories],
          hasReachedEnd: hasReachedEnd,
          currentPage: nextPage,
        ));
      } catch (e) {
        emit(StoryFailure(e.toString()));
      }
    }
  }

  Future<void> _onStoriesRefreshRequested(
    StoriesRefreshRequested event,
    Emitter<StoryState> emit,
  ) async {
    try {
      final stories = await _storyRepository.getStories(page: 1);
      final hasReachedEnd = stories.length < _pageSize;
      emit(StoryLoaded(
        stories: stories,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
      ));
    } catch (e) {
      emit(StoryFailure(e.toString()));
    }
  }

  Future<void> _onStoryLikeToggled(
    StoryLikeToggled event,
    Emitter<StoryState> emit,
  ) async {
    if (state is StoryLoaded) {
      final currentState = state as StoryLoaded;
      final storyIndex =
          currentState.stories.indexWhere((s) => s.id == event.storyId);
      if (storyIndex == -1) return;

      final story = currentState.stories[storyIndex];
      try {
        if (story.isLiked) {
          await _storyRepository.unlikeStory(event.storyId);
        } else {
          await _storyRepository.likeStory(event.storyId);
        }

        emit(StoryLikeStatusChanged(
          storyId: event.storyId,
          isLiked: !story.isLiked,
        ));

        final updatedStories = List.of(currentState.stories);
        updatedStories[storyIndex] = story.copyWith(
          isLiked: !story.isLiked,
          likesCount:
              story.isLiked ? story.likesCount - 1 : story.likesCount + 1,
        );

        emit(currentState.copyWith(stories: updatedStories));
      } catch (e) {
        emit(StoryFailure(e.toString()));
      }
    }
  }

  Future<void> _onStoryCommentAdded(
    StoryCommentAdded event,
    Emitter<StoryState> emit,
  ) async {
    if (state is StoryLoaded) {
      final currentState = state as StoryLoaded;
      try {
        await _storyRepository.addStoryComment(
          event.storyId,
          event.comment,
        );

        emit(StoryCommentAddedState(
          storyId: event.storyId,
          comment: event.comment,
        ));

        final storyIndex =
            currentState.stories.indexWhere((s) => s.id == event.storyId);
        if (storyIndex != -1) {
          final story = currentState.stories[storyIndex];
          final updatedStories = List.of(currentState.stories);
          updatedStories[storyIndex] =
              story.copyWith(commentsCount: story.commentsCount + 1);

          emit(currentState.copyWith(stories: updatedStories));
        }
      } catch (e) {
        emit(StoryFailure(e.toString()));
      }
    }
  }

  Future<void> _onStoryShared(
    StoryShared event,
    Emitter<StoryState> emit,
  ) async {
    if (state is StoryLoaded) {
      final currentState = state as StoryLoaded;
      try {
        await _storyRepository.shareStory(event.storyId);

        emit(StorySharedState(event.storyId));

        final storyIndex =
            currentState.stories.indexWhere((s) => s.id == event.storyId);
        if (storyIndex != -1) {
          final story = currentState.stories[storyIndex];
          final updatedStories = List.of(currentState.stories);
          updatedStories[storyIndex] =
              story.copyWith(sharesCount: story.sharesCount + 1);

          emit(currentState.copyWith(stories: updatedStories));
        }
      } catch (e) {
        emit(StoryFailure(e.toString()));
      }
    }
  }
}
