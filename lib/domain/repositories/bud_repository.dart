import '../../models/bud.dart';

abstract class BudRepository {
  // By liked items
  Future<List<Bud>> getBudsByLikedArtists();
  Future<List<Bud>> getBudsByLikedTracks();
  Future<List<Bud>> getBudsByLikedGenres();
  Future<List<Bud>> getBudsByLikedAlbums();
  Future<List<Bud>> getBudsByPlayedTracks();

  // By top items
  Future<List<Bud>> getBudsByTopArtists();
  Future<List<Bud>> getBudsByTopTracks();
  Future<List<Bud>> getBudsByTopGenres();
  Future<List<Bud>> getBudsByTopAnime();
  Future<List<Bud>> getBudsByTopManga();

  // By specific item
  Future<List<Bud>> getBudsByArtist(String artistId);
  Future<List<Bud>> getBudsByTrack(String trackId);
  Future<List<Bud>> getBudsByGenre(String genreId);
  Future<List<Bud>> getBudsByAlbum(String albumId);

  // Search
  Future<List<Bud>> searchBuds(String query);
}
