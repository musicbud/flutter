import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class MatchesRequested extends MatchEvent {
  final int page;
  final Map<String, dynamic>? filters;

  const MatchesRequested({
    this.page = 1,
    this.filters,
  });

  @override
  List<Object?> get props => [page, filters];
}

class MatchProfileRequested extends MatchEvent {
  final String matchId;

  const MatchProfileRequested(this.matchId);

  @override
  List<Object> get props => [matchId];
}

class MatchPreferencesUpdated extends MatchEvent {
  final Map<String, dynamic> preferences;

  const MatchPreferencesUpdated(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class MatchRequestSent extends MatchEvent {
  final String matchId;

  const MatchRequestSent(this.matchId);

  @override
  List<Object> get props => [matchId];
}

class MatchRequestHandled extends MatchEvent {
  final String requestId;
  final bool accepted;

  const MatchRequestHandled({
    required this.requestId,
    required this.accepted,
  });

  @override
  List<Object> get props => [requestId, accepted];
}

class MatchSuggestionsRequested extends MatchEvent {
  const MatchSuggestionsRequested();
}

class MatchBlocked extends MatchEvent {
  final String matchId;
  final String? reason;

  const MatchBlocked({
    required this.matchId,
    this.reason,
  });

  @override
  List<Object?> get props => [matchId, reason];
}

class MatchReported extends MatchEvent {
  final String matchId;
  final String reason;

  const MatchReported({
    required this.matchId,
    required this.reason,
  });

  @override
  List<Object> get props => [matchId, reason];
}
