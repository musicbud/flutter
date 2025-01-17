import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../models/common_artist.dart';
import '../../../models/common_track.dart';
import '../../../models/common_album.dart';
import '../../../models/common_genre.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';

abstract class CommonItemsRemoteDataSource {
  Future<List<CommonArtist>> getCommonLikedArtists(String username);
  Future<List<CommonTrack>> getCommonLikedTracks(String username);
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username);
  Future<List<CommonGenre>> getCommonLikedGenres(String username);
  Future<List<CommonTrack>> getCommonPlayedTracks(String username);
  Future<List<CommonArtist>> getCommonTopArtists(String username);
  Future<List<CommonTrack>> getCommonTopTracks(String username);
  Future<List<CommonGenre>> getCommonTopGenres(String username);
  Future<List<CommonAnime>> getCommonTopAnime(String username);
  Future<List<CommonManga>> getCommonTopManga(String username);
}

class CommonItemsRemoteDataSourceImpl implements CommonItemsRemoteDataSource {
  final http.Client client;
  final String token;

  CommonItemsRemoteDataSourceImpl({required this.client, required this.token});

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/liked/artists?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked artists');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/liked/tracks?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked tracks');
    }
  }

  @override
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/liked/albums?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonLikedGenres(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/liked/genres?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked genres');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/played/tracks?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonTopArtists(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/top/artists?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top artists');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTopTracks(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/top/tracks?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top tracks');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonTopGenres(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/top/genres?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getCommonTopAnime(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/top/anime?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top anime');
    }
  }

  @override
  Future<List<CommonManga>> getCommonTopManga(String username) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/bud/common/top/manga?username=$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top manga');
    }
  }
}
