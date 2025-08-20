import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/genre/genre_bloc.dart';
import '../../blocs/genre/genre_event.dart';
import '../../blocs/genre/genre_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/bud_match_list_item.dart';

class GenreDetailsPage extends StatefulWidget {
  final String genreId;
  final String genreName;

  const GenreDetailsPage({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreDetailsPage> createState() => _GenreDetailsPageState();
}

class _GenreDetailsPageState extends State<GenreDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadGenreDetails();
  }

  void _loadGenreDetails() {
    context.read<GenreBloc>().add(GenreDetailsRequested(widget.genreId));
  }

  void _toggleLike() {
    context.read<GenreBloc>().add(GenreLikeToggled(widget.genreId));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        actions: [
          BlocBuilder<GenreBloc, GenreState>(
            builder: (context, state) {
              if (state is GenreDetailsLoaded) {
                return IconButton(
                  icon: Icon(
                    state.genre.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: _toggleLike,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<GenreBloc, GenreState>(
        listener: (context, state) {
          if (state is GenreFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is GenreLoading) {
            return const LoadingIndicator();
          }

          if (state is GenreDetailsLoaded) {
            return ListView(
              children: [
                ListTile(
                  title: Text(state.genre.name),
                  subtitle: state.genre.source != null
                      ? Text('Source: ${state.genre.source}')
                      : null,
                ),
                const Divider(),
                if (state.buds.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Buds who like this genre',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...state.buds
                      .map((budMatch) => BudMatchListItem(budMatch: budMatch)),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No buds found for this genre'),
                    ),
                  ),
              ],
            );
          }

          return const Center(
            child: Text('Failed to load genre details'),
          );
        },
      ),
    );
  }
}
