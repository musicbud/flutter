import 'package:musicbud_flutter/models/common_artist.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class CommonTrack {
  final String uid;
  final String name;
  final String spotifyId;
  final String uri;
  final String spotifyUrl;
  final int durationMs;
  final int popularity;
  final String previewUrl;
  final List<CommonImage> images;

  CommonTrack({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.uri,
    required this.spotifyUrl,
    required this.durationMs,
    required this.popularity,
    required this.previewUrl,
    required this.images,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      spotifyId: json['spotify_id'] ?? '',
      uri: json['uri'] ?? '',
      spotifyUrl: json['spotify_url'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      popularity: json['popularity'] ?? 0,
      previewUrl: json['preview_url'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((imageJson) => CommonImage.fromJson(imageJson))
          .toList() ?? [],
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

class TracksResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<CommonTrack> data;
  final String message;
  final int code;
  final bool successful;

  TracksResponse({
    required this.count,
    this.next,
    this.previous,
    required this.data,
    required this.message,
    required this.code,
    required this.successful,
  });

  factory TracksResponse.fromJson(Map<String, dynamic> json) {
    return TracksResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      data: (json['data'] as List<dynamic>)
          .map((trackJson) => CommonTrack.fromJson(trackJson))
          .toList(),
      message: json['message'],
      code: json['code'],
      successful: json['successful'],
    );
  }
}

TracksResponse parseTracksResponse(String jsonString) {
  try {
    final Map<String, dynamic> decodedJson = json.decode(jsonString);
    return TracksResponse.fromJson(decodedJson);
  } catch (e) {
    print('Error parsing tracks response: $e');
    print('Raw JSON: $jsonString');
    rethrow;
  }
}

List<CommonTrack> parseTracks(String jsonString) {
  final Map<String, dynamic> decodedJson = json.decode(jsonString);
  final List<dynamic> tracksJson = decodedJson['data'];
  return tracksJson.map((json) => CommonTrack.fromJson(json)).toList();
}
