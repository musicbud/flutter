import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../models/user_profile.dart';
import '../../../../models/track.dart';
import '../../../../models/artist.dart';
import '../../../../models/album.dart';
import '../../../../models/genre.dart';
import '../../../../models/anime.dart';
import '../../../../models/manga.dart';

abstract class UserRemoteDataSource {
  // Profile operations
  Future<UserProfile> getMyProfile();
  Future<UserProfile> getBudProfile(String username);
  Future<void> updateMyProfile(UserProfile profile);
  Future<void> updateMyLikes();

  // Liked items
  Future<List<Artist>> getLikedArtists();
  Future<List<Track>> getLikedTracks();
  Future<List<Album>> getLikedAlbums();
  Future<List<Genre>> getLikedGenres();
  Future<List<Track>> getPlayedTracks();

  // Top items
  Future<List<Artist>> getTopArtists();
  Future<List<Track>> getTopTracks();
  Future<List<Genre>> getTopGenres();
  Future<List<Anime>> getTopAnime();
  Future<List<Manga>> getTopManga();

  // Location
  Future<void> saveLocation(double latitude, double longitude);
  Future<List<Track>> getPlayedTracksWithLocation();
  Future<List<Track>> getCurrentlyPlayedTracks();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String token;

  UserRemoteDataSourceImpl({required this.client, required this.token});

  @override
  Future<UserProfile> getMyProfile() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to get profile');
    }
  }

  @override
  Future<UserProfile> getBudProfile(String username) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/profile?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to get bud profile');
    }
  }

  @override
  Future<void> updateMyProfile(UserProfile profile) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/me/profile/set'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> updateMyLikes() async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/me/likes/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update likes');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/liked/artists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked artists');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/liked/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/liked/albums'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked albums');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/liked/genres'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get liked genres');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/played/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get played tracks');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/top/artists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top artists');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/top/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top tracks');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/top/genres'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top genres');
    }
  }

  @override
  Future<List<Anime>> getTopAnime() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/top/anime'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Anime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top anime');
    }
  }

  @override
  Future<List<Manga>> getTopManga() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/top/manga'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Manga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get top manga');
    }
  }

  @override
  Future<void> saveLocation(double latitude, double longitude) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/me/location/save'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to save location');
    }
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/spotify/played-tracks-with-location'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(
          message: 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<Track>> getCurrentlyPlayedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/me/currently-played'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get currently played tracks');
    }
  }
}
