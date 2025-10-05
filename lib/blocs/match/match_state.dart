import 'package:equatable/equatable.dart';
import '../../domain/models/match_profile.dart';

sealed class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];

  factory MatchState.initial() => const MatchInitial();
  factory MatchState.loading() => const MatchLoading();
  factory MatchState.loaded(
    List<MatchProfile> matches, {
    bool? hasMorePages,
    int? currentPage,
    Map<String, dynamic>? activeFilters,
    List<String>? onlineMatchIds,
  }) {
    return MatchesLoaded(
      matches: matches,
      hasMorePages: hasMorePages ?? false,
      currentPage: currentPage ?? 1,
      activeFilters: activeFilters ?? const {},
      onlineMatchIds: onlineMatchIds ?? const [],
    );
  }
  factory MatchState.error({required String message}) => MatchError(message: message);
  factory MatchState.profileLoaded(MatchProfile profile, {bool isOnline = false}) => 
      MatchProfileLoaded(profile: profile, isOnline: isOnline);
  factory MatchState.suggestionsLoaded(List<MatchProfile> suggestions) => 
      MatchSuggestionsLoaded(suggestions: suggestions);
}

final class MatchInitial extends MatchState {
  const MatchInitial();
}

final class MatchLoading extends MatchState {
  const MatchLoading();
}

final class MatchesLoaded extends MatchState {
  final List<MatchProfile> matches;
  final bool hasMorePages;
  final int currentPage;
  final Map<String, dynamic> activeFilters;
  final List<String> onlineMatchIds;

  const MatchesLoaded({
    required this.matches,
    this.hasMorePages = false,
    this.currentPage = 1,
    this.activeFilters = const {},
    this.onlineMatchIds = const [],
  });

  @override
  List<Object?> get props => [
        matches,
        hasMorePages,
        currentPage,
        activeFilters,
        onlineMatchIds,
      ];

  MatchesLoaded copyWith({
    List<MatchProfile>? matches,
    bool? hasMorePages,
    int? currentPage,
    Map<String, dynamic>? activeFilters,
    List<String>? onlineMatchIds,
  }) {
    return MatchesLoaded(
      matches: matches ?? this.matches,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      currentPage: currentPage ?? this.currentPage,
      activeFilters: activeFilters ?? this.activeFilters,
      onlineMatchIds: onlineMatchIds ?? this.onlineMatchIds,
    );
  }
}

final class MatchProfileLoaded extends MatchState {
  final MatchProfile profile;
  final bool isOnline;

  const MatchProfileLoaded({
    required this.profile,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [profile, isOnline];
}

final class MatchSuggestionsLoaded extends MatchState {
  final List<MatchProfile> suggestions;

  const MatchSuggestionsLoaded({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

final class MatchError extends MatchState {
  final String message;

  const MatchError({required this.message});

  @override
  List<Object> get props => [message];
}
