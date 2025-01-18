import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../models/categorized_common_items.dart';

// Events
abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopContent extends ContentEvent {}

class LoadLikedContent extends ContentEvent {}

class LoadPlayedTracks extends ContentEvent {}

class LikeItem extends ContentEvent {
  final String type;
  final String id;

  const LikeItem({required this.type, required this.id});

  @override
  List<Object?> get props => [type, id];
}

class UnlikeItem extends ContentEvent {
  final String type;
  final String id;

  const UnlikeItem({required this.type, required this.id});

  @override
  List<Object?> get props => [type, id];
}

class SearchContent extends ContentEvent {
  final String query;
  final String type;

  const SearchContent({required this.query, required this.type});

  @override
  List<Object?> get props => [query, type];
}

// States
abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<CommonTrack> topTracks;
  final List<CommonArtist> topArtists;
  final List<CommonGenre> topGenres;
  final List<CommonAlbum>? likedAlbums;
  final List<CommonTrack>? likedTracks;
  final List<CommonArtist>? likedArtists;
  final List<CommonGenre>? likedGenres;
  final List<CommonTrack>? playedTracks;
  final List<CommonAnime> topAnime;
  final List<CommonManga> topManga;
  final CategorizedCommonItems? categorizedItems;

  const ContentLoaded({
    required this.topTracks,
    required this.topArtists,
    required this.topGenres,
    this.likedAlbums,
    this.likedTracks,
    this.likedArtists,
    this.likedGenres,
    this.playedTracks,
    required this.topAnime,
    required this.topManga,
    this.categorizedItems,
  });

  @override
  List<Object?> get props => [
        topTracks,
        topArtists,
        topGenres,
        likedAlbums,
        likedTracks,
        likedArtists,
        likedGenres,
        playedTracks,
        topAnime,
        topManga,
        categorizedItems,
      ];

  ContentLoaded copyWith({
    List<CommonTrack>? topTracks,
    List<CommonArtist>? topArtists,
    List<CommonGenre>? topGenres,
    List<CommonAlbum>? likedAlbums,
    List<CommonTrack>? likedTracks,
    List<CommonArtist>? likedArtists,
    List<CommonGenre>? likedGenres,
    List<CommonTrack>? playedTracks,
    List<CommonAnime>? topAnime,
    List<CommonManga>? topManga,
    CategorizedCommonItems? categorizedItems,
  }) {
    return ContentLoaded(
      topTracks: topTracks ?? this.topTracks,
      topArtists: topArtists ?? this.topArtists,
      topGenres: topGenres ?? this.topGenres,
      likedAlbums: likedAlbums ?? this.likedAlbums,
      likedTracks: likedTracks ?? this.likedTracks,
      likedArtists: likedArtists ?? this.likedArtists,
      likedGenres: likedGenres ?? this.likedGenres,
      playedTracks: playedTracks ?? this.playedTracks,
      topAnime: topAnime ?? this.topAnime,
      topManga: topManga ?? this.topManga,
      categorizedItems: categorizedItems ?? this.categorizedItems,
    );
  }
}

class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository _contentRepository;

  ContentBloc({required ContentRepository contentRepository})
      : _contentRepository = contentRepository,
        super(ContentInitial()) {
    on<LoadTopContent>(_onLoadTopContent);
    on<LoadLikedContent>(_onLoadLikedContent);
    on<LoadPlayedTracks>(_onLoadPlayedTracks);
    on<LikeItem>(_onLikeItem);
    on<UnlikeItem>(_onUnlikeItem);
    on<SearchContent>(_onSearchContent);
  }

  Future<void> _onLoadTopContent(
    LoadTopContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final topTracks = await _contentRepository.getTopTracks();
      final topArtists = await _contentRepository.getTopArtists();
      final topGenres = await _contentRepository.getTopGenres();
      final topAnime = await _contentRepository.getTopAnime();
      final topManga = await _contentRepository.getTopManga();

      emit(ContentLoaded(
        topTracks: topTracks,
        topArtists: topArtists,
        topGenres: topGenres,
        topAnime: topAnime,
        topManga: topManga,
      ));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadLikedContent(
    LoadLikedContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final likedTracks = await _contentRepository.getLikedTracks();
      final likedArtists = await _contentRepository.getLikedArtists();
      final likedAlbums = await _contentRepository.getLikedAlbums();
      final likedGenres = await _contentRepository.getLikedGenres();

      if (state is ContentLoaded) {
        emit((state as ContentLoaded).copyWith(
          likedTracks: likedTracks,
          likedArtists: likedArtists,
          likedAlbums: likedAlbums,
          likedGenres: likedGenres,
        ));
      } else {
        emit(ContentLoaded(
          topTracks: [],
          topArtists: [],
          topGenres: [],
          topAnime: [],
          topManga: [],
          likedTracks: likedTracks,
          likedArtists: likedArtists,
          likedAlbums: likedAlbums,
          likedGenres: likedGenres,
        ));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLoadPlayedTracks(
    LoadPlayedTracks event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      final playedTracks = await _contentRepository.getPlayedTracks();

      if (state is ContentLoaded) {
        emit((state as ContentLoaded).copyWith(playedTracks: playedTracks));
      } else {
        emit(ContentLoaded(
          playedTracks: playedTracks,
          topTracks: [],
          topArtists: [],
          topGenres: [],
          topAnime: [],
          topManga: [],
        ));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onLikeItem(
    LikeItem event,
    Emitter<ContentState> emit,
  ) async {
    try {
      bool success = false;
      switch (event.type) {
        case 'track':
          success = await _contentRepository.likeTrack(event.id);
          break;
        case 'artist':
          success = await _contentRepository.likeArtist(event.id);
          break;
        case 'album':
          success = await _contentRepository.likeAlbum(event.id);
          break;
        case 'genre':
          success = await _contentRepository.likeGenre(event.id);
          break;
        case 'anime':
          success = await _contentRepository.likeAnime(event.id);
          break;
        case 'manga':
          success = await _contentRepository.likeManga(event.id);
          break;
      }

      if (!success) {
        emit(const ContentError('Failed to like item'));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onUnlikeItem(
    UnlikeItem event,
    Emitter<ContentState> emit,
  ) async {
    try {
      bool success = false;
      switch (event.type) {
        case 'track':
          success = await _contentRepository.unlikeTrack(event.id);
          break;
        case 'artist':
          success = await _contentRepository.unlikeArtist(event.id);
          break;
        case 'album':
          success = await _contentRepository.unlikeAlbum(event.id);
          break;
        case 'genre':
          success = await _contentRepository.unlikeGenre(event.id);
          break;
        case 'anime':
          success = await _contentRepository.unlikeAnime(event.id);
          break;
        case 'manga':
          success = await _contentRepository.unlikeManga(event.id);
          break;
      }

      if (!success) {
        emit(const ContentError('Failed to unlike item'));
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> _onSearchContent(
    SearchContent event,
    Emitter<ContentState> emit,
  ) async {
    try {
      emit(ContentLoading());
      switch (event.type) {
        case 'track':
          final tracks = await _contentRepository.searchTracks(event.query);
          emit(ContentLoaded(
            topTracks: tracks,
            topArtists: [],
            topGenres: [],
            topAnime: [],
            topManga: [],
          ));
          break;
        case 'artist':
          final artists = await _contentRepository.searchArtists(event.query);
          emit(ContentLoaded(
            topArtists: artists,
            topTracks: [],
            topGenres: [],
            topAnime: [],
            topManga: [],
          ));
          break;
        case 'album':
          final albums = await _contentRepository.searchAlbums(event.query);
          emit(ContentLoaded(
            likedAlbums: albums,
            topTracks: [],
            topArtists: [],
            topGenres: [],
            topAnime: [],
            topManga: [],
          ));
          break;
        case 'genre':
          final genres = await _contentRepository.searchGenres(event.query);
          emit(ContentLoaded(
            topGenres: genres,
            topTracks: [],
            topArtists: [],
            topAnime: [],
            topManga: [],
          ));
          break;
        case 'anime':
          final anime = await _contentRepository.searchAnime(event.query);
          emit(ContentLoaded(
            topAnime: anime,
            topTracks: [],
            topArtists: [],
            topGenres: [],
            topManga: [],
          ));
          break;
        case 'manga':
          final manga = await _contentRepository.searchManga(event.query);
          emit(ContentLoaded(
            topManga: manga,
            topTracks: [],
            topArtists: [],
            topGenres: [],
            topAnime: [],
          ));
          break;
      }
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}
