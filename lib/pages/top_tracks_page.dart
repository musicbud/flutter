import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/top_tracks_horizontal_list.dart';

class TopTracksPage extends StatefulWidget {
  const TopTracksPage({super.key});

  @override
  _TopTracksPageState createState() => _TopTracksPageState();
}

class _TopTracksPageState extends State<TopTracksPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<Track> _tracks = []; // Initialize with your initial data

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

    // Fetch more tracks and add to the list
    // Example: final newTracks = await fetchMoreTracks();
    // setState(() {
    //   _tracks.addAll(newTracks);
    // });

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Tracks'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _tracks.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _tracks.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final track = _tracks[index];
          return ListTile(
            title: Text(track.name),
            subtitle: Text(track.spotifyId),
            trailing: Text('${track.durationMs ?? 0} ms'),
          );
        },
      ),
    );
  }
}
