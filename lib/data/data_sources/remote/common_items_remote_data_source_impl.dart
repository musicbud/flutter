import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import '../../../domain/models/categorized_common_items.dart';
import 'common_items_remote_data_source.dart';

class CommonItemsRemoteDataSourceImpl implements CommonItemsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CommonItemsRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/liked/tracks/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/liked/artists/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getCommonLikedAlbums(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/liked/albums/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonAlbum.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common liked albums');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String identifier,
      {int page = 1}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/played/tracks/$identifier?page=$page'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common played tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonTopArtists(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/top/artists/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonTopGenres(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/top/genres/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top genres');
    }
  }

  @override
  Future<List<CommonAnime>> getCommonTopAnime(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/top/anime/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonAnime.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top anime');
    }
  }

  @override
  Future<List<CommonManga>> getCommonTopManga(String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/top/manga/$username'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonManga.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common top manga');
    }
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String budUid) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/tracks/$budUid'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonTrack.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String budUid) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/artists/$budUid'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonArtist.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common artists');
    }
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String budUid) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/genres/$budUid'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommonGenre.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get common genres');
    }
  }

  @override
  Future<CategorizedCommonItems> getCategorizedCommonItems(
      String username) async {
    final response = await client.get(
      Uri.parse('$baseUrl/common/items/$username'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CategorizedCommonItems.fromJson(json);
    } else {
      throw ServerException(message: 'Failed to get categorized common items');
    }
  }
}
