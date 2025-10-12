import '../../models/common_track.dart';

abstract class SpotifyRemoteDataSource {
  Future<List<SpotifyCommonTrack>> getPlayedTracks();
  Future<List<SpotifyCommonTrack>> getRecentlyPlayedTracks();
  Future<bool> playTrackWithLocation(String trackId, String trackName, double latitude, double longitude);
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<List<Map<String, dynamic>>> getAvailableDevices();
  Future<Map<String, dynamic>?> getCurrentDevice();
  Future<bool> playSpotifyTrack(String trackId, {String? deviceId});
  Future<void> transferPlayback(String deviceId);
  Future<void> play({String? deviceId});
  Future<void> pause({String? deviceId});
  Future<void> skipToNext({String? deviceId});
  Future<void> skipToPrevious({String? deviceId});
  Future<void> setVolume(int volume, {String? deviceId});
  Future<void> saveLocation(double latitude, double longitude);
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude);
  Future<List<SpotifyCommonTrack>> getPlayedTracksWithLocation();
  Future<Map<String, dynamic>> createSeedUser();
}