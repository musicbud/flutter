import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../presentation/screens/connect/connect_services_screen.dart';
import '../presentation/screens/spotify/spotify_control_screen.dart';
import '../presentation/screens/spotify/played_tracks_map_screen.dart';
import '../presentation/screens/profile/artist_details_screen.dart';
import '../presentation/screens/profile/genre_details_screen.dart';
import '../presentation/screens/profile/track_details_screen.dart';
import '../presentation/screens/discover/top_tracks_page.dart';

/// Configuration class for navigation components
class NavigationConfig extends Equatable {
  /// Routes map for the application
  static final Map<String, WidgetBuilder> routes = {
    '/connect-services': (context) => ConnectServicesScreen(),
    '/artist-details': (context) => ArtistDetailsScreen(),
    '/genre-details': (context) => GenreDetailsScreen(),
    '/track-details': (context) => const TrackDetailsScreen(),
    '/played-tracks-map': (context) => const PlayedTracksMapScreen(),
    '/spotify-control': (context) => const SpotifyControlScreen(),
    '/tracks': (context) => const TopTracksPage(),
    '/artists': (context) => const TopTracksPage(), // TODO: Create TopArtistsPage
  };
  const NavigationConfig({
    this.margin,
    this.borderRadius,
    this.selectedColor,
    this.unselectedColor,
    this.elevation,
  });

  /// Margin for navigation components
  final EdgeInsetsGeometry? margin;

  /// Border radius for navigation components
  final BorderRadius? borderRadius;

  /// Color for selected navigation items
  final Color? selectedColor;

  /// Color for unselected navigation items
  final Color? unselectedColor;

  /// Elevation for navigation components
  final double? elevation;

  /// Creates a copy of this NavigationConfig with the given fields replaced
  NavigationConfig copyWith({
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? selectedColor,
    Color? unselectedColor,
    double? elevation,
  }) {
    return NavigationConfig(
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  List<Object?> get props => [
    margin,
    borderRadius,
    selectedColor,
    unselectedColor,
    elevation,
  ];
}