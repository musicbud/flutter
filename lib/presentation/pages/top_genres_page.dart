import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/genre/top_genres_bloc.dart';
import '../../blocs/genre/top_genres_event.dart';
import '../../blocs/genre/top_genres_state.dart';
import '../../domain/models/common_genre.dart';
import '../widgets/loading_indicator.dart';
import 'genre_details_page.dart';

class TopGenresPage extends StatefulWidget {
  const TopGenresPage({super.key});

  @override
  State<TopGenresPage> createState() => _TopGenresPageState();
}

class _TopGenresPageState extends State<TopGenresPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadGenres();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadGenres() {
    context.read<TopGenresBloc>().add(const TopGenresRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TopGenresBloc>().add(TopGenresLoadMoreRequested());
    }
  }

  void _toggleLike(String genreId) {
    context.read<TopGenresBloc>().add(TopGenreLikeToggled(genreId));
  }

  void _onGenreSelected(BuildContext context, CommonGenre genre) {
    context.read<TopGenresBloc>().add(TopGenreSelected(genre.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreDetailsPage(
          genreId: genre.id,
          genreName: genre.name,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildGenreCard(BuildContext context, CommonGenre genre) {
    return Card(
      child: ListTile(
        title: Text(genre.name),
        trailing: IconButton(
          icon: Icon(
            genre.isLiked ? Icons.favorite : Icons.favorite_border,
            color: genre.isLiked ? Colors.red : null,
          ),
          onPressed: () => _toggleLike(genre.id),
        ),
        onTap: () => _onGenreSelected(context, genre),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Genres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TopGenresBloc>().add(TopGenresRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<TopGenresBloc, TopGenresState>(
        listener: (context, state) {
          if (state is TopGenresFailure) {
            _showErrorSnackBar(state.error);
          } else if (state is TopGenreLikeStatusChanged) {
            _showErrorSnackBar(
              state.isLiked ? 'Added to favorites' : 'Removed from favorites',
            );
          }
        },
        builder: (context, state) {
          if (state is TopGenresInitial) {
            _loadGenres();
            return const LoadingIndicator();
          }

          if (state is TopGenresLoading) {
            return const LoadingIndicator();
          }

          if (state is TopGenresLoaded || state is TopGenresLoadingMore) {
            final genres = state is TopGenresLoaded
                ? state.genres
                : (state as TopGenresLoadingMore).currentGenres;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TopGenresBloc>().add(TopGenresRefreshRequested());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    genres.length + (state is TopGenresLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == genres.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LoadingIndicator(),
                      ),
                    );
                  }

                  return _buildGenreCard(context, genres[index]);
                },
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
