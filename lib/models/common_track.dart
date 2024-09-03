import 'package:musicbud_flutter/models/common_artist.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class CommonTrack {
  final String uid;
  final String name;
  final String spotifyId;
  final String uri;
  final String spotifyUrl;
  final String href;
  final int durationMs;
  final int popularity;
  final String? previewUrl;
  final int trackNumber;
  final int discNumber;
  final bool explicit;
  final String type;
  final bool? isLocal;
  final String? isrc;
  final String? elementIdProperty;
  final List<TrackImage> images;
  final List<CommonArtist> artists;
  final double? similarityScore;

  CommonTrack({
    required this.uid,
    required this.name,
    required this.spotifyId,
    required this.uri,
    required this.spotifyUrl,
    required this.href,
    required this.durationMs,
    required this.popularity,
    this.previewUrl,
    required this.trackNumber,
    required this.discNumber,
    required this.explicit,
    required this.type,
    this.isLocal,
    this.isrc,
    this.elementIdProperty,
    required this.images,
    required this.artists,
    this.similarityScore,
  });

  factory CommonTrack.fromJson(Map<String, dynamic> json) {
    try {
      return CommonTrack(
        uid: json['uid'] as String? ?? '',
        name: json['name'] as String? ?? '',
        spotifyId: json['spotify_id'] as String? ?? '',
        uri: json['uri'] as String? ?? '',
        spotifyUrl: json['spotify_url'] as String? ?? '',
        href: json['href'] as String? ?? '',
        durationMs: json['duration_ms'] as int? ?? 0,
        popularity: json['popularity'] as int? ?? 0,
        previewUrl: json['preview_url'] as String?,
        trackNumber: json['track_number'] as int? ?? 0,
        discNumber: json['disc_number'] as int? ?? 0,
        explicit: json['explicit'] as bool? ?? false,
        type: json['type'] as String? ?? '',
        isLocal: json['is_local'] as bool?,
        isrc: json['isrc'] as String?,
        elementIdProperty: json['element_id_property'] as String?,
        images: (json['images'] as List<dynamic>?)
                ?.map((image) => TrackImage.fromJson(image as Map<String, dynamic>))
                .toList() ??
            [],
        artists: (json['artists'] as List<dynamic>?)
                ?.map((artist) => CommonArtist.fromJson(artist as Map<String, dynamic>))
                .toList() ??
            [],
        similarityScore: json['similarity_score'] != null
            ? (json['similarity_score'] as num).toDouble()
            : null,
      );
    } catch (e, stackTrace) {
      developer.log('Error parsing CommonTrack: $e\n$stackTrace');
      developer.log('Problematic JSON: $json');
      rethrow;
    }
  }
}

class TrackImage {
  final String uid;
  final String url;
  final int height;
  final int width;

  TrackImage({
    required this.uid,
    required this.url,
    required this.height,
    required this.width,
  });

  factory TrackImage.fromJson(Map<String, dynamic> json) {
    return TrackImage(
      uid: json['uid'] as String? ?? '',
      url: json['url'] as String? ?? '',
      height: json['height'] as int? ?? 0,
      width: json['width'] as int? ?? 0,
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
