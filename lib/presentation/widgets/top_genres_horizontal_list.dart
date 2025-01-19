import 'package:flutter/material.dart';

class TopGenresHorizontalList extends StatefulWidget {
  final List<String> initialGenres;
  final Future<List<String>> Function(int page) loadMoreGenres;

  const TopGenresHorizontalList({
    Key? key,
    required this.initialGenres,
    required this.loadMoreGenres,
  }) : super(key: key);

  @override
  TopGenresHorizontalListState createState() => TopGenresHorizontalListState();
}

class TopGenresHorizontalListState extends State<TopGenresHorizontalList> {
  late List<String> _genres;
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _genres = widget.initialGenres;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newGenres = await widget.loadMoreGenres(_currentPage + 1);
      if (newGenres.isNotEmpty) {
        setState(() {
          _genres.addAll(newGenres);
          _currentPage++;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more genres to load'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading genres: $e'),
          ),
        );
      }
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
      height: 50,
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
