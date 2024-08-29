import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../services/api_service.dart';

class TopArtistsHorizontalList extends StatefulWidget {
  @override
  _TopArtistsHorizontalListState createState() => _TopArtistsHorizontalListState();
}

class _TopArtistsHorizontalListState extends State<TopArtistsHorizontalList> {
  bool isLoading = true;
  bool isLoadingMore = false;
  String errorMessage = '';
  List<Artist> artists = [];
  final ApiService _apiService = ApiService();
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchTopArtists();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 && !isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> fetchTopArtists() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await _apiService.fetchTopArtists(page: currentPage);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          isLoading = false;
          artists.addAll(data.map((json) => Artist.fromJson(json)).toList());
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load top artists';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred';
      });
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await _apiService.fetchTopArtists(page: currentPage + 1);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          artists.addAll(data.map((json) => Artist.fromJson(json)).toList());
          currentPage++;
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoadingMore = false;
        });
      }
    } catch (e) {
      print('Error loading more artists: $e');
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && artists.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty && artists.isEmpty) {
      return Center(child: Text(errorMessage));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: artists.length + 1,
        itemBuilder: (context, index) {
          if (index == artists.length) {
            return _buildLoadMoreButton();
          }
          final artist = artists[index];
          return _buildArtistCard(artist);
        },
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: isLoadingMore ? null : _loadMore,
          child: isLoadingMore ? CircularProgressIndicator() : Text('Load More'),
        ),
      ),
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.network(
            artist.imageUrl ?? 'https://example.com/default_image.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                child: Icon(Icons.error),
              );
            },
          ),
          Text(artist.name ?? 'Unknown Artist'),
        ],
      ),
    );
  }
}
