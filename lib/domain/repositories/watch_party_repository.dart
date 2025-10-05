import '../models/watch_party.dart';

abstract class WatchPartyRepository {
  /// Get all watch parties
  Future<List<WatchParty>> getWatchParties({
    int page = 1,
    int limit = 20,
    String? status,
  });

  /// Get watch party by id
  Future<WatchParty> getWatchPartyById(String partyId);

  /// Create a new watch party
  Future<WatchParty> createWatchParty(WatchParty party);

  /// Update watch party details
  Future<WatchParty> updateWatchParty(String partyId, {
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Map<String, dynamic>? settings,
  });

  /// Join a watch party
  Future<void> joinParty(String partyId);

  /// Leave a watch party
  Future<void> leaveParty(String partyId);

  /// End a watch party (host only)
  Future<void> endParty(String partyId);

  /// Update current track
  Future<void> updateCurrentTrack(String partyId, String trackId);

  /// Get user's active watch parties
  Future<List<WatchParty>> getActiveParties();

  /// Get user's scheduled watch parties
  Future<List<WatchParty>> getScheduledParties();

  /// Get party updates stream
  Stream<WatchParty> partyUpdates(String partyId);

  /// Get party chat messages
  Stream<List<Map<String, dynamic>>> partyChat(String partyId);

  /// Send party chat message
  Future<void> sendPartyMessage(String partyId, String message);
}
