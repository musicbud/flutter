import 'package:equatable/equatable.dart';
import 'common_artist.dart';
import 'common_track.dart';
import 'common_genre.dart';

/// A model class representing a bud's profile with common content data
class BudProfile extends Equatable {
  final String message;
  final BudProfileData data;

  const BudProfile({
    required this.message,
    required this.data,
  });

  /// Creates a [BudProfile] from a JSON map
  factory BudProfile.fromJson(Map<String, dynamic> json) {
    return BudProfile(
      message: json['message'] as String,
      data: BudProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts this [BudProfile] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }

  /// Creates a copy of this [BudProfile] with the given fields replaced with new values
  BudProfile copyWith({
    String? message,
    BudProfileData? data,
  }) {
    return BudProfile(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, data];
}

/// A model class representing the data portion of a bud profile response
class BudProfileData extends Equatable {
  final List<CommonArtist> commonArtistsData;
  final List<CommonTrack> commonTracksData;
  final List<CommonGenre> commonGenresData;

  const BudProfileData({
    required this.commonArtistsData,
    required this.commonTracksData,
    required this.commonGenresData,
  });

  /// Creates a [BudProfileData] from a JSON map
  factory BudProfileData.fromJson(Map<String, dynamic> json) {
    return BudProfileData(
      commonArtistsData: (json['common_artists_data'] as List<dynamic>?)
              ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      commonTracksData: (json['common_tracks_data'] as List<dynamic>?)
              ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      commonGenresData: (json['common_genres_data'] as List<dynamic>?)
              ?.map((e) => CommonGenre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts this [BudProfileData] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'common_artists_data': commonArtistsData.map((e) => e.toJson()).toList(),
      'common_tracks_data': commonTracksData.map((e) => e.toJson()).toList(),
      'common_genres_data': commonGenresData.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of this [BudProfileData] with the given fields replaced with new values
  BudProfileData copyWith({
    List<CommonArtist>? commonArtistsData,
    List<CommonTrack>? commonTracksData,
    List<CommonGenre>? commonGenresData,
  }) {
    return BudProfileData(
      commonArtistsData: commonArtistsData ?? this.commonArtistsData,
      commonTracksData: commonTracksData ?? this.commonTracksData,
      commonGenresData: commonGenresData ?? this.commonGenresData,
    );
  }

  @override
  List<Object?> get props => [commonArtistsData, commonTracksData, commonGenresData];
}