import 'package:equatable/equatable.dart';
import '../../models/discover_item.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  final List<DiscoverItem> items;
  final List<String> categories;
  final String selectedCategory;
  final bool isRefreshing;

  const DiscoverLoaded({
    required this.items,
    required this.categories,
    required this.selectedCategory,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [items, categories, selectedCategory, isRefreshing];

  DiscoverLoaded copyWith({
    List<DiscoverItem>? items,
    List<String>? categories,
    String? selectedCategory,
    bool? isRefreshing,
  }) {
    return DiscoverLoaded(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError(this.message);

  @override
  List<Object?> get props => [message];
}

// Content-specific loading states
class TopTracksLoading extends DiscoverState {
  const TopTracksLoading();
}

class TopArtistsLoading extends DiscoverState {
  const TopArtistsLoading();
}

class TopGenresLoading extends DiscoverState {
  const TopGenresLoading();
}

class TopAnimeLoading extends DiscoverState {
  const TopAnimeLoading();
}

class TopMangaLoading extends DiscoverState {
  const TopMangaLoading();
}

class LikedTracksLoading extends DiscoverState {
  const LikedTracksLoading();
}

class LikedArtistsLoading extends DiscoverState {
  const LikedArtistsLoading();
}

class LikedGenresLoading extends DiscoverState {
  const LikedGenresLoading();
}

class LikedAlbumsLoading extends DiscoverState {
  const LikedAlbumsLoading();
}

class PlayedTracksLoading extends DiscoverState {
  const PlayedTracksLoading();
}

// Content-specific loaded states
class TopTracksLoaded extends DiscoverState {
  final List<Track> tracks;

  const TopTracksLoaded(this.tracks);

  @override
  List<Object?> get props => [tracks];
}

class TopArtistsLoaded extends DiscoverState {
  final List<Artist> artists;

  const TopArtistsLoaded(this.artists);

  @override
  List<Object?> get props => [artists];
}

class TopGenresLoaded extends DiscoverState {
  final List<Genre> genres;

  const TopGenresLoaded(this.genres);

  @override
  List<Object?> get props => [genres];
}

class TopAnimeLoaded extends DiscoverState {
  final List<CommonAnime> anime;

  const TopAnimeLoaded(this.anime);

  @override
  List<Object?> get props => [anime];
}

class TopMangaLoaded extends DiscoverState {
  final List<CommonManga> manga;

  const TopMangaLoaded(this.manga);

  @override
  List<Object?> get props => [manga];
}

class LikedTracksLoaded extends DiscoverState {
  final List<Track> tracks;

  const LikedTracksLoaded(this.tracks);

  @override
  List<Object?> get props => [tracks];
}

class LikedArtistsLoaded extends DiscoverState {
  final List<Artist> artists;

  const LikedArtistsLoaded(this.artists);

  @override
  List<Object?> get props => [artists];
}

class LikedGenresLoaded extends DiscoverState {
  final List<Genre> genres;

  const LikedGenresLoaded(this.genres);

  @override
  List<Object?> get props => [genres];
}

class LikedAlbumsLoaded extends DiscoverState {
  final List<Album> albums;

  const LikedAlbumsLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

class PlayedTracksLoaded extends DiscoverState {
  final List<Track> tracks;

  const PlayedTracksLoaded(this.tracks);

  @override
  List<Object?> get props => [tracks];
}

// Content-specific error states
class TopTracksError extends DiscoverState {
  final String message;

  const TopTracksError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopArtistsError extends DiscoverState {
  final String message;

  const TopArtistsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopGenresError extends DiscoverState {
  final String message;

  const TopGenresError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopAnimeError extends DiscoverState {
  final String message;

  const TopAnimeError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopMangaError extends DiscoverState {
  final String message;

  const TopMangaError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikedTracksError extends DiscoverState {
  final String message;

  const LikedTracksError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikedArtistsError extends DiscoverState {
  final String message;

  const LikedArtistsError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikedGenresError extends DiscoverState {
  final String message;

  const LikedGenresError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikedAlbumsError extends DiscoverState {
  final String message;

  const LikedAlbumsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlayedTracksError extends DiscoverState {
  final String message;

  const PlayedTracksError(this.message);

  @override
  List<Object?> get props => [message];
}

// Trending content states
class TrendingTracksLoading extends DiscoverState {
  const TrendingTracksLoading();
}

class TrendingTracksLoaded extends DiscoverState {
  final List<Map<String, dynamic>> tracks;

  const TrendingTracksLoaded(this.tracks);

  @override
  List<Object?> get props => [tracks];
}

class TrendingTracksError extends DiscoverState {
  final String message;

  const TrendingTracksError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeaturedArtistsLoading extends DiscoverState {
  const FeaturedArtistsLoading();
}

class FeaturedArtistsLoaded extends DiscoverState {
  final List<Map<String, dynamic>> artists;

  const FeaturedArtistsLoaded(this.artists);

  @override
  List<Object?> get props => [artists];
}

class FeaturedArtistsError extends DiscoverState {
  final String message;

  const FeaturedArtistsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewReleasesLoading extends DiscoverState {
  const NewReleasesLoading();
}

class NewReleasesLoaded extends DiscoverState {
  final List<Map<String, dynamic>> releases;

  const NewReleasesLoaded(this.releases);

  @override
  List<Object?> get props => [releases];
}

class NewReleasesError extends DiscoverState {
  final String message;

  const NewReleasesError(this.message);

  @override
  List<Object?> get props => [message];
}
