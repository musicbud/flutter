import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/widgets/track_list_item.dart';
import 'package:musicbud_flutter/widgets/artist_list_item.dart';
import 'package:musicbud_flutter/widgets/genre_list_item.dart';
import 'package:musicbud_flutter/widgets/album_list_item.dart';

class CommonItemsPage extends StatefulWidget {
  final ApiService apiService;
  final String budId;

  const CommonItemsPage({Key? key, required this.apiService, required this.budId}) : super(key: key);

  @override
  _CommonItemsPageState createState() => _CommonItemsPageState();
}

class _CommonItemsPageState extends State<CommonItemsPage> {
  List<CommonTrack> _topTracks = [];
  List<CommonArtist> _topArtists = [];
  List<CommonGenre> _topGenres = [];
  List<CommonTrack> _likedTracks = [];
  List<CommonArtist> _likedArtists = [];
  List<CommonAlbum> _likedAlbums = [];
  List<CommonTrack> _playedTracks = [];

  @override
  void initState() {
    super.initState();
    _loadCommonItems();
  }

  Future<void> _loadCommonItems() async {
    final topTracks = await widget.apiService.getCommonTopTracks(widget.budId);
    final topArtists = await widget.apiService.getCommonTopArtists(widget.budId);
    final topGenres = await widget.apiService.getCommonTopGenres(widget.budId);
    final likedTracks = await widget.apiService.getCommonLikedTracks(widget.budId);
    final likedArtists = await widget.apiService.getCommonLikedArtists(widget.budId);
    final likedAlbums = await widget.apiService.getCommonLikedAlbums(widget.budId);
    final playedTracks = await widget.apiService.getCommonPlayedTracks(widget.budId);

    setState(() {
      _topTracks = topTracks;
      _topArtists = topArtists;
      _topGenres = topGenres;
      _likedTracks = likedTracks;
      _likedArtists = likedArtists;
      _likedAlbums = likedAlbums;
      _playedTracks = playedTracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Common Items'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Top Tracks'),
              Tab(text: 'Top Artists'),
              Tab(text: 'Top Genres'),
              Tab(text: 'Liked Tracks'),
              Tab(text: 'Liked Artists'),
              Tab(text: 'Liked Albums'),
              Tab(text: 'Played Tracks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListView<CommonTrack>(_topTracks, (item) => TrackListItem(track: item)),
            _buildListView<CommonArtist>(_topArtists, (item) => ArtistListItem(artist: item)),
            _buildListView<CommonGenre>(_topGenres, (item) => GenreListItem(genre: item)),
            _buildListView<CommonTrack>(_likedTracks, (item) => TrackListItem(track: item)),
            _buildListView<CommonArtist>(_likedArtists, (item) => ArtistListItem(artist: item)),
            _buildListView<CommonAlbum>(_likedAlbums, (item) => AlbumListItem(album: item)),
            _buildListView<CommonTrack>(_playedTracks, (item) => TrackListItem(track: item)),
          ],
        ),
      ),
    );
  }

  Widget _buildListView<T>(List<T> items, Widget Function(T) itemBuilder) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}
