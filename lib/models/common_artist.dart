import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:musicbud_flutter/models/common_track.dart' as common_track;

class CommonArtist {
  final String uid;
  final String name;
  final String spotifyId;
  final String spotifyUrl;
  final String href;
  final int popularity;
  final String type;
  final String uri;
  final int followers;
  final List<common_track.Image> images;
  final List<String> genres;
  final int? elementIdProperty;

  CommonArtist({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.spotifyUrl,
    required this.href,
    required this.popularity,
    required this.type,
    required this.uri,
    required this.followers,
    required this.images,
    required this.genres,
    this.elementIdProperty,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    return CommonArtist(
      uid: json['uid'],
      name: json['name'],
      spotifyId: json['spotify_id'],
      spotifyUrl: json['spotify_url'],
      href: json['href'],
      popularity: json['popularity'],
      type: json['type'],
      uri: json['uri'],
      followers: json['followers'],
      images: (json['images'] as List).map((image) => common_track.Image.fromJson(image)).toList(),
      genres: (json['genres'] as List).map((genre) => genre as String).toList(),
      elementIdProperty: json['element_id_property'] != null
          ? int.tryParse(json['element_id_property'].toString())
          : null,
    );
  }
}

class CommonImage {
  final String uid;
  final String url;
  final int height;
  final int width;

  CommonImage({
    required this.uid,
    required this.url,
    required this.height,
    required this.width,
  });

  factory CommonImage.fromJson(Map<String, dynamic> json) {
    return CommonImage(
      uid: json['uid'] ?? '',
      url: json['url'] ?? '',
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
    );
  }
}

class ArtistImage {
  final String uid;
  final String url;
  final int height;
  final int width;

  ArtistImage({
    required this.uid,
    required this.url,
    required this.height,
    required this.width,
  });

  factory ArtistImage.fromJson(Map<String, dynamic> json) {
    return ArtistImage(
      uid: json['uid']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      height: int.tryParse(json['height']?.toString() ?? '0') ?? 0,
      width: int.tryParse(json['width']?.toString() ?? '0') ?? 0,
    );
  }
}

class ArtworkImage {
  final String uid;
  final String url;
  final int height;
  final int width;

  ArtworkImage({
    required this.uid,
    required this.url,
    required this.height,
    required this.width,
  });

  factory ArtworkImage.fromJson(Map<String, dynamic> json) {
    return ArtworkImage(
      uid: json['uid'] ?? '',
      url: json['url'] ?? '',
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
    );
  }
}

class ArtistsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<CommonArtist> data;
  final String message;
  final int code;
  final bool successful;

  ArtistsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.data,
    required this.message,
    required this.code,
    required this.successful,
  });

  factory ArtistsResponse.fromJson(Map<String, dynamic> json) {
    return ArtistsResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      data: (json['data'] as List<dynamic>)
          .map((artistJson) => CommonArtist.fromJson(artistJson))
          .toList(),
      message: json['message'],
      code: json['code'],
      successful: json['successful'],
    );
  }
}

ArtistsResponse parseArtistsResponse(String jsonString) {
  final Map<String, dynamic> decodedJson = json.decode(jsonString);
  return ArtistsResponse.fromJson(decodedJson);
}

List<CommonArtist> parseArtists(String jsonString) {
  try {
    final Map<String, dynamic> decodedJson = json.decode(jsonString);
    final List<dynamic> artistsJson = decodedJson['data'];
    return artistsJson.map((json) {
      try {
        return CommonArtist.fromJson(json as Map<String, dynamic>);
      } catch (e, stackTrace) {
        developer.log('Error parsing individual artist: $e\n$stackTrace');
        developer.log('Problematic JSON: ${json.toString()}');
        return null;
      }
    }).whereType<CommonArtist>().toList();
  } catch (e, stackTrace) {
    developer.log('Error parsing artists: $e\n$stackTrace');
    developer.log('Raw JSON: $jsonString');
    return [];
  }
}
