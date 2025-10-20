# BLoC Widgets Usage Examples

This document provides comprehensive, real-world examples for using the three refactored BLoC widgets.

## Table of Contents

1. [BlocFormWidget Examples](#blocformwidget-examples)
2. [BlocListWidget Examples](#bloclistwidget-examples)
3. [BlocTabViewWidget Examples](#bloctabviewwidget-examples)

---

## BlocFormWidget Examples

### Example 1: Simple User Profile Form

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_form_widget.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/inputs/modern_input_field.dart';

class UserProfileFormScreen extends StatefulWidget {
  @override
  State<UserProfileFormScreen> createState() => _UserProfileFormScreenState();
}

class _UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocProvider(
        create: (_) => UserProfileBloc(),
        child: BlocFormWidget<UserProfileBloc, UserProfileState>(
          formKey: _formKey,
          formFields: (context) => [
            ModernInputField(
              controller: _nameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            ModernInputField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'your@email.com',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            ModernInputField(
              controller: _bioController,
              labelText: 'Bio',
              hintText: 'Tell us about yourself',
              prefixIcon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value != null && value.length > 200) {
                  return 'Bio must be 200 characters or less';
                }
                return null;
              },
            ),
          ],
          submitButtonText: 'Save Profile',
          onSubmit: (context) {
            if (_formKey.currentState!.validate()) {
              context.read<UserProfileBloc>().add(
                    UpdateProfileEvent(
                      name: _nameController.text,
                      email: _emailController.text,
                      bio: _bioController.text,
                    ),
                  );
            }
          },
          isLoading: (state) => state is UserProfileLoadingState,
          isSuccess: (state) => state is UserProfileSuccessState,
          isError: (state) => state is UserProfileErrorState,
          getErrorMessage: (state) =>
              (state as UserProfileErrorState).message,
          onSuccess: (context, state) {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
```

### Example 2: Login Form with Custom Styling

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_form_widget.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/inputs/modern_input_field.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/buttons/modern_button.dart';

class LoginFormScreen extends StatefulWidget {
  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => AuthBloc(),
              child: BlocFormWidget<AuthBloc, AuthState>(
                formKey: _formKey,
                padding: const EdgeInsets.all(24.0),
                fieldSpacing: 20.0,
                showLoadingOverlay: false, // Use inline button loading
                submitButtonVariant: ModernButtonVariant.gradient,
                formFields: (context) => [
                  // Logo/Title
                  Column(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to MusicBud',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  ModernInputField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'your@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  ModernInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ],
                submitButtonText: 'Sign In',
                onSubmit: (context) {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                          LoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                  }
                },
                isLoading: (state) => state is AuthLoadingState,
                isSuccess: (state) => state is AuthSuccessState,
                isError: (state) => state is AuthErrorState,
                getErrorMessage: (state) => (state as AuthErrorState).message,
                onSuccess: (context, state) {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## BlocListWidget Examples

### Example 1: Simple Song List with Pull-to-Refresh

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class SongListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Songs')),
      body: BlocProvider(
        create: (_) => SongsBloc()..add(LoadSongsEvent()),
        child: BlocListWidget<SongsBloc, SongsState, Song>(
          getItems: (state) {
            if (state is SongsLoadedState) {
              return state.songs;
            }
            return [];
          },
          isLoading: (state) => state is SongsLoadingState,
          isError: (state) => state is SongsErrorState,
          getErrorMessage: (state) => (state as SongsErrorState).message,
          itemBuilder: (context, song) => ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.albumArtUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note),
                ),
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options menu
              },
            ),
            onTap: () {
              // Play song
            },
          ),
          onRefresh: () async {
            context.read<SongsBloc>().add(RefreshSongsEvent());
            // Wait for the refresh to complete
            await Future.delayed(const Duration(seconds: 1));
          },
          emptyMessage: 'No songs yet. Add some songs to get started!',
          separatorBuilder: (_, __) => const Divider(height: 1),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
```

### Example 2: Grid View with Infinite Scroll (Playlists)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create playlist
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => PlaylistsBloc()..add(LoadPlaylistsEvent()),
        child: BlocListWidget<PlaylistsBloc, PlaylistsState, Playlist>(
          getItems: (state) {
            if (state is PlaylistsLoadedState) {
              return state.playlists;
            }
            return [];
          },
          isLoading: (state) => state is PlaylistsLoadingState,
          isError: (state) => state is PlaylistsErrorState,
          getErrorMessage: (state) => (state as PlaylistsErrorState).message,
          useGridLayout: true,
          gridCrossAxisCount: 2,
          gridSpacing: 16.0,
          gridChildAspectRatio: 0.85,
          padding: const EdgeInsets.all(16),
          enableInfiniteScroll: true,
          onLoadMore: () {
            context.read<PlaylistsBloc>().add(LoadMorePlaylistsEvent());
          },
          itemBuilder: (context, playlist) => Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/playlist',
                  arguments: playlist.id,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          playlist.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.music_note,
                              size: 48,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${playlist.songCount} songs',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Updated ${playlist.lastUpdated}',
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
          ),
          onRefresh: () async {
            context.read<PlaylistsBloc>().add(RefreshPlaylistsEvent());
            await Future.delayed(const Duration(seconds: 1));
          },
          emptyMessage: 'No playlists yet.\nCreate your first playlist!',
          onRetry: () {
            context.read<PlaylistsBloc>().add(LoadPlaylistsEvent());
          },
        ),
      ),
    );
  }
}
```

### Example 3: Search Results with Custom Empty State

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"'),
      ),
      body: BlocProvider(
        create: (_) => SearchBloc()..add(SearchEvent(query: query)),
        child: BlocListWidget<SearchBloc, SearchState, SearchResult>(
          getItems: (state) {
            if (state is SearchLoadedState) {
              return state.results;
            }
            return [];
          },
          isLoading: (state) => state is SearchLoadingState,
          isError: (state) => state is SearchErrorState,
          getErrorMessage: (state) => (state as SearchErrorState).message,
          itemBuilder: (context, result) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(result.imageUrl),
              child: result.imageUrl.isEmpty
                  ? Icon(_getIconForType(result.type))
                  : null,
            ),
            title: Text(result.title),
            subtitle: Text('${result.type} • ${result.subtitle}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to result detail
            },
          ),
          enableRefresh: false, // Don't allow refresh for search results
          emptyWidget: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No results found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching with different keywords',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'song':
        return Icons.music_note;
      case 'artist':
        return Icons.person;
      case 'album':
        return Icons.album;
      case 'playlist':
        return Icons.playlist_play;
      default:
        return Icons.music_note;
    }
  }
}
```

---

## BlocTabViewWidget Examples

### Example 1: User Profile with Tabs (Posts, Followers, Following)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_tab_view_widget.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocTabViewWidget(
        showAppBar: true,
        appBarTitle: 'Profile',
        tabs: [
          BlocTab<UserPostsBloc, UserPostsState>(
            title: 'Posts',
            icon: Icons.grid_on,
            blocProvider: () => UserPostsBloc(userId: userId)
              ..add(LoadUserPostsEvent()),
            builder: (context, state) {
              return BlocListWidget<UserPostsBloc, UserPostsState, Post>(
                getItems: (state) =>
                    state is UserPostsLoadedState ? state.posts : [],
                isLoading: (state) => state is UserPostsLoadingState,
                isError: (state) => state is UserPostsErrorState,
                getErrorMessage: (state) =>
                    (state as UserPostsErrorState).message,
                useGridLayout: true,
                gridCrossAxisCount: 3,
                gridSpacing: 2.0,
                gridChildAspectRatio: 1.0,
                itemBuilder: (context, post) => Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                ),
                emptyMessage: 'No posts yet',
                onRefresh: () async {
                  context.read<UserPostsBloc>().add(RefreshUserPostsEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
              );
            },
            isLoading: (state) => state is UserPostsLoadingState,
          ),
          BlocTab<FollowersBloc, FollowersState>(
            title: 'Followers',
            icon: Icons.people,
            blocProvider: () => FollowersBloc(userId: userId)
              ..add(LoadFollowersEvent()),
            builder: (context, state) {
              return BlocListWidget<FollowersBloc, FollowersState, User>(
                getItems: (state) =>
                    state is FollowersLoadedState ? state.followers : [],
                isLoading: (state) => state is FollowersLoadingState,
                isError: (state) => state is FollowersErrorState,
                getErrorMessage: (state) =>
                    (state as FollowersErrorState).message,
                itemBuilder: (context, user) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: OutlinedButton(
                    onPressed: () {
                      // Follow/Unfollow action
                    },
                    child: Text(user.isFollowing ? 'Following' : 'Follow'),
                  ),
                ),
                emptyMessage: 'No followers yet',
                onRefresh: () async {
                  context.read<FollowersBloc>().add(RefreshFollowersEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
              );
            },
            isLoading: (state) => state is FollowersLoadingState,
            badgeText: state is FollowersLoadedState
                ? '${state.followers.length}'
                : null,
          ),
          BlocTab<FollowingBloc, FollowingState>(
            title: 'Following',
            icon: Icons.person_add,
            blocProvider: () => FollowingBloc(userId: userId)
              ..add(LoadFollowingEvent()),
            builder: (context, state) {
              return BlocListWidget<FollowingBloc, FollowingState, User>(
                getItems: (state) =>
                    state is FollowingLoadedState ? state.following : [],
                isLoading: (state) => state is FollowingLoadingState,
                isError: (state) => state is FollowingErrorState,
                getErrorMessage: (state) =>
                    (state as FollowingErrorState).message,
                itemBuilder: (context, user) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: FilledButton(
                    onPressed: () {
                      // Unfollow action
                    },
                    child: const Text('Following'),
                  ),
                ),
                emptyMessage: 'Not following anyone yet',
                onRefresh: () async {
                  context.read<FollowingBloc>().add(RefreshFollowingEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
              );
            },
            isLoading: (state) => state is FollowingLoadingState,
          ),
        ],
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
```

### Example 2: Music Library Tabs (Songs, Albums, Artists)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_tab_view_widget.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class MusicLibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocTabViewWidget(
      showAppBar: true,
      appBarTitle: 'Library',
      isScrollable: false,
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Navigate to search
          },
        ),
      ],
      tabs: [
        // Songs Tab
        BlocTab<LibrarySongsBloc, LibrarySongsState>(
          title: 'Songs',
          blocProvider: () => LibrarySongsBloc()..add(LoadLibrarySongsEvent()),
          builder: (context, state) {
            return BlocListWidget<LibrarySongsBloc, LibrarySongsState, Song>(
              getItems: (state) =>
                  state is LibrarySongsLoadedState ? state.songs : [],
              isLoading: (state) => state is LibrarySongsLoadingState,
              isError: (state) => state is LibrarySongsErrorState,
              getErrorMessage: (state) =>
                  (state as LibrarySongsErrorState).message,
              itemBuilder: (context, song) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    song.albumArt,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(song.title),
                subtitle: Text('${song.artist} • ${song.album}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.duration,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // Show options
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Play song
                },
              ),
              emptyMessage: 'No songs in your library',
              onRefresh: () async {
                context
                    .read<LibrarySongsBloc>()
                    .add(RefreshLibrarySongsEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
            );
          },
          isLoading: (state) => state is LibrarySongsLoadingState,
          onTabSelected: () {
            print('Songs tab selected');
          },
        ),

        // Albums Tab
        BlocTab<LibraryAlbumsBloc, LibraryAlbumsState>(
          title: 'Albums',
          blocProvider: () =>
              LibraryAlbumsBloc()..add(LoadLibraryAlbumsEvent()),
          builder: (context, state) {
            return BlocListWidget<LibraryAlbumsBloc, LibraryAlbumsState,
                Album>(
              getItems: (state) =>
                  state is LibraryAlbumsLoadedState ? state.albums : [],
              isLoading: (state) => state is LibraryAlbumsLoadingState,
              isError: (state) => state is LibraryAlbumsErrorState,
              getErrorMessage: (state) =>
                  (state as LibraryAlbumsErrorState).message,
              useGridLayout: true,
              gridCrossAxisCount: 2,
              gridSpacing: 12.0,
              gridChildAspectRatio: 0.75,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, album) => Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    // Navigate to album detail
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.network(
                          album.coverUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.title,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              album.artist,
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
              ),
              emptyMessage: 'No albums in your library',
              onRefresh: () async {
                context
                    .read<LibraryAlbumsBloc>()
                    .add(RefreshLibraryAlbumsEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
            );
          },
          isLoading: (state) => state is LibraryAlbumsLoadingState,
        ),

        // Artists Tab
        BlocTab<LibraryArtistsBloc, LibraryArtistsState>(
          title: 'Artists',
          blocProvider: () =>
              LibraryArtistsBloc()..add(LoadLibraryArtistsEvent()),
          builder: (context, state) {
            return BlocListWidget<LibraryArtistsBloc, LibraryArtistsState,
                Artist>(
              getItems: (state) =>
                  state is LibraryArtistsLoadedState ? state.artists : [],
              isLoading: (state) => state is LibraryArtistsLoadingState,
              isError: (state) => state is LibraryArtistsErrorState,
              getErrorMessage: (state) =>
                  (state as LibraryArtistsErrorState).message,
              itemBuilder: (context, artist) => ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(artist.imageUrl),
                ),
                title: Text(artist.name),
                subtitle: Text('${artist.albumCount} albums'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to artist detail
                },
              ),
              emptyMessage: 'No artists in your library',
              onRefresh: () async {
                context
                    .read<LibraryArtistsBloc>()
                    .add(RefreshLibraryArtistsEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
            );
          },
          isLoading: (state) => state is LibraryArtistsLoadingState,
        ),
      ],
    );
  }
}
```

### Example 3: Analytics Dashboard with Custom Tab Controller

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_tab_view_widget.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: BlocTabViewWidget(
        tabController: _tabController,
        tabs: [
          BlocTab<OverviewBloc, OverviewState>(
            title: 'Overview',
            icon: Icons.dashboard,
            blocProvider: () => OverviewBloc()..add(LoadOverviewEvent()),
            builder: (context, state) {
              if (state is OverviewLoadedState) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildMetricCard(
                        'Total Plays',
                        '${state.totalPlays}',
                        Icons.play_arrow,
                        Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _buildMetricCard(
                        'Total Listeners',
                        '${state.totalListeners}',
                        Icons.people,
                        Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildMetricCard(
                        'Total Revenue',
                        '\$${state.totalRevenue}',
                        Icons.attach_money,
                        Colors.orange,
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
            isLoading: (state) => state is OverviewLoadingState,
          ),
          BlocTab<RevenueBloc, RevenueState>(
            title: 'Revenue',
            icon: Icons.trending_up,
            blocProvider: () => RevenueBloc()..add(LoadRevenueEvent()),
            builder: (context, state) {
              if (state is RevenueLoadedState) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.revenueData.length,
                  itemBuilder: (context, index) {
                    final item = state.revenueData[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.month),
                        trailing: Text(
                          '\$${item.amount}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
            isLoading: (state) => state is RevenueLoadingState,
          ),
          BlocTab<EngagementBloc, EngagementState>(
            title: 'Engagement',
            icon: Icons.favorite,
            blocProvider: () => EngagementBloc()..add(LoadEngagementEvent()),
            builder: (context, state) {
              if (state is EngagementLoadedState) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Top Songs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ...state.topSongs.map(
                      (song) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(song.imageUrl),
                          ),
                          title: Text(song.title),
                          subtitle: Text('${song.plays} plays'),
                          trailing: Text('${song.likes} ❤️'),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
            isLoading: (state) => state is EngagementLoadingState,
          ),
        ],
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Combining Multiple Widgets

### Example: Complex Form with List Preview

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_form_widget.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';

class CreatePlaylistScreen extends StatefulWidget {
  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Playlist')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CreatePlaylistBloc()),
          BlocProvider(
            create: (_) => AvailableSongsBloc()..add(LoadAvailableSongsEvent()),
          ),
        ],
        child: Column(
          children: [
            // Form section
            BlocFormWidget<CreatePlaylistBloc, CreatePlaylistState>(
              formKey: _formKey,
              formFields: (context) => [
                ModernInputField(
                  controller: _nameController,
                  labelText: 'Playlist Name',
                  prefixIcon: Icons.playlist_play,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                ModernInputField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
              ],
              submitButtonText: 'Create Playlist',
              onSubmit: (context) {
                if (_formKey.currentState!.validate()) {
                  context.read<CreatePlaylistBloc>().add(
                        CreatePlaylistEvent(
                          name: _nameController.text,
                          description: _descriptionController.text,
                        ),
                      );
                }
              },
              isLoading: (state) => state is CreatePlaylistLoadingState,
              isSuccess: (state) => state is CreatePlaylistSuccessState,
              isError: (state) => state is CreatePlaylistErrorState,
              getErrorMessage: (state) =>
                  (state as CreatePlaylistErrorState).message,
              onSuccess: (context, state) {
                Navigator.of(context).pop(
                  (state as CreatePlaylistSuccessState).playlist,
                );
              },
              showLoadingOverlay: false,
            ),

            // Song list section
            Expanded(
              child: BlocListWidget<AvailableSongsBloc, AvailableSongsState,
                  Song>(
                getItems: (state) =>
                    state is AvailableSongsLoadedState ? state.songs : [],
                isLoading: (state) => state is AvailableSongsLoadingState,
                isError: (state) => state is AvailableSongsErrorState,
                getErrorMessage: (state) =>
                    (state as AvailableSongsErrorState).message,
                itemBuilder: (context, song) => CheckboxListTile(
                  value: song.isSelected,
                  onChanged: (value) {
                    context.read<AvailableSongsBloc>().add(
                          ToggleSongSelectionEvent(song.id),
                        );
                  },
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  secondary: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      song.albumArt,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                emptyMessage: 'No songs available',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Tips and Best Practices

1. **State Management**: Always define clear loading, success, and error states in your BLoCs.

2. **Error Handling**: Provide meaningful error messages that help users understand what went wrong.

3. **Loading States**: Use appropriate loading indicators - overlays for blocking operations, inline for non-blocking.

4. **Empty States**: Customize empty state messages and visuals to guide users on what to do next.

5. **Pull-to-Refresh**: Enable for lists that display time-sensitive data.

6. **Infinite Scroll**: Use for large datasets to improve performance and UX.

7. **Form Validation**: Always validate forms before submission and provide clear error messages.

8. **Tab State**: Each tab in BlocTabViewWidget maintains its own BLoC instance and state.

9. **Memory Management**: BLoCs are automatically disposed when the widget is removed from the tree.

10. **Combine Widgets**: These widgets work great together - use BlocListWidget inside BlocTabViewWidget tabs, or combine forms with lists.
