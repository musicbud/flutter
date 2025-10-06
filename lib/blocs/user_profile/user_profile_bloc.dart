import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../models/user_profile.dart';

// Events
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends UserProfileEvent {
  final String userId;

  const FetchUserProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FetchMyProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final UserProfileUpdateRequest updateRequest;

  const UpdateUserProfile({required this.updateRequest});

  @override
  List<Object?> get props => [updateRequest];
}

class UpdateUserLikes extends UserProfileEvent {
  final Map<String, dynamic> likesData;

  const UpdateUserLikes({required this.likesData});

  @override
  List<Object?> get props => [likesData];
}

class FetchUserLikedContent extends UserProfileEvent {
  final String contentType; // artists, tracks, genres, albums
  final String userId;

  const FetchUserLikedContent({
    required this.contentType,
    required this.userId,
  });

  @override
  List<Object?> get props => [contentType, userId];
}

class FetchMyLikedContent extends UserProfileEvent {
  final String contentType; // artists, tracks, genres, albums

  const FetchMyLikedContent({required this.contentType});

  @override
  List<Object?> get props => [contentType];
}

class FetchUserTopContent extends UserProfileEvent {
  final String contentType; // artists, tracks, genres, anime, manga
  final String userId;

  const FetchUserTopContent({
    required this.contentType,
    required this.userId,
  });

  @override
  List<Object?> get props => [contentType, userId];
}

class FetchMyTopContent extends UserProfileEvent {
  final String contentType; // artists, tracks, genres, anime, manga

  const FetchMyTopContent({required this.contentType});

  @override
  List<Object?> get props => [contentType];
}

class FetchUserPlayedTracks extends UserProfileEvent {
  final String userId;

  const FetchUserPlayedTracks({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FetchMyPlayedTracks extends UserProfileEvent {}

// States
abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileUpdated extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileUpdated({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class UserLikesUpdated extends UserProfileState {
  final Map<String, dynamic> likesData;

  const UserLikesUpdated({required this.likesData});

  @override
  List<Object?> get props => [likesData];
}

class UserContentLoaded extends UserProfileState {
  final String contentType;
  final List<dynamic> content;
  final String userId;

  const UserContentLoaded({
    required this.contentType,
    required this.content,
    required this.userId,
  });

  @override
  List<Object?> get props => [contentType, content, userId];
}

class MyContentLoaded extends UserProfileState {
  final String contentType;
  final List<dynamic> content;

  const MyContentLoaded({
    required this.contentType,
    required this.content,
  });

  @override
  List<Object?> get props => [contentType, content];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _userProfileRepository;

  UserProfileBloc({required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository,
        super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchMyProfile>(_onFetchMyProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserLikes>(_onUpdateUserLikes);
    on<FetchUserLikedContent>(_onFetchUserLikedContent);
    on<FetchMyLikedContent>(_onFetchMyLikedContent);
    on<FetchUserTopContent>(_onFetchUserTopContent);
    on<FetchMyTopContent>(_onFetchMyTopContent);
    on<FetchUserPlayedTracks>(_onFetchUserPlayedTracks);
    on<FetchMyPlayedTracks>(_onFetchMyPlayedTracks);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final userProfile = await _userProfileRepository.getUserProfile(event.userId);
      emit(UserProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchMyProfile(
    FetchMyProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final userProfile = await _userProfileRepository.getMyProfile();
      emit(UserProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final updatedProfile = await _userProfileRepository.updateProfile(event.updateRequest);
      emit(UserProfileUpdated(userProfile: updatedProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateUserLikes(
    UpdateUserLikes event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      await _userProfileRepository.updateLikes(event.likesData);
      emit(UserLikesUpdated(likesData: event.likesData));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchUserLikedContent(
    FetchUserLikedContent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final content = await _userProfileRepository.getUserLikedContent(
        event.contentType,
        event.userId,
      );
      emit(UserContentLoaded(
        contentType: event.contentType,
        content: content,
        userId: event.userId,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchMyLikedContent(
    FetchMyLikedContent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final content = await _userProfileRepository.getMyLikedContent(event.contentType);
      emit(MyContentLoaded(
        contentType: event.contentType,
        content: content,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchUserTopContent(
    FetchUserTopContent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final content = await _userProfileRepository.getUserTopContent(
        event.contentType,
        event.userId,
      );
      emit(UserContentLoaded(
        contentType: event.contentType,
        content: content,
        userId: event.userId,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchMyTopContent(
    FetchMyTopContent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final content = await _userProfileRepository.getMyTopContent(event.contentType);
      emit(MyContentLoaded(
        contentType: event.contentType,
        content: content,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchUserPlayedTracks(
    FetchUserPlayedTracks event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final tracks = await _userProfileRepository.getUserPlayedTracks(event.userId);
      emit(UserContentLoaded(
        contentType: 'played_tracks',
        content: tracks,
        userId: event.userId,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchMyPlayedTracks(
    FetchMyPlayedTracks event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileLoading());
      final tracks = await _userProfileRepository.getMyPlayedTracks();
      emit(MyContentLoaded(
        contentType: 'played_tracks',
        content: tracks,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}