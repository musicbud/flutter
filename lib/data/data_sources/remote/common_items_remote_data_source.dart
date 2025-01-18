import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../models/common_track.dart';
import '../../../../models/common_artist.dart';
import '../../../../models/common_album.dart';
import '../../../../models/common_genre.dart';
import '../../../../models/common_anime.dart';
import '../../../../models/common_manga.dart';
import '../../../../models/categorized_common_items.dart';

abstract class CommonItemsRemoteDataSource {
  Future<List<CommonTrack>> getCommonLikedTracks(String username);
  Future<List<CommonArtist>> getCommonLikedArtists(String username);
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username);
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier,
      {int page = 1});
  Future<List<CommonArtist>> getCommonTopArtists(String username);
  Future<List<CommonGenre>> getCommonTopGenres(String username);
  Future<List<CommonAnime>> getCommonTopAnime(String username);
  Future<List<CommonManga>> getCommonTopManga(String username);
  Future<List<CommonTrack>> getCommonTracks(String budUid);
  Future<List<CommonArtist>> getCommonArtists(String budUid);
  Future<List<CommonGenre>> getCommonGenres(String budUid);
  Future<CategorizedCommonItems> getCategorizedCommonItems(String username);
}

class CommonItemsRemoteDataSourceImpl implements CommonItemsRemoteDataSource {
  final http.Client _client;
  final String _token;
  final String _baseUrl = 'https://api.musicbud.com';

  CommonItemsRemoteDataSourceImpl({
    required http.Client client,
    required String token,
  })  : _client = client,
        _token = token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/liked/tracks'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common liked tracks');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/liked/artists'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common liked artists');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/liked/albums'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common liked albums');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonAlbum.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier,
      {int page = 1}) async {
    try {
      final data = identifier.contains('@')
          ? {'username': identifier}
          : {'bud_id': identifier, 'page': page};

      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/played/tracks'),
        headers: _headers,
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common played tracks');
      }

      final responseData = jsonDecode(response.body)['data'] as List;
      return responseData.map((json) => CommonTrack.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonArtist>> getCommonTopArtists(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/artists'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common top artists');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonGenre>> getCommonTopGenres(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/genres'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common top genres');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonAnime>> getCommonTopAnime(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/anime'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common top anime');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonManga>> getCommonTopManga(String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/manga'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common top manga');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String budUid) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/tracks'),
        headers: _headers,
        body: jsonEncode({'bud_id': budUid}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common tracks');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonTrack.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String budUid) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/artists'),
        headers: _headers,
        body: jsonEncode({'bud_id': budUid}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common artists');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonArtist.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String budUid) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/top/genres'),
        headers: _headers,
        body: jsonEncode({'bud_id': budUid}),
      );

      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to get common genres');
      }

      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => CommonGenre.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CategorizedCommonItems> getCategorizedCommonItems(
      String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/bud/common/all'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            message: 'Failed to get categorized common items');
      }

      return CategorizedCommonItems.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
