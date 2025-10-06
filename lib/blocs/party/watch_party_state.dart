import 'package:equatable/equatable.dart';
import '../../models/watch_party.dart';

abstract class WatchPartyState extends Equatable {
  const WatchPartyState();

  @override
  List<Object?> get props => [];
}

class WatchPartyInitial extends WatchPartyState {
  const WatchPartyInitial();
}

class WatchPartyLoading extends WatchPartyState {
  const WatchPartyLoading();
}

class WatchPartiesLoaded extends WatchPartyState {
  final List<WatchParty> parties;
  final bool hasMorePages;
  final int currentPage;
  final String? statusFilter;

  const WatchPartiesLoaded({
    required this.parties,
    this.hasMorePages = false,
    this.currentPage = 1,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [
    parties,
    hasMorePages,
    currentPage,
    statusFilter,
  ];

  WatchPartiesLoaded copyWith({
    List<WatchParty>? parties,
    bool? hasMorePages,
    int? currentPage,
    String? statusFilter,
  }) {
    return WatchPartiesLoaded(
      parties: parties ?? this.parties,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      currentPage: currentPage ?? this.currentPage,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class WatchPartyDetailLoaded extends WatchPartyState {
  final WatchParty party;
  final List<Map<String, dynamic>> chatMessages;
  final bool isHost;

  const WatchPartyDetailLoaded({
    required this.party,
    this.chatMessages = const [],
    this.isHost = false,
  });

  @override
  List<Object?> get props => [party, chatMessages, isHost];

  WatchPartyDetailLoaded copyWith({
    WatchParty? party,
    List<Map<String, dynamic>>? chatMessages,
    bool? isHost,
  }) {
    return WatchPartyDetailLoaded(
      party: party ?? this.party,
      chatMessages: chatMessages ?? this.chatMessages,
      isHost: isHost ?? this.isHost,
    );
  }
}

class ActiveWatchPartiesLoaded extends WatchPartyState {
  final List<WatchParty> parties;

  const ActiveWatchPartiesLoaded(this.parties);

  @override
  List<Object> get props => [parties];
}

class ScheduledWatchPartiesLoaded extends WatchPartyState {
  final List<WatchParty> parties;

  const ScheduledWatchPartiesLoaded(this.parties);

  @override
  List<Object> get props => [parties];
}

class WatchPartyError extends WatchPartyState {
  final String message;

  const WatchPartyError(this.message);

  @override
  List<Object> get props => [message];
}
