import 'package:equatable/equatable.dart';
import 'common_track.dart';
import 'common_artist.dart';
import 'common_genre.dart';
import 'common_album.dart';

/// A model class representing the result of a bud search operation
class BudSearchResult extends Equatable {
  final String message;
  final int code;
  final bool successful;
  final BudSearchData data;

  const BudSearchResult({
    required this.message,
    required this.code,
    required this.successful,
    required this.data,
  });

  /// Creates a [BudSearchResult] from a JSON map
  factory BudSearchResult.fromJson(Map<String, dynamic> json) {
    return BudSearchResult(
      message: json['message'] as String,
      code: json['code'] as int,
      successful: json['successful'] as bool,
      data: BudSearchData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts this [BudSearchResult] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'successful': successful,
      'data': data.toJson(),
    };
  }

  /// Creates a copy of this [BudSearchResult] with the given fields replaced with new values
  BudSearchResult copyWith({
    String? message,
    int? code,
    bool? successful,
    BudSearchData? data,
  }) {
    return BudSearchResult(
      message: message ?? this.message,
      code: code ?? this.code,
      successful: successful ?? this.successful,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, code, successful, data];
}

/// A model class representing the data portion of a bud search result
class BudSearchData extends Equatable {
  final List<BudSearchItem> buds;
  final int? totalCommonTracksCount;
  final int? totalCommonArtistsCount;
  final int? totalCommonGenresCount;
  final int? totalCommonAlbumsCount;

  const BudSearchData({
    required this.buds,
    this.totalCommonTracksCount,
    this.totalCommonArtistsCount,
    this.totalCommonGenresCount,
    this.totalCommonAlbumsCount,
  });

  /// Creates a [BudSearchData] from a JSON map
  factory BudSearchData.fromJson(Map<String, dynamic> json) {
    return BudSearchData(
      buds: (json['buds'] as List<dynamic>?)
              ?.map((e) => BudSearchItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCommonTracksCount: json['totalCommonTracksCount'] as int?,
      totalCommonArtistsCount: json['totalCommonArtistsCount'] as int?,
      totalCommonGenresCount: json['totalCommonGenresCount'] as int?,
      totalCommonAlbumsCount: json['totalCommonAlbumsCount'] as int?,
    );
  }

  /// Converts this [BudSearchData] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'buds': buds.map((e) => e.toJson()).toList(),
      if (totalCommonTracksCount != null) 'totalCommonTracksCount': totalCommonTracksCount,
      if (totalCommonArtistsCount != null) 'totalCommonArtistsCount': totalCommonArtistsCount,
      if (totalCommonGenresCount != null) 'totalCommonGenresCount': totalCommonGenresCount,
      if (totalCommonAlbumsCount != null) 'totalCommonAlbumsCount': totalCommonAlbumsCount,
    };
  }

  /// Creates a copy of this [BudSearchData] with the given fields replaced with new values
  BudSearchData copyWith({
    List<BudSearchItem>? buds,
    int? totalCommonTracksCount,
    int? totalCommonArtistsCount,
    int? totalCommonGenresCount,
    int? totalCommonAlbumsCount,
  }) {
    return BudSearchData(
      buds: buds ?? this.buds,
      totalCommonTracksCount: totalCommonTracksCount ?? this.totalCommonTracksCount,
      totalCommonArtistsCount: totalCommonArtistsCount ?? this.totalCommonArtistsCount,
      totalCommonGenresCount: totalCommonGenresCount ?? this.totalCommonGenresCount,
      totalCommonAlbumsCount: totalCommonAlbumsCount ?? this.totalCommonAlbumsCount,
    );
  }

  @override
  List<Object?> get props => [
        buds,
        totalCommonTracksCount,
        totalCommonArtistsCount,
        totalCommonGenresCount,
        totalCommonAlbumsCount,
      ];
}

/// A model class representing an individual bud in search results
class BudSearchItem extends Equatable {
  final String uid;
  final String? email;
  final String? country;
  final String displayName;
  final String? bio;
  final bool isActive;
  final bool? isAuthenticated;
  final int? commonTracksCount;
  final int? commonArtistsCount;
  final int? commonGenresCount;
  final int? commonAlbumsCount;
  final List<CommonTrack>? commonTracks;
  final List<CommonArtist>? commonArtists;
  final List<CommonGenre>? commonGenres;
  final List<CommonAlbum>? commonAlbums;

  const BudSearchItem({
    required this.uid,
    this.email,
    this.country,
    required this.displayName,
    this.bio,
    required this.isActive,
    this.isAuthenticated,
    this.commonTracksCount,
    this.commonArtistsCount,
    this.commonGenresCount,
    this.commonAlbumsCount,
    this.commonTracks,
    this.commonArtists,
    this.commonGenres,
    this.commonAlbums,
  });

  /// Creates a [BudSearchItem] from a JSON map
  factory BudSearchItem.fromJson(Map<String, dynamic> json) {
    return BudSearchItem(
      uid: json['uid'] as String? ?? json['bud_uid'] as String? ?? '',
      email: json['email'] as String?,
      country: json['country'] as String?,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool,
      isAuthenticated: json['is_authenticated'] as bool?,
      commonTracksCount: json['commonTracksCount'] as int? ?? json['common_tracks_count'] as int?,
      commonArtistsCount: json['commonArtistsCount'] as int? ?? json['common_artists_count'] as int?,
      commonGenresCount: json['commonGenresCount'] as int? ?? json['common_genres_count'] as int?,
      commonAlbumsCount: json['commonAlbumsCount'] as int? ?? json['common_albums_count'] as int?,
      commonTracks: (json['commonTracks'] as List<dynamic>?)
          ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      commonArtists: (json['commonArtists'] as List<dynamic>?)
          ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      commonGenres: (json['commonGenres'] as List<dynamic>?)
          ?.map((e) => CommonGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      commonAlbums: (json['commonAlbums'] as List<dynamic>?)
          ?.map((e) => CommonAlbum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this [BudSearchItem] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      if (email != null) 'email': email,
      if (country != null) 'country': country,
      'display_name': displayName,
      if (bio != null) 'bio': bio,
      'is_active': isActive,
      if (isAuthenticated != null) 'is_authenticated': isAuthenticated,
      if (commonTracksCount != null) 'commonTracksCount': commonTracksCount,
      if (commonArtistsCount != null) 'commonArtistsCount': commonArtistsCount,
      if (commonGenresCount != null) 'commonGenresCount': commonGenresCount,
      if (commonAlbumsCount != null) 'commonAlbumsCount': commonAlbumsCount,
      if (commonTracks != null) 'commonTracks': commonTracks!.map((e) => e.toJson()).toList(),
      if (commonArtists != null) 'commonArtists': commonArtists!.map((e) => e.toJson()).toList(),
      if (commonGenres != null) 'commonGenres': commonGenres!.map((e) => e.toJson()).toList(),
      if (commonAlbums != null) 'commonAlbums': commonAlbums!.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of this [BudSearchItem] with the given fields replaced with new values
  BudSearchItem copyWith({
    String? uid,
    String? email,
    String? country,
    String? displayName,
    String? bio,
    bool? isActive,
    bool? isAuthenticated,
    int? commonTracksCount,
    int? commonArtistsCount,
    int? commonGenresCount,
    int? commonAlbumsCount,
    List<CommonTrack>? commonTracks,
    List<CommonArtist>? commonArtists,
    List<CommonGenre>? commonGenres,
    List<CommonAlbum>? commonAlbums,
  }) {
    return BudSearchItem(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      country: country ?? this.country,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      commonTracksCount: commonTracksCount ?? this.commonTracksCount,
      commonArtistsCount: commonArtistsCount ?? this.commonArtistsCount,
      commonGenresCount: commonGenresCount ?? this.commonGenresCount,
      commonAlbumsCount: commonAlbumsCount ?? this.commonAlbumsCount,
      commonTracks: commonTracks ?? this.commonTracks,
      commonArtists: commonArtists ?? this.commonArtists,
      commonGenres: commonGenres ?? this.commonGenres,
      commonAlbums: commonAlbums ?? this.commonAlbums,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        country,
        displayName,
        bio,
        isActive,
        isAuthenticated,
        commonTracksCount,
        commonArtistsCount,
        commonGenresCount,
        commonAlbumsCount,
        commonTracks,
        commonArtists,
        commonGenres,
        commonAlbums,
      ];
}