import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/top_artists/top_artists_bloc.dart';
import '../../blocs/top_artists/top_artists_event.dart';
import '../../blocs/top_artists/top_artists_state.dart';
import '../widgets/loading_indicator.dart';

class TopArtistsPage extends StatelessWidget {
  const TopArtistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Artists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<TopArtistsBloc>()
                  .add(const TopArtistsRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TopArtistsBloc, TopArtistsState>(
        builder: (context, state) {
          if (state is TopArtistsInitial) {
            context.read<TopArtistsBloc>().add(const TopArtistsRequested());
            return const LoadingIndicator();
          }

          if (state is TopArtistsLoading) {
            return const LoadingIndicator();
          }

          if (state is TopArtistsLoaded || state is TopArtistsLoadingMore) {
            final artists = state is TopArtistsLoaded
                ? state.artists
                : (state as TopArtistsLoadingMore).currentArtists;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TopArtistsBloc>()
                    .add(const TopArtistsRefreshRequested());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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

                  final artist = artists[index];
                  return Card(
                    child: ListTile(
                      leading: artist.imageUrl != null
                          ? Image.network(
                              artist.imageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(Icons.person),
                            ),
                      title: Text(artist.name),
                      subtitle: artist.genres?.isNotEmpty == true
                          ? Text(artist.genres!.join(', '))
                          : null,
                      trailing: Icon(
                        artist.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: artist.isLiked ? Colors.red : null,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is TopArtistsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<TopArtistsBloc>()
                          .add(const TopArtistsRequested());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
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
