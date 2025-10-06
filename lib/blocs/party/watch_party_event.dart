import 'package:equatable/equatable.dart';
import '../../models/watch_party.dart';

abstract class WatchPartyEvent extends Equatable {
  const WatchPartyEvent();

  @override
  List<Object?> get props => [];
}

class WatchPartiesRequested extends WatchPartyEvent {
  final int page;
  final String? status;

  const WatchPartiesRequested({
    this.page = 1,
    this.status,
  });

  @override
  List<Object?> get props => [page, status];
}

class WatchPartyDetailsRequested extends WatchPartyEvent {
  final String partyId;

  const WatchPartyDetailsRequested(this.partyId);

  @override
  List<Object> get props => [partyId];
}

class WatchPartyCreated extends WatchPartyEvent {
  final WatchParty party;

  const WatchPartyCreated(this.party);

  @override
  List<Object> get props => [party];
}

class WatchPartyUpdated extends WatchPartyEvent {
  final String partyId;
  final String? title;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final Map<String, dynamic>? settings;

  const WatchPartyUpdated({
    required this.partyId,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.settings,
  });

  @override
  List<Object?> get props => [
    partyId,
    title,
    description,
    startTime,
    endTime,
    settings,
  ];
}

class WatchPartyJoined extends WatchPartyEvent {
  final String partyId;

  const WatchPartyJoined(this.partyId);

  @override
  List<Object> get props => [partyId];
}

class WatchPartyLeft extends WatchPartyEvent {
  final String partyId;

  const WatchPartyLeft(this.partyId);

  @override
  List<Object> get props => [partyId];
}

class WatchPartyEnded extends WatchPartyEvent {
  final String partyId;

  const WatchPartyEnded(this.partyId);

  @override
  List<Object> get props => [partyId];
}

class WatchPartyTrackUpdated extends WatchPartyEvent {
  final String partyId;
  final String trackId;

  const WatchPartyTrackUpdated({
    required this.partyId,
    required this.trackId,
  });

  @override
  List<Object> get props => [partyId, trackId];
}

class WatchPartyMessageSent extends WatchPartyEvent {
  final String partyId;
  final String message;

  const WatchPartyMessageSent({
    required this.partyId,
    required this.message,
  });

  @override
  List<Object> get props => [partyId, message];
}

class ActivePartiesRequested extends WatchPartyEvent {
  const ActivePartiesRequested();
}

class ScheduledPartiesRequested extends WatchPartyEvent {
  const ScheduledPartiesRequested();
}
