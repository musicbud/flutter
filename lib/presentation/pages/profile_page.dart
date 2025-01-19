import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../domain/models/content_service.dart';
import '../../domain/models/user_profile.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../pages/login_page.dart';
import '../widgets/track_list_item.dart';
import '../widgets/artist_list_item.dart';
import '../widgets/genre_list_item.dart';
import '../widgets/album_list_item.dart';
import '../widgets/anime_list_item.dart';
import '../widgets/manga_list_item.dart';
import '../widgets/bud_match_list_item.dart';
import '../widgets/loading_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _loadUserProfile();
    _loadConnectedServices();
  }

  void _checkAuthentication() {
    context.read<ProfileBloc>().add(ProfileAuthenticationChecked());
  }

  void _loadUserProfile() {
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!mounted) return;
      context.read<ProfileBloc>().add(ProfileAvatarUpdateRequested(image));
    }
  }

  void _logout() {
    context.read<ProfileBloc>().add(ProfileLogoutRequested());
  }

  void _loadTopItems(String category) {
    context.read<ProfileBloc>().add(ProfileTopItemsRequested(category));
  }

  void _loadLikedItems(String category) {
    context.read<ProfileBloc>().add(ProfileLikedItemsRequested(category));
  }

  void _loadBuds(String category) {
    context.read<ProfileBloc>().add(ProfileBudsRequested(category));
  }

  void _loadConnectedServices() {
    context.read<ProfileBloc>().add(ProfileConnectedServicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          _showSnackBar('Error: ${state.error}');
        } else if (state is ProfileLogoutSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileAuthenticationStatus && !state.isAuthenticated) {
          return const LoginPage();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: _logout,
              ),
            ],
          ),
          body: _buildBody(state),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  _loadUserProfile();
                  _loadConnectedServices();
                  break;
                case 1:
                  _loadTopItems('tracks');
                  break;
                case 2:
                  _loadLikedItems('tracks');
                  break;
                case 3:
                  _loadBuds('liked/artists');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Top',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Liked',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Buds',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (_selectedIndex) {
      case 0:
        return _buildProfileTab(state);
      case 1:
        return _buildTopItemsTab(state);
      case 2:
        return _buildLikedItemsTab(state);
      case 3:
        return _buildBudsTab(state);
      default:
        return const Center(child: Text('Invalid tab'));
    }
  }

  Widget _buildProfileTab(ProfileState state) {
    if (state is ProfileLoaded) {
      final profile = state.profile;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _updateAvatar,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.username,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (profile.bio != null) ...[
              const SizedBox(height: 8),
              Text(profile.bio!),
            ],
            if (profile.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(profile.location!),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(
                    'Followers', profile.followersCount.toString()),
                _buildStatColumn(
                    'Following', profile.followingCount.toString()),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Connected Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, servicesState) {
                if (servicesState is ProfileConnectedServicesLoaded) {
                  return _buildConnectedServices(servicesState.services);
                }
                return _buildConnectedServices([]);
              },
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Failed to load profile'));
  }

  Widget _buildTopItemsTab(ProfileState state) {
    if (state is ProfileTopItemsLoaded) {
      return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          if (item is CommonTrack) {
            return TrackListItem(track: item);
          } else if (item is CommonArtist) {
            return ArtistListItem(artist: item);
          } else if (item is CommonGenre) {
            return GenreListItem(genre: item);
          }
          return const ListTile(title: Text('Unknown item type'));
        },
      );
    }
    return const Center(child: Text('No top items available'));
  }

  Widget _buildLikedItemsTab(ProfileState state) {
    if (state is ProfileLikedItemsLoaded) {
      return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          if (item is CommonTrack) {
            return TrackListItem(track: item);
          } else if (item is CommonArtist) {
            return ArtistListItem(artist: item);
          } else if (item is CommonGenre) {
            return GenreListItem(genre: item);
          } else if (item is CommonAlbum) {
            return AlbumListItem(album: item);
          } else if (item is CommonAnime) {
            return AnimeListItem(anime: item);
          } else if (item is CommonManga) {
            return MangaListItem(manga: item);
          }
          return const ListTile(title: Text('Unknown item type'));
        },
      );
    }
    return const Center(child: Text('No liked items available'));
  }

  Widget _buildBudsTab(ProfileState state) {
    if (state is ProfileBudsLoaded) {
      return ListView.builder(
        itemCount: state.buds.length,
        itemBuilder: (context, index) {
          return BudMatchListItem(budMatch: state.buds[index]);
        },
      );
    }
    return const Center(child: Text('No buds available'));
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildConnectedServices(List<ContentService> services) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ListTile(
          leading: Image.network(
            service.iconUrl,
            width: 24,
            height: 24,
          ),
          title: Text(service.name),
          subtitle: Text(service.status),
          trailing: service.isConnected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.error, color: Colors.red),
        );
      },
    );
  }
}
