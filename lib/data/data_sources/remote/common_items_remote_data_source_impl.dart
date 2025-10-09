import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../../models/common_track.dart';
import '../../../models/common_artist.dart';
import '../../../models/common_album.dart';
import '../../../models/common_genre.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';
import '../../../models/categorized_common_items.dart';
import 'common_items_remote_data_source.dart';
import '../../../config/api_config.dart';
import '../../../services/endpoint_config_service.dart';

class CommonItemsRemoteDataSourceImpl implements CommonItemsRemoteDataSource {
  final http.Client _client;
  final String _token;
  final EndpointConfigService _endpointConfigService;

  CommonItemsRemoteDataSourceImpl({
    required http.Client client,
    required String token,
    required EndpointConfigService endpointConfigService,
  })  : _client = client,
        _token = token,
        _endpointConfigService = endpointConfigService;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  @override
  Future<List<CommonTrack>> getCommonLikedTracks(String username) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/bud/common/liked/tracks'),
      headers: _headers,
      body: jsonEncode({'bud_id': username}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to get common liked tracks');
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final data = responseData['results'] as List? ?? [];
    return data.map((json) => CommonTrack.fromJson(json)).toList();
  }

  @override
  Future<List<CommonArtist>> getCommonLikedArtists(String username) async {
    final url = _endpointConfigService.getEndpointUrl('common - liked artists', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonLikedArtists}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - liked albums', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonLikedAlbums}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - played tracks', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonPlayedTracks}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'identifier': identifier, 'page': page}),
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
    final url = _endpointConfigService.getEndpointUrl('common - top artists', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonTopArtists}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - top genres', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonTopGenres}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - top anime', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonTopAnime}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - top manga', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonTopManga}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'username': username}),
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
    final url = _endpointConfigService.getEndpointUrl('common - liked tracks', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonLikedTracks}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'budUid': budUid}),
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
    final url = _endpointConfigService.getEndpointUrl('common - liked artists', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonLikedArtists}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'budUid': budUid}),
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
    final url = _endpointConfigService.getEndpointUrl('common - liked genres', ApiConfig.baseUrl) ?? '${ApiConfig.baseUrl}${ApiConfig.budCommonLikedGenres}';
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode({'budUid': budUid}),
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
    // This functionality is not directly supported by the API endpoints
    // We'll combine multiple calls to create categorized items
    try {
      final likedArtists = await getCommonLikedArtists(username);
      final likedTracks = await getCommonLikedTracks(username);
      final likedAlbums = await getCommonLikedAlbums(username);
      final topGenres = await getCommonTopGenres(username);
      final topAnime = await getCommonTopAnime(username);
      final topManga = await getCommonTopManga(username);

      return CategorizedCommonItems(
        tracks: likedTracks,
        artists: likedArtists,
        albums: likedAlbums,
        genres: topGenres,
        anime: topAnime,
        manga: topManga,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to get categorized common items: $e');
    }
  }
}
