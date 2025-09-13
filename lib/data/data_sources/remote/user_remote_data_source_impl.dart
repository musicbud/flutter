import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/models/track.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import 'user_remote_data_source.dart';
import '../../providers/token_provider.dart';
import '../../network/dio_client.dart';
import '../../../config/api_config.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final TokenProvider _tokenProvider;

  UserRemoteDataSourceImpl({
    required DioClient dioClient,
    required TokenProvider tokenProvider,
  })  : _dioClient = dioClient,
        _tokenProvider = tokenProvider;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_tokenProvider.token}',
  };

  @override
  Future<UserProfile> getUserProfile() async {
    debugPrint('Getting profile with token: ${_tokenProvider.token}');
    final response = await _dioClient.post(ApiConfig.myProfile);

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      debugPrint('Failed to get profile. Status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('Headers sent: $_headers');
      throw ServerException(message: 'Failed to get user profile');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await _dioClient.post(ApiConfig.myLikedTracks);

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked tracks');
    }
  }

  @override
  Future<void> likeSong(String songId) async {
    final response = await _dioClient.post(ApiConfig.updateLikes, data: {
      'contentId': songId,
      'contentType': 'track',
    });

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to like song');
    }
  }

  @override
  Future<void> unlikeSong(String songId) async {
    final response = await _dioClient.post(ApiConfig.updateLikes, data: {
      'contentId': songId,
      'contentType': 'track',
      'action': 'unlike',
    });

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unlike song');
    }
  }

  @override
  void updateToken(String newToken) {
    _tokenProvider.updateToken(newToken);
  }

  @override
  Future<UserProfile> getMyProfile() async {
    return getUserProfile();
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final response = await _dioClient.post(ApiConfig.budProfile, data: {
      'username': username,
    });

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      throw ServerException(message: 'Failed to get bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await _dioClient.post(
      ApiConfig.updateProfile,
      data: profile.toJson(),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await _dioClient.post(ApiConfig.updateLikes);

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update likes');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    final response = await _dioClient.post(ApiConfig.myLikedArtists);

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.data);
      return artistsJson.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    final response = await _dioClient.post(ApiConfig.myLikedAlbums);

    if (response.statusCode == 200) {
      final List<dynamic> albumsJson = json.decode(response.data);
      return albumsJson.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    final response = await _dioClient.post(ApiConfig.myLikedGenres);

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.data);
      return genresJson.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await _dioClient.post(ApiConfig.myTopArtists);

    if (response.statusCode == 200) {
      final List<dynamic> artistsJson = json.decode(response.data);
      return artistsJson.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await _dioClient.post(ApiConfig.myTopTracks);

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await _dioClient.post(ApiConfig.myTopGenres);

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.data);
      return genresJson.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await _dioClient.post(ApiConfig.myTopAnime);

    if (response.statusCode == 200) {
      final List<dynamic> animeJson = json.decode(response.data);
      return animeJson.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top anime');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await _dioClient.post(ApiConfig.myTopManga);

    if (response.statusCode == 200) {
      final List<dynamic> mangaJson = json.decode(response.data);
      return mangaJson.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top manga');
    }
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _dioClient.get(ApiConfig.serviceLogin);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    final response = await _dioClient.post(
      ApiConfig.spotifyConnect,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect Spotify not supported by API');
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _dioClient.get(ApiConfig.serviceLogin);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    final response = await _dioClient.post(
      ApiConfig.ytmusicConnect,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect YouTube Music not supported by API');
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _dioClient.get(ApiConfig.serviceLogin);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get MyAnimeList auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    final response = await _dioClient.post(
      ApiConfig.malConnect,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect MyAnimeList not supported by API');
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _dioClient.get(ApiConfig.serviceLogin);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      return data['url'] as String;
    } else {
      throw ServerException(message: 'Failed to get Last.fm auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    final response = await _dioClient.post(
      ApiConfig.lastfmConnect,
      data: json.encode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Last.fm');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Disconnect Last.fm not supported by API');
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Save location not supported by API');
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await _dioClient.post(ApiConfig.myPlayedTracks);

    if (response.statusCode == 200) {
      final List<dynamic> tracksJson = json.decode(response.data);
      return tracksJson.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get played tracks');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    // This endpoint is not in the requirements, so we'll use the regular played tracks
    return getPlayedTracks();
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    // This endpoint is not in the requirements, so we'll throw an error
    throw ServerException(message: 'Currently played tracks not supported by API');
  }
}
