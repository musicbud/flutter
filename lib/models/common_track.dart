import 'package:musicbud_flutter/models/common_artist.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class CommonTrack {
  final String? uid;
  final String? name;
  final String? spotifyId;
  final String? uri;
  final String? spotifyUrl;
  final String? href;
  final int? durationMs;
  final int? popularity;
  final String? previewUrl;
  final int? trackNumber;
  final int? discNumber;
  final bool explicit;
  final String? type;
  final bool isLocal;
  final String? isrc;
  final int? elementIdProperty;
  final List<Image> images;

  CommonTrack({
    this.uid,
    this.name,
    this.spotifyId,
    this.uri,
    this.spotifyUrl,
    this.href,
    this.durationMs,
    this.popularity,
    this.previewUrl,
    this.trackNumber,
    this.discNumber,
    this.explicit = false,
    this.type,
    this.isLocal = false,
    this.isrc,
    this.elementIdProperty,
    this.images = const [],
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    return CommonTrack(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      spotifyId: json['spotify_id'] as String?,
      uri: json['uri'] as String?,
      spotifyUrl: json['spotify_url'] as String?,
      href: json['href'] as String?,
      durationMs: json['duration_ms'] as int?,
      popularity: json['popularity'] as int?,
      previewUrl: json['preview_url'] as String?,
      trackNumber: json['track_number'] as int?,
      discNumber: json['disc_number'] as int?,
      explicit: json['explicit'] as bool? ?? false,
      type: json['type'] as String?,
      isLocal: json['is_local'] as bool? ?? false,
      isrc: json['isrc'] as String?,
      elementIdProperty: json['element_id_property'] != null
          ? int.tryParse(json['element_id_property'].toString())
          : null,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class Image {
  final String uid;
  final String url;
  final int height;
  final int width;

  Image({
    required this.uid,
    required this.url,
    required this.height,
    required this.width,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      uid: json['uid'],
      url: json['url'],
      height: json['height'],
      width: json['width'],
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
