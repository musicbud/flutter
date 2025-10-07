import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/match_repository.dart';
import 'match_event.dart' as events;
import 'match_state.dart' as states;

// Specify concrete types
typedef MatchEvent = events.MatchEvent;
typedef MatchState = states.MatchState;
typedef MatchInitial = states.MatchInitial;
typedef MatchLoading = states.MatchLoading;
typedef MatchesLoaded = states.MatchesLoaded;
typedef MatchError = states.MatchError;
typedef MatchProfileLoaded = states.MatchProfileLoaded;
typedef MatchSuggestionsLoaded = states.MatchSuggestionsLoaded;

typedef MatchesRequested = events.MatchesRequested;
typedef MatchProfileRequested = events.MatchProfileRequested;
typedef MatchPreferencesUpdated = events.MatchPreferencesUpdated;
typedef MatchRequestSent = events.MatchRequestSent;
typedef MatchRequestHandled = events.MatchRequestHandled;
typedef MatchSuggestionsRequested = events.MatchSuggestionsRequested;
typedef MatchBlocked = events.MatchBlocked;
typedef MatchReported = events.MatchReported;

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository repository;
  StreamSubscription? _onlineMatchesSubscription;
  StreamSubscription? _matchRequestsSubscription;

  MatchBloc({required this.repository}) : super(const MatchInitial()) {
    on<MatchesRequested>(_onMatchesRequested);
    on<MatchProfileRequested>(_onMatchProfileRequested);
    on<MatchPreferencesUpdated>(_onPreferencesUpdated);
    on<MatchRequestSent>(_onRequestSent);
    on<MatchRequestHandled>(_onRequestHandled);
    on<MatchSuggestionsRequested>(_onSuggestionsRequested);
    on<MatchBlocked>(_onMatchBlocked);
    on<MatchReported>(_onMatchReported);

    _onlineMatchesSubscription = repository.onlineMatches.listen(
      (onlineIds) {
        // TODO: Handle online matches updates
      },
    );

    _matchRequestsSubscription = repository.matchRequests.listen(
      (request) {
        // TODO: Handle incoming match requests properly
        // You might want to emit a different state or handle it differently
      },
    );
  }

  Future<void> _onMatchesRequested(
    MatchesRequested event,
    Emitter<MatchState> emit,
  ) async {
    try {
      if (state is! MatchesLoaded) {
        emit(const MatchLoading());
      }

      final matches = await repository.getMatches(
        page: event.page,
        filters: event.filters,
      );

      if (state is MatchesLoaded) {
        final currentState = state as MatchesLoaded;
        if (event.page == 1) {
          emit(MatchesLoaded(
            matches: matches,
            hasMorePages: matches.length >= 20,
            currentPage: 1,
            activeFilters: event.filters ?? const {},
          ));
        } else {
          emit(MatchesLoaded(
            matches: [...currentState.matches, ...matches],
            hasMorePages: matches.length >= 20,
            currentPage: event.page,
            activeFilters: event.filters ?? const {},
            onlineMatchIds: currentState.onlineMatchIds,
          ));
        }
      } else {
        emit(MatchesLoaded(
          matches: matches,
          hasMorePages: matches.length >= 20,
          currentPage: 1,
          activeFilters: event.filters ?? const {},
        ));
      }
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onMatchProfileRequested(
    MatchProfileRequested event,
    Emitter<MatchState> emit,
  ) async {
    try {
      emit(const MatchLoading());
      final profile = await repository.getMatchProfile(event.matchId);
      emit(MatchProfileLoaded(profile: profile));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onPreferencesUpdated(
    MatchPreferencesUpdated event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await repository.updatePreferences(event.preferences);
      
      // Refresh matches with new preferences
      add(const MatchesRequested(page: 1));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onRequestSent(
    MatchRequestSent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await repository.sendMatchRequest(event.matchId);
      // TODO: Emit appropriate state after sending request
      // emit(MatchRequestSentSuccess(matchId: event.matchId));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onRequestHandled(
    MatchRequestHandled event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await repository.handleMatchRequest(event.requestId, event.accepted);
      
      // Refresh matches after handling request
      add(const MatchesRequested(page: 1));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onSuggestionsRequested(
    MatchSuggestionsRequested event,
    Emitter<MatchState> emit,
  ) async {
    try {
      final suggestions = await repository.getSuggestions();
      emit(MatchSuggestionsLoaded(suggestions: suggestions));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onMatchBlocked(
    MatchBlocked event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await repository.blockMatch(event.matchId, reason: event.reason);
      
      // Refresh matches after blocking
      add(const MatchesRequested(page: 1));
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  Future<void> _onMatchReported(
    MatchReported event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await repository.reportMatch(event.matchId, event.reason);
    } catch (e) {
      emit(MatchError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _onlineMatchesSubscription?.cancel();
    _matchRequestsSubscription?.cancel();
    return super.close();
  }
}
