import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/bud_matching_repository.dart';

// Events
abstract class BudMatchingEvent extends Equatable {
  const BudMatchingEvent();

  @override
  List<Object?> get props => [];
}

class SearchBuds extends BudMatchingEvent {
  final String query;
  final Map<String, dynamic>? filters;

  const SearchBuds({required this.query, this.filters});

  @override
  List<Object?> get props => [query, filters];
}

class GetBudProfile extends BudMatchingEvent {
  final String budId;

  const GetBudProfile({required this.budId});

  @override
  List<Object?> get props => [budId];
}

class GetBudLikedContent extends BudMatchingEvent {
  final String contentType; // artists, tracks, genres, albums
  final String budId;

  const GetBudLikedContent({
    required this.contentType,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, budId];
}

class GetBudTopContent extends BudMatchingEvent {
  final String contentType; // artists, tracks, genres, anime, manga
  final String budId;

  const GetBudTopContent({
    required this.contentType,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, budId];
}

class GetBudPlayedTracks extends BudMatchingEvent {
  final String budId;

  const GetBudPlayedTracks({required this.budId});

  @override
  List<Object?> get props => [budId];
}

class GetBudCommonLikedContent extends BudMatchingEvent {
  final String contentType; // artists, tracks, genres, albums
  final String budId;

  const GetBudCommonLikedContent({
    required this.contentType,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, budId];
}

class GetBudCommonTopContent extends BudMatchingEvent {
  final String contentType; // artists, tracks, genres, anime, manga
  final String budId;

  const GetBudCommonTopContent({
    required this.contentType,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, budId];
}

class GetBudCommonPlayedTracks extends BudMatchingEvent {
  final String budId;

  const GetBudCommonPlayedTracks({required this.budId});

  @override
  List<Object?> get props => [budId];
}

class GetBudSpecificContent extends BudMatchingEvent {
  final String contentType; // artist, track, genre, album
  final String contentId;
  final String budId;

  const GetBudSpecificContent({
    required this.contentType,
    required this.contentId,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, contentId, budId];
}

// States
abstract class BudMatchingState extends Equatable {
  const BudMatchingState();

  @override
  List<Object?> get props => [];
}

class BudMatchingInitial extends BudMatchingState {}

class BudMatchingLoading extends BudMatchingState {}

class BudsSearchResults extends BudMatchingState {
  final List<dynamic> buds;
  final String query;

  const BudsSearchResults({
    required this.buds,
    required this.query,
  });

  @override
  List<Object?> get props => [buds, query];
}

class BudProfileLoaded extends BudMatchingState {
  final Map<String, dynamic> budProfile;
  final String budId;

  const BudProfileLoaded({
    required this.budProfile,
    required this.budId,
  });

  @override
  List<Object?> get props => [budProfile, budId];
}

class BudContentLoaded extends BudMatchingState {
  final String contentType;
  final List<dynamic> content;
  final String budId;

  const BudContentLoaded({
    required this.contentType,
    required this.content,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, content, budId];
}

class BudCommonContentLoaded extends BudMatchingState {
  final String contentType;
  final List<dynamic> commonContent;
  final String budId;

  const BudCommonContentLoaded({
    required this.contentType,
    required this.commonContent,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, commonContent, budId];
}

class BudSpecificContentLoaded extends BudMatchingState {
  final String contentType;
  final Map<String, dynamic> content;
  final String contentId;
  final String budId;

  const BudSpecificContentLoaded({
    required this.contentType,
    required this.content,
    required this.contentId,
    required this.budId,
  });

  @override
  List<Object?> get props => [contentType, content, contentId, budId];
}

class BudMatchingError extends BudMatchingState {
  final String message;

  const BudMatchingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class BudMatchingBloc extends Bloc<BudMatchingEvent, BudMatchingState> {
  final BudMatchingRepository _budMatchingRepository;

  BudMatchingBloc({required BudMatchingRepository budMatchingRepository})
      : _budMatchingRepository = budMatchingRepository,
        super(BudMatchingInitial()) {
    on<SearchBuds>(_onSearchBuds);
    on<GetBudProfile>(_onGetBudProfile);
    on<GetBudLikedContent>(_onGetBudLikedContent);
    on<GetBudTopContent>(_onGetBudTopContent);
    on<GetBudPlayedTracks>(_onGetBudPlayedTracks);
    on<GetBudCommonLikedContent>(_onGetBudCommonLikedContent);
    on<GetBudCommonTopContent>(_onGetBudCommonTopContent);
    on<GetBudCommonPlayedTracks>(_onGetBudCommonPlayedTracks);
    on<GetBudSpecificContent>(_onGetBudSpecificContent);
  }

  Future<void> _onSearchBuds(
    SearchBuds event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final buds = await _budMatchingRepository.searchBuds(event.query, event.filters);
      emit(BudsSearchResults(buds: buds, query: event.query));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudProfile(
    GetBudProfile event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final profile = await _budMatchingRepository.getBudProfile(event.budId);
      emit(BudProfileLoaded(budProfile: profile, budId: event.budId));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudLikedContent(
    GetBudLikedContent event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final content = await _budMatchingRepository.getBudLikedContent(
        event.contentType,
        event.budId,
      );
      emit(BudContentLoaded(
        contentType: event.contentType,
        content: content,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudTopContent(
    GetBudTopContent event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final content = await _budMatchingRepository.getBudTopContent(
        event.contentType,
        event.budId,
      );
      emit(BudContentLoaded(
        contentType: event.contentType,
        content: content,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudPlayedTracks(
    GetBudPlayedTracks event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final tracks = await _budMatchingRepository.getBudPlayedTracks(event.budId);
      emit(BudContentLoaded(
        contentType: 'played_tracks',
        content: tracks,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudCommonLikedContent(
    GetBudCommonLikedContent event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final content = await _budMatchingRepository.getBudCommonLikedContent(
        event.contentType,
        event.budId,
      );
      emit(BudCommonContentLoaded(
        contentType: event.contentType,
        commonContent: content,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudCommonTopContent(
    GetBudCommonTopContent event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final content = await _budMatchingRepository.getBudCommonTopContent(
        event.contentType,
        event.budId,
      );
      emit(BudCommonContentLoaded(
        contentType: event.contentType,
        commonContent: content,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudCommonPlayedTracks(
    GetBudCommonPlayedTracks event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final tracks = await _budMatchingRepository.getBudCommonPlayedTracks(event.budId);
      emit(BudCommonContentLoaded(
        contentType: 'played_tracks',
        commonContent: tracks,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onGetBudSpecificContent(
    GetBudSpecificContent event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final content = await _budMatchingRepository.getBudSpecificContent(
        event.contentType,
        event.contentId,
        event.budId,
      );
      emit(BudSpecificContentLoaded(
        contentType: event.contentType,
        content: content,
        contentId: event.contentId,
        budId: event.budId,
      ));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }
}