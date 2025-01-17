import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../models/bud.dart';

abstract class BudRemoteDataSource {
  Future<List<Bud>> getBudsByLikedArtists();
  Future<List<Bud>> getBudsByLikedTracks();
  Future<List<Bud>> getBudsByLikedGenres();
  Future<List<Bud>> getBudsByLikedAlbums();
  Future<List<Bud>> getBudsByPlayedTracks();
  Future<List<Bud>> getBudsByTopArtists();
  Future<List<Bud>> getBudsByTopTracks();
  Future<List<Bud>> getBudsByTopGenres();
  Future<List<Bud>> getBudsByTopAnime();
  Future<List<Bud>> getBudsByTopManga();
  Future<List<Bud>> getBudsByArtist(String artistId);
  Future<List<Bud>> getBudsByTrack(String trackId);
  Future<List<Bud>> getBudsByGenre(String genreId);
  Future<List<Bud>> getBudsByAlbum(String albumId);
  Future<List<Bud>> searchBuds(String query);
}

class BudRemoteDataSourceImpl implements BudRemoteDataSource {
  final http.Client client;
  final String token;

  BudRemoteDataSourceImpl({required this.client, required this.token});

  @override
  Future<List<Bud>> getBudsByLikedArtists() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/liked/artists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by liked artists');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/liked/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by liked tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedGenres() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/liked/genres'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by liked genres');
    }
  }

  @override
  Future<List<Bud>> getBudsByLikedAlbums() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/liked/albums'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by liked albums');
    }
  }

  @override
  Future<List<Bud>> getBudsByPlayedTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/played/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by played tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopArtists() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/top/artists'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by top artists');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopTracks() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/top/tracks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by top tracks');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopGenres() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/top/genres'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by top genres');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopAnime() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/top/anime'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by top anime');
    }
  }

  @override
  Future<List<Bud>> getBudsByTopManga() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/top/manga'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by top manga');
    }
  }

  @override
  Future<List<Bud>> getBudsByArtist(String artistId) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/artist?id=$artistId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by artist');
    }
  }

  @override
  Future<List<Bud>> getBudsByTrack(String trackId) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/track?id=$trackId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by track');
    }
  }

  @override
  Future<List<Bud>> getBudsByGenre(String genreId) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/genre?id=$genreId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by genre');
    }
  }

  @override
  Future<List<Bud>> getBudsByAlbum(String albumId) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/album?id=$albumId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get buds by album');
    }
  }

  @override
  Future<List<Bud>> searchBuds(String query) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bud/search?q=$query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bud.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to search buds');
    }
  }
}
