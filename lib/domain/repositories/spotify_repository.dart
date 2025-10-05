import '../../domain/models/common_track.dart';

abstract class SpotifyRepository {
  Future<List<CommonTrack>> getRecentlyPlayedTracks();
  Future<List<Map<String, dynamic>>> getAvailableDevices();
  Future<Map<String, dynamic>?> getCurrentDevice();
  Future<void> transferPlayback(String deviceId);
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude);
  Future<void> play({String? deviceId});
  Future<void> pause({String? deviceId});
  Future<void> skipToNext({String? deviceId});
  Future<void> skipToPrevious({String? deviceId});
  Future<void> setVolume(int volume, {String? deviceId});
}
