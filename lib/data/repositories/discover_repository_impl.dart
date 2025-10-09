import '../../domain/repositories/discover_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/data_sources/remote/content_remote_data_source.dart';
import '../../models/discover_item.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';
import '../../models/user_profile.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final UserProfileRepository _userProfileRepository;
  final ContentRemoteDataSource _contentRemoteDataSource;

  DiscoverRepositoryImpl({
    required UserProfileRepository userProfileRepository,
    required ContentRemoteDataSource contentRemoteDataSource,
  }) : _userProfileRepository = userProfileRepository,
       _contentRemoteDataSource = contentRemoteDataSource;

  @override
  Future<List<String>> getCategories() async {
    // TODO: Implement categories fetching
    // For now, return a default list
    return ['top', 'liked', 'played'];
  }

  @override
  Future<List<DiscoverItem>> getDiscoverItems(String category) async {
    // TODO: Implement discover items fetching based on category
    // For now, return empty list
    return [];
  }

  @override
  Future<void> trackInteraction({
    required String itemId,
    required String type,
    required String action,
  }) async {
    // TODO: Implement interaction tracking
    // For now, do nothing
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await _userProfileRepository.getMyProfile();
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<void> setProfile(UserProfileUpdateRequest profile) async {
    try {
      await _userProfileRepository.updateProfile(profile);
    } catch (e) {
      throw Exception('Failed to set profile: $e');
    }
  }

  @override
  Future<void> updateLikes(Map<String, dynamic> likes) async {
    try {
      await _userProfileRepository.updateLikes(likes);
    } catch (e) {
      throw Exception('Failed to update likes: $e');
    }
  }

  @override
  Future<List<Track>> getTopTracks() async {
    try {
      final data = await _userProfileRepository.getMyTopContent('tracks');
      return data.map((item) => Track.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get top tracks: $e');
    }
  }

  @override
  Future<List<Artist>> getTopArtists() async {
    try {
      final data = await _userProfileRepository.getMyTopContent('artists');
      return data.map((item) => Artist.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get top artists: $e');
    }
  }

  @override
  Future<List<Genre>> getTopGenres() async {
    try {
      final data = await _userProfileRepository.getMyTopContent('genres');
      return data.map((item) => Genre.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get top genres: $e');
    }
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    try {
      final data = await _userProfileRepository.getMyTopContent('anime');
      return data.map((item) => CommonAnime.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get top anime: $e');
    }
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    try {
      final data = await _userProfileRepository.getMyTopContent('manga');
      return data.map((item) => CommonManga.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get top manga: $e');
    }
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    try {
      final data = await _userProfileRepository.getMyLikedContent('tracks');
      return data.map((item) => Track.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get liked tracks: $e');
    }
  }

  @override
  Future<List<Artist>> getLikedArtists() async {
    try {
      final data = await _userProfileRepository.getMyLikedContent('artists');
      return data.map((item) => Artist.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get liked artists: $e');
    }
  }

  @override
  Future<List<Genre>> getLikedGenres() async {
    try {
      final data = await _userProfileRepository.getMyLikedContent('genres');
      return data.map((item) => Genre.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get liked genres: $e');
    }
  }

  @override
  Future<List<Album>> getLikedAlbums() async {
    try {
      final data = await _userProfileRepository.getMyLikedContent('albums');
      return data.map((item) => Album.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get liked albums: $e');
    }
  }

  @override
  Future<List<Track>> getPlayedTracks() async {
    try {
      final data = await _userProfileRepository.getMyPlayedTracks();
      return data.map((item) => Track.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to get played tracks: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedArtists() async {
    try {
      return await _contentRemoteDataSource.getFeaturedArtists();
    } catch (e) {
      throw Exception('Failed to get featured artists: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTrendingTracks() async {
    try {
      return await _contentRemoteDataSource.getTrendingTracks();
    } catch (e) {
      throw Exception('Failed to get trending tracks: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNewReleases() async {
    try {
      return await _contentRemoteDataSource.getNewReleases();
    } catch (e) {
      throw Exception('Failed to get new releases: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDiscoverActions() async {
    try {
      return await _contentRemoteDataSource.getDiscoverActions();
    } catch (e) {
      throw Exception('Failed to get discover actions: $e');
    }
  }

  @override
  Future<List<String>> getDiscoverCategories() async {
    try {
      return await _contentRemoteDataSource.getDiscoverCategories();
    } catch (e) {
      throw Exception('Failed to get discover categories: $e');
    }
  }
}