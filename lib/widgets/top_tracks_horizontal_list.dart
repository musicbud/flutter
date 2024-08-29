import 'package:flutter/material.dart';
import '../models/track.dart';

class TopTracksHorizontalList extends StatefulWidget {
  final List<Track> initialTracks;
  final Future<List<Track>> Function(int page) loadMoreTracks;

  const TopTracksHorizontalList({
    Key? key,
    required this.initialTracks,
    required this.loadMoreTracks,
  }) : super(key: key);

  @override
  _TopTracksHorizontalListState createState() => _TopTracksHorizontalListState();
}

class _TopTracksHorizontalListState extends State<TopTracksHorizontalList> {
  List<Track> _tracks = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tracks = widget.initialTracks;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 && !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newTracks = await widget.loadMoreTracks(_currentPage + 1);
      setState(() {
        _tracks.addAll(newTracks);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0, // Adjust height as needed
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _tracks.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index == _tracks.length) {
            return _isLoading ? _buildLoadingIndicator() : SizedBox.shrink();
          }
          final track = _tracks[index];
          return _buildTrackCard(track);
        },
      ),
    );
  }

  Widget _buildTrackCard(Track track) {
    return Card(
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            Image.network(
              track.imageUrl ?? 'https://example.com/default_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Text(track.name, overflow: TextOverflow.ellipsis),
            Text(track.artist ?? 'Unknown Artist', overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 50,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
