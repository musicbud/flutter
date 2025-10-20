import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/track.dart';

/// Local data source for tracking record persistence
abstract class TrackingLocalDataSource {
  Future<void> savePlayedTrack(Track track);
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude);
  Future<List<Track>> getPlayedTracks();
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<void> clearPlayedTracks();
}

class TrackingLocalDataSourceImpl implements TrackingLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String _playedTracksKey = 'played_tracks';
  static const String _trackLocationsKey = 'track_locations';

  TrackingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> savePlayedTrack(Track track) async {
    try {
      // Get existing played tracks
      final existingTracks = await getPlayedTracks();
      
      // Add or update the track with current timestamp
      final updatedTrack = Track(
        uid: track.id ?? '',
        title: track.name,
        artistName: track.artistName,
        albumName: track.albumName,
        imageUrl: track.imageUrl,
        latitude: track.latitude,
        longitude: track.longitude,
        playedAt: DateTime.now(),
        isLiked: track.isLiked,
      );
      
      // Remove existing instance of this track if exists
      existingTracks.removeWhere((t) => t.id == track.id);
      
      // Add the updated track to the beginning of the list
      existingTracks.insert(0, updatedTrack);
      
      // Keep only the most recent 100 tracks to prevent storage bloat
      if (existingTracks.length > 100) {
        existingTracks.removeRange(100, existingTracks.length);
      }
      
      // Save to SharedPreferences
      final tracksJson = existingTracks.map((t) => t.toJson()).toList();
      await sharedPreferences.setString(_playedTracksKey, jsonEncode(tracksJson));
    } catch (e) {
      throw Exception('Failed to save played track: $e');
    }
  }

  @override
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude) async {
    try {
      // Get existing track locations
      final locationsJson = sharedPreferences.getString(_trackLocationsKey);
      Map<String, Map<String, dynamic>> locations = {};
      
      if (locationsJson != null) {
        final decoded = jsonDecode(locationsJson) as Map<String, dynamic>;
        locations = decoded.map((key, value) => MapEntry(key, value as Map<String, dynamic>));
      }
      
      // Save or update location for this track
      locations[trackId] = {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // Save to SharedPreferences
      await sharedPreferences.setString(_trackLocationsKey, jsonEncode(locations));
      
      // Also update any existing played track with this location
      await _updatePlayedTrackLocation(trackId, latitude, longitude);
    } catch (e) {
      throw Exception('Failed to save track location: $e');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    try {
      final tracksJson = sharedPreferences.getString(_playedTracksKey);
      if (tracksJson == null) return [];
      
      final tracksList = jsonDecode(tracksJson) as List<dynamic>;
      return tracksList
          .map((json) => Track.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load played tracks: $e');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    try {
      final allTracks = await getPlayedTracks();
      return allTracks.where((track) => track.latitude != null && track.longitude != null).toList();
    } catch (e) {
      throw Exception('Failed to load played tracks with location: $e');
    }
  }

  @override
  Future<void> clearPlayedTracks() async {
    try {
      await sharedPreferences.remove(_playedTracksKey);
      await sharedPreferences.remove(_trackLocationsKey);
    } catch (e) {
      throw Exception('Failed to clear played tracks: $e');
    }
  }

  /// Update location data for existing played tracks
  Future<void> _updatePlayedTrackLocation(String trackId, double latitude, double longitude) async {
    try {
      final tracks = await getPlayedTracks();
      bool updated = false;
      
      for (int i = 0; i < tracks.length; i++) {
        if (tracks[i].id == trackId) {
          // Update the track with location data
          tracks[i] = Track(
            uid: tracks[i].id ?? '',
            title: tracks[i].name,
            artistName: tracks[i].artistName,
            albumName: tracks[i].albumName,
            imageUrl: tracks[i].imageUrl,
            latitude: latitude,
            longitude: longitude,
            playedAt: tracks[i].playedAt,
            isLiked: tracks[i].isLiked,
          );
          updated = true;
        }
      }
      
      // Save updated tracks if any were modified
      if (updated) {
        final tracksJson = tracks.map((t) => t.toJson()).toList();
        await sharedPreferences.setString(_playedTracksKey, jsonEncode(tracksJson));
      }
    } catch (e) {
      // Log error but don't throw to avoid disrupting the main location save operation
      // Warning: Failed to update played track location: $e
    }
  }
}