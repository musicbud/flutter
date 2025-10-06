import '../../models/common_track.dart';

abstract class SpotifyRemoteDataSource {
  Future<List<CommonTrack>> getPlayedTracks();
  Future<bool> playTrackWithLocation(String trackId, String trackName, double latitude, double longitude);
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<bool> playSpotifyTrack(String trackId, {String? deviceId});
  Future<void> saveLocation(double latitude, double longitude);
  Future<List<CommonTrack>> getPlayedTracksWithLocation();
}