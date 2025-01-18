import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/track.dart';

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
  late List<Track> _tracks;
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tracks = widget.initialTracks;
  }

  Future<void> _loadMoreTracks() async {
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
      print('Error loading more tracks: $e');
      setState(() {
        _isLoading = false;
      });
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
        return Container(
          width: 150,
          child: Column(
            children: [
              Image.network(
                track.imageUrl ?? 'https://example.com/default_image.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(track.name),
              Text(track.artist),
            ],
          ),
        );
      },
    );
  }
}
