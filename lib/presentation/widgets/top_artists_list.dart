import 'package:flutter/material.dart';
import '../../models/artist.dart';
import '../pages/top_tracks_page.dart';

class TopArtistsList extends StatefulWidget {
  final List<Artist> artists;

  const TopArtistsList({Key? key, required this.artists}) : super(key: key);

  @override
  _TopArtistsListState createState() => _TopArtistsListState();
}

class _TopArtistsListState extends State<TopArtistsList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    // Fetch more artists and add to the list
    // Example: final newArtists = await fetchMoreArtists();
    // setState(() {
    //   widget.artists.addAll(newArtists);
    // });

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.artists.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.artists.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final artist = widget.artists[index];
        return ListTile(
          title: Text(artist.name),
          subtitle: Text(artist.genres.join(', ')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TopTracksPage(artistId: artist.id)),
            );
          },
        );
      },
    );
  }
}
