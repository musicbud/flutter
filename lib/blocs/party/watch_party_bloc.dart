import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/watch_party_repository.dart';
import 'watch_party_event.dart';
import 'watch_party_state.dart';

class WatchPartyBloc extends Bloc<WatchPartyEvent, WatchPartyState> {
  final WatchPartyRepository repository;
  String? _currentPartyId;
  StreamSubscription? _partyUpdatesSubscription;
  StreamSubscription? _chatSubscription;

  WatchPartyBloc({required this.repository}) : super(const WatchPartyInitial()) {
    on<WatchPartiesRequested>(_onWatchPartiesRequested);
    on<WatchPartyDetailsRequested>(_onPartyDetailsRequested);
    on<WatchPartyCreated>(_onPartyCreated);
    on<WatchPartyUpdated>(_onPartyUpdated);
    on<WatchPartyJoined>(_onPartyJoined);
    on<WatchPartyLeft>(_onPartyLeft);
    on<WatchPartyEnded>(_onPartyEnded);
    on<WatchPartyTrackUpdated>(_onTrackUpdated);
    on<WatchPartyMessageSent>(_onMessageSent);
    on<ActivePartiesRequested>(_onActivePartiesRequested);
    on<ScheduledPartiesRequested>(_onScheduledPartiesRequested);
  }

  Future<void> _onWatchPartiesRequested(
    WatchPartiesRequested event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      if (state is! WatchPartiesLoaded) {
        emit(const WatchPartyLoading());
      }

      final parties = await repository.getWatchParties(
        page: event.page,
        status: event.status,
      );

      if (state is WatchPartiesLoaded) {
        final currentState = state as WatchPartiesLoaded;
        if (event.page == 1) {
          emit(WatchPartiesLoaded(
            parties: parties,
            hasMorePages: parties.length >= 20,
            currentPage: 1,
            statusFilter: event.status,
          ));
        } else {
          emit(WatchPartiesLoaded(
            parties: [...currentState.parties, ...parties],
            hasMorePages: parties.length >= 20,
            currentPage: event.page,
            statusFilter: event.status,
          ));
        }
      } else {
        emit(WatchPartiesLoaded(
          parties: parties,
          hasMorePages: parties.length >= 20,
          currentPage: 1,
          statusFilter: event.status,
        ));
      }
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyDetailsRequested(
    WatchPartyDetailsRequested event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      emit(const WatchPartyLoading());
      
      final party = await repository.getWatchPartyById(event.partyId);
      
      // Cancel previous subscriptions
      await _partyUpdatesSubscription?.cancel();
      await _chatSubscription?.cancel();
      
      _currentPartyId = event.partyId;
      
      // Subscribe to party updates
      _partyUpdatesSubscription = repository
          .partyUpdates(event.partyId)
          .listen((updatedParty) {
        if (state is WatchPartyDetailLoaded) {
          final currentState = state as WatchPartyDetailLoaded;
          emit(currentState.copyWith(party: updatedParty));
        }
      });
      
      // Subscribe to chat messages
      _chatSubscription = repository
          .partyChat(event.partyId)
          .listen((messages) {
        if (state is WatchPartyDetailLoaded) {
          final currentState = state as WatchPartyDetailLoaded;
          emit(currentState.copyWith(chatMessages: messages));
        }
      });
      
      emit(WatchPartyDetailLoaded(party: party));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyCreated(
    WatchPartyCreated event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      emit(const WatchPartyLoading());
      final party = await repository.createWatchParty(event.party);
      emit(WatchPartyDetailLoaded(party: party, isHost: true));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyUpdated(
    WatchPartyUpdated event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      final updatedParty = await repository.updateWatchParty(
        event.partyId,
        title: event.title,
        description: event.description,
        startTime: event.startTime,
        endTime: event.endTime,
        settings: event.settings,
      );

      if (state is WatchPartyDetailLoaded) {
        final currentState = state as WatchPartyDetailLoaded;
        emit(currentState.copyWith(party: updatedParty));
      }
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyJoined(
    WatchPartyJoined event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      await repository.joinParty(event.partyId);
      add(WatchPartyDetailsRequested(event.partyId));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyLeft(
    WatchPartyLeft event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      await repository.leaveParty(event.partyId);
      add(const WatchPartiesRequested(page: 1));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onPartyEnded(
    WatchPartyEnded event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      await repository.endParty(event.partyId);
      add(const WatchPartiesRequested(page: 1));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onTrackUpdated(
    WatchPartyTrackUpdated event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      await repository.updateCurrentTrack(event.partyId, event.trackId);
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onMessageSent(
    WatchPartyMessageSent event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      await repository.sendPartyMessage(event.partyId, event.message);
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onActivePartiesRequested(
    ActivePartiesRequested event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      emit(const WatchPartyLoading());
      final parties = await repository.getActiveParties();
      emit(ActiveWatchPartiesLoaded(parties));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  Future<void> _onScheduledPartiesRequested(
    ScheduledPartiesRequested event,
    Emitter<WatchPartyState> emit,
  ) async {
    try {
      emit(const WatchPartyLoading());
      final parties = await repository.getScheduledParties();
      emit(ScheduledWatchPartiesLoaded(parties));
    } catch (e) {
      emit(WatchPartyError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _partyUpdatesSubscription?.cancel();
    _chatSubscription?.cancel();
    return super.close();
  }
}
