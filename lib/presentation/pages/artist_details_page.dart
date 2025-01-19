import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/common_artist.dart';
import '../../blocs/artist/artist_bloc.dart';
import '../../blocs/artist/artist_event.dart';
import '../../blocs/artist/artist_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/bud_match_list_item.dart';

class ArtistDetailsPage extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistDetailsPage({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<ArtistDetailsPage> createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadArtistDetails();
  }

  void _loadArtistDetails() {
    context.read<ArtistBloc>().add(ArtistDetailsRequested(widget.artistId));
  }

  void _toggleLike() {
    context.read<ArtistBloc>().add(ArtistLikeToggled(widget.artistId));
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
        title: Text(widget.artistName),
        actions: [
          BlocBuilder<ArtistBloc, ArtistState>(
            builder: (context, state) {
              if (state is ArtistDetailsLoaded) {
                return IconButton(
                  icon: Icon(
                    state.artist.isLiked
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
      body: BlocConsumer<ArtistBloc, ArtistState>(
        listener: (context, state) {
          if (state is ArtistFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is ArtistLoading) {
            return const LoadingIndicator();
          }

          if (state is ArtistDetailsLoaded) {
            return ListView(
              children: [
                ListTile(
                  title: Text(state.artist.name),
                  subtitle: state.artist.source != null
                      ? Text('Source: ${state.artist.source}')
                      : null,
                ),
                if (state.artist.imageUrls?.isNotEmpty == true ||
                    state.artist.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                      state.artist.imageUrl ?? state.artist.imageUrls!.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (state.artist.genres?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: state.artist.genres!
                          .map((genre) => Chip(label: Text(genre)))
                          .toList(),
                    ),
                  ),
                const Divider(),
                if (state.buds.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Buds who like this artist',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...state.buds
                      .map((budMatch) => BudMatchListItem(budMatch: budMatch)),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No buds found for this artist'),
                    ),
                  ),
              ],
            );
          }

          return const Center(
            child: Text('Failed to load artist details'),
          );
        },
      ),
    );
  }
}
