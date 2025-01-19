import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/common_artist.dart';
import '../../blocs/top_artists/top_artists_bloc.dart';
import '../../blocs/top_artists/top_artists_event.dart';
import '../../blocs/top_artists/top_artists_state.dart';
import '../pages/artist_details_page.dart';
import 'loading_indicator.dart';

class TopArtistsHorizontalList extends StatefulWidget {
  const TopArtistsHorizontalList({super.key});

  @override
  State<TopArtistsHorizontalList> createState() =>
      _TopArtistsHorizontalListState();
}

class _TopArtistsHorizontalListState extends State<TopArtistsHorizontalList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTopArtists();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTopArtists() {
    context.read<TopArtistsBloc>().add(const TopArtistsRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TopArtistsBloc>().add(const TopArtistsLoadMoreRequested());
    }
  }

  Widget _buildArtistCard(CommonArtist artist) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailsPage(
                artistId: artist.id,
                artistName: artist.name,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artist.imageUrls?.isNotEmpty == true || artist.imageUrl != null)
              Image.network(
                artist.imageUrl ?? artist.imageUrls!.first,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 120,
                width: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 48),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (artist.genres?.isNotEmpty == true)
                    Text(
                      artist.genres!.first,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopArtistsBloc, TopArtistsState>(
      listener: (context, state) {
        if (state is TopArtistsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is TopArtistsInitial || state is TopArtistsLoading) {
          return const LoadingIndicator();
        }

        if (state is TopArtistsLoaded || state is TopArtistsLoadingMore) {
          final artists = state is TopArtistsLoaded
              ? state.artists
              : (state as TopArtistsLoadingMore).currentArtists;

          return Column(
            children: [
              SizedBox(
                height: 220,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      artists.length + (state is TopArtistsLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == artists.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: LoadingIndicator(),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildArtistCard(artists[index]),
                    );
                  },
                ),
              ),
              if (state is TopArtistsLoaded && state.hasReachedEnd)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No more artists to load',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          );
        }

        return const Center(
          child: Text('Failed to load top artists'),
        );
      },
    );
  }
}
