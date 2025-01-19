import 'package:flutter/material.dart';
import '../../domain/models/track.dart';

class TopTracksHorizontalList extends StatefulWidget {
  final List<Track> initialTracks;
  final Future<List<Track>> Function(int page) loadMoreTracks;

  const TopTracksHorizontalList({
    Key? key,
    required this.initialTracks,
    required this.loadMoreTracks,
  }) : super(key: key);

  @override
  TopTracksHorizontalListState createState() => TopTracksHorizontalListState();
}

class TopTracksHorizontalListState extends State<TopTracksHorizontalList> {
  late List<Track> _tracks;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasReachedEnd = false;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _tracks = widget.initialTracks;
  }

  Future<void> _loadMoreTracks() async {
    if (!_isLoading && !_hasReachedEnd) {
      setState(() {
        _isLoading = true;
      });

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        final newTracks = await widget.loadMoreTracks(_currentPage + 1);

        setState(() {
          _tracks.addAll(newTracks);
          _currentPage++;
          _hasReachedEnd = newTracks.length < _pageSize;
          _isLoading = false;
        });
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error loading tracks: $e'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _tracks.length + 1,
      itemBuilder: (context, index) {
        if (index == _tracks.length) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TextButton(
                  onPressed: _loadMoreTracks,
                  child: const Text('Load More'),
                );
        }
        final track = _tracks[index];
        return SizedBox(
          width: 150,
          child: Column(
            children: [
              track.imageUrl != null
                  ? Image.network(
                      track.imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note),
                    ),
              Text(track.name),
              Text(track.artistName ?? 'Unknown Artist'),
            ],
          ),
        );
      },
    );
  }
}
