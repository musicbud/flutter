import 'dart:convert';
import 'dart:developer' as developer;

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
  final List<ArtworkImage> images;
  final List<String> genres;
  final double? similarityScore;

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
    this.similarityScore,
  });

  factory CommonArtist.fromJson(Map<String, dynamic> json) {
    try {
      return CommonArtist(
        uid: json['uid']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        spotifyId: json['spotify_id']?.toString() ?? '',
        spotifyUrl: json['spotify_url']?.toString() ?? '',
        href: json['href']?.toString() ?? '',
        popularity: int.tryParse(json['popularity']?.toString() ?? '0') ?? 0,
        type: json['type']?.toString() ?? '',
        uri: json['uri']?.toString() ?? '',
        followers: int.tryParse(json['followers']?.toString() ?? '0') ?? 0,
        images: (json['images'] as List<dynamic>?)
                ?.map((image) => ArtworkImage.fromJson(image as Map<String, dynamic>))
                .toList() ??
            [],
        genres: (json['genres'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        similarityScore: json['similarity_score'] != null
            ? double.tryParse(json['similarity_score'].toString())
            : null,
      );
    } catch (e, stackTrace) {
      developer.log('Error parsing CommonArtist: $e\n$stackTrace');
      developer.log('Problematic JSON: $json');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'CommonArtist(uid: $uid, name: $name, spotifyId: $spotifyId)';
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
      uid: json['uid']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      height: int.tryParse(json['height']?.toString() ?? '0') ?? 0,
      width: int.tryParse(json['width']?.toString() ?? '0') ?? 0,
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
