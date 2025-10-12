class SpotifyCommonTrack {
  final String? uid;
  final String? id;
  final String name;
  final String? spotifyId;
  final String? uri;
  final String? spotifyUrl;
  final String? href;
  final int? durationMs;
  final int? popularity;
  final String? previewUrl;
  final int? trackNumber;
  final int? discNumber;
  final bool? explicit;
  final String? type;
  final bool? isLocal;
  final String? isrc;
  final String? elementIdProperty;
  final List<CommonImage> images;
  final String? artistName;
  final String? albumName;
  final double? latitude;
  final double? longitude;

  SpotifyCommonTrack({
    required this.uid,
    required this.id,
    required this.name,
    this.spotifyId,
    this.uri,
    this.spotifyUrl,
    this.href,
    this.durationMs,
    this.popularity,
    this.previewUrl,
    this.trackNumber,
    this.discNumber,
    this.explicit,
    this.type,
    this.isLocal,
    this.isrc,
    this.elementIdProperty,
    this.images = const [],
    this.artistName,
    this.albumName,
    this.latitude,
    this.longitude,
  });

  factory SpotifyCommonTrack.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('track') && json.containsKey('location')) {
      // Handle the new structure
      final trackData = json['track'] as Map<String, dynamic>;
      final locationData = json['location'] as Map<String, dynamic>;
      return SpotifyCommonTrack(
        uid: trackData['id'] ?? '',
        id: trackData['id'] ?? '',
        name: trackData['name'] ?? '',
        latitude: locationData['latitude'],
        longitude: locationData['longitude'],
      );
    } else {
      // Handle the old structure
      return SpotifyCommonTrack(
        uid: json['uid'] ?? '',
        id: json['id'] ?? json['spotify_id'] ?? '',
        name: json['name'] ?? '',
        spotifyId: json['spotify_id'],
        uri: json['uri'],
        spotifyUrl: json['spotify_url'],
        href: json['href'],
        durationMs: json['duration_ms'],
        popularity: json['popularity'],
        previewUrl: json['preview_url'],
        trackNumber: json['track_number'],
        discNumber: json['disc_number'],
        explicit: json['explicit'],
        type: json['type'],
        isLocal: json['is_local'],
        isrc: json['isrc'],
        elementIdProperty: json['element_id_property']?.toString(),
        images: (json['images'] as List<dynamic>?)
            ?.map((imageJson) => CommonImage.fromJson(imageJson))
            .toList() ?? [],
        artistName: json['artist_name'],
        albumName: json['album_name'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'spotify_id': spotifyId,
      'uri': uri,
      'spotify_url': spotifyUrl,
      'href': href,
      'duration_ms': durationMs,
      'popularity': popularity,
      'preview_url': previewUrl,
      'track_number': trackNumber,
      'disc_number': discNumber,
      'explicit': explicit,
      'type': type,
      'is_local': isLocal,
      'isrc': isrc,
      'element_id_property': elementIdProperty,
      'images': images.map((image) => image.toJson()).toList(),
      'artist_name': artistName,
      'album_name': albumName,
      'latitude': latitude,
      'longitude': longitude,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'url': url,
      'height': height,
      'width': width,
    };
  }
}