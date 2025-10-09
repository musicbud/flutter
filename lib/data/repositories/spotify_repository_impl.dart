import 'package:musicbud_flutter/data/data_sources/remote/spotify_remote_data_source.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';
import 'package:musicbud_flutter/domain/repositories/spotify_repository.dart';

class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyRemoteDataSource remoteDataSource;

  SpotifyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CommonTrack>> getPlayedTracks() {
    return remoteDataSource.getPlayedTracks();
  }

  @override
  Future<bool> playTrackWithLocation(String trackId, String trackName, double latitude, double longitude) {
    return remoteDataSource.playTrackWithLocation(trackId, trackName, latitude, longitude);
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() {
    return remoteDataSource.getSpotifyDevices();
  }

  @override
  Future<bool> playSpotifyTrack(String trackId, {String? deviceId}) {
    return remoteDataSource.playSpotifyTrack(trackId, deviceId: deviceId);
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) {
    return remoteDataSource.saveLocation(latitude, longitude);
  }

  @override
  Future<List<CommonTrack>> getRecentlyPlayedTracks() {
    return remoteDataSource.getRecentlyPlayedTracks();
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableDevices() {
    return remoteDataSource.getAvailableDevices();
  }

  @override
  Future<Map<String, dynamic>?> getCurrentDevice() {
    return remoteDataSource.getCurrentDevice();
  }

  @override
  Future<void> transferPlayback(String deviceId) {
    return remoteDataSource.transferPlayback(deviceId);
  }

  @override
  Future<void> play({String? deviceId}) {
    return remoteDataSource.play(deviceId: deviceId);
  }

  @override
  Future<void> pause({String? deviceId}) {
    return remoteDataSource.pause(deviceId: deviceId);
  }

  @override
  Future<void> skipToNext({String? deviceId}) {
    return remoteDataSource.skipToNext(deviceId: deviceId);
  }

  @override
  Future<void> skipToPrevious({String? deviceId}) {
    return remoteDataSource.skipToPrevious(deviceId: deviceId);
  }

  @override
  Future<void> setVolume(int volume, {String? deviceId}) {
    return remoteDataSource.setVolume(volume, deviceId: deviceId);
  }

  @override
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude) {
    return remoteDataSource.saveTrackLocation(trackId, latitude, longitude);
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() {
    return remoteDataSource.getPlayedTracksWithLocation();
  }

  @override
  Future<Map<String, dynamic>> createSeedUser() {
    return remoteDataSource.createSeedUser();
  }
}