import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class TopGenresHorizontalList extends StatefulWidget {
  final ApiService apiService;

  const TopGenresHorizontalList({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  _TopGenresHorizontalListState createState() =>
      _TopGenresHorizontalListState();
}

class _TopGenresHorizontalListState extends State<TopGenresHorizontalList> {
  List<String> _genres = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialGenres();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialGenres() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final genres = await widget.apiService.getTopGenres(page: 1);
      setState(() {
        _genres = genres;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading initial genres: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newGenres =
          await widget.apiService.getTopGenres(page: _currentPage + 1);
      if (newGenres.isNotEmpty) {
        setState(() {
          _genres.addAll(newGenres);
          _currentPage++;
        });
      } else {
        debugPrint('No more genres to load');
      }
    } catch (e) {
      debugPrint('Error loading more genres: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _genres.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 50, // Adjust this value as needed
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _genres.length + 1,
        itemBuilder: (context, index) {
          if (index == _genres.length) {
            return _buildLoadMoreButton();
          }
          return _buildGenreChip(_genres[index]);
        },
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Chip(
        label: Text(genre),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _isLoading ? null : _loadMore,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Load More'),
        ),
      ),
    );
  }
}
