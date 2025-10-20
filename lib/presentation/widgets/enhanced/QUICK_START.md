# Quick Start Guide

Get started with the enhanced components in under 5 minutes!

## 📦 Complete Component List

You now have **9 component types** ready to use:

### ✅ Available Components

1. **ErrorCard** - Error displays with retry
2. **MediaCard** - Album/playlist/artist cards
3. **ImageWithFallback** - Network images with graceful fallback
4. **HorizontalList** - Horizontal scrolling sections
5. **QuickActionsGrid** - Action button grids
6. **RecentActivityList** - Recent activity horizontal list
7. **SearchFilterChip** - Search filter chips
8. **EmptyState** - Empty list states
9. **LoadingOverlay** - Loading indicators
10. **StatCard** - Statistics display

---

## 🚀 Quick Integration

### Step 1: Import

Instead of importing individual files, use the barrel import:

```dart
import 'package:musicbud_flutter/presentation/widgets/enhanced/enhanced_widgets.dart';
```

This gives you access to all components!

### Step 2: Use in Your Screen

Here's a complete example for a home screen:

```dart
import 'package:flutter/material.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/enhanced_widgets.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MusicBud')),
      body: ListView(
        children: [
          // Quick action buttons
          QuickActionsGrid(
            actions: [
              QuickAction(
                icon: Icons.library_music,
                label: 'Library',
                onTap: () => Navigator.pushNamed(context, '/library'),
              ),
              QuickAction(
                icon: Icons.favorite,
                label: 'Favorites',
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              QuickAction(
                icon: Icons.history,
                label: 'History',
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
              QuickAction(
                icon: Icons.playlist_play,
                label: 'Playlists',
                onTap: () => Navigator.pushNamed(context, '/playlists'),
              ),
            ],
          ),

          const SizedBox(height: DesignSystem.spacingXL),

          // Recent activity
          RecentActivityList(
            activities: [
              RecentActivity(
                title: 'Bohemian Rhapsody',
                subtitle: 'Queen',
                imageUrl: 'https://example.com/album.jpg',
                timestamp: DateTime.now().subtract(Duration(hours: 2)),
                onTap: () => print('Play song'),
              ),
              // Add more activities...
            ],
          ),

          const SizedBox(height: DesignSystem.spacingXL),

          // New releases section
          HorizontalList.standard(
            title: 'New Releases',
            itemCount: 10,
            itemBuilder: (context, index) => MediaCard.album(
              imageUrl: 'https://example.com/album$index.jpg',
              title: 'Album Title $index',
              artist: 'Artist Name',
              showPlayButton: true,
              onTap: () => print('Open album $index'),
            ),
            onSeeAll: () => Navigator.pushNamed(context, '/new-releases'),
          ),

          const SizedBox(height: DesignSystem.spacingXL),

          // Statistics row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
            child: Row(
              children: [
                Expanded(
                  child: StatCard.compact(
                    title: 'Songs',
                    value: '1,234',
                    icon: Icons.music_note,
                    color: DesignSystem.primary,
                  ),
                ),
                SizedBox(width: DesignSystem.spacingMD),
                Expanded(
                  child: StatCard.compact(
                    title: 'Hours',
                    value: '567',
                    icon: Icons.access_time,
                    color: DesignSystem.secondary,
                    trend: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Common Patterns

### Pattern 1: List with States

Handle loading, error, empty, and success states:

```dart
BlocBuilder<MusicBloc, MusicState>(
  builder: (context, state) {
    // Loading state
    if (state is MusicLoading) {
      return LoadingOverlay(
        isLoading: true,
        message: 'Loading your music...',
        child: SizedBox(height: 300),
      );
    }

    // Error state
    if (state is MusicError) {
      return ErrorCard(
        error: state.message,
        onRetry: () => context.read<MusicBloc>().add(LoadMusic()),
      );
    }

    // Empty state
    if (state is MusicLoaded && state.songs.isEmpty) {
      return EmptyState(
        icon: Icons.music_note,
        title: 'No music yet',
        message: 'Start by adding some songs to your library',
        actionLabel: 'Browse Music',
        onAction: () => Navigator.pushNamed(context, '/browse'),
      );
    }

    // Success state
    return MusicList(songs: state.songs);
  },
)
```

### Pattern 2: Search Screen

```dart
Column(
  children: [
    // Search bar
    Padding(
      padding: EdgeInsets.all(DesignSystem.spacingLG),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (query) => performSearch(query),
      ),
    ),

    // Filter chips
    HorizontalChipList(
      items: ['All', 'Songs', 'Albums', 'Artists', 'Playlists'],
      selectedItems: {selectedFilter},
      onTap: (filter) => setState(() => selectedFilter = filter),
    ),

    SizedBox(height: DesignSystem.spacingMD),

    // Results
    Expanded(
      child: searchResults.isEmpty
        ? EmptyState.noResults()
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) => SearchResultItem(
              result: searchResults[index],
            ),
          ),
    ),
  ],
)
```

### Pattern 3: Album/Playlist Grid

```dart
GridView.builder(
  padding: EdgeInsets.all(DesignSystem.spacingLG),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: DesignSystem.spacingMD,
    mainAxisSpacing: DesignSystem.spacingMD,
  ),
  itemCount: albums.length,
  itemBuilder: (context, index) {
    final album = albums[index];
    return MediaCard.album(
      imageUrl: album.artworkUrl,
      title: album.title,
      artist: album.artist,
      badge: album.isNew ? MediaCardBadge.newRelease() : null,
      onTap: () => navigateToAlbum(album),
      showPlayButton: true,
    );
  },
)
```

---

## 💡 Pro Tips

### 1. Use Factory Constructors

Many components have factory constructors for common use cases:

```dart
// Good ✅
MediaCard.album(...)
EmptyState.noResults()
ErrorCard.networkError()
HorizontalList.standard(...)

// Less convenient ❌
MediaCard(aspectRatio: 1.0, placeholderIcon: Icons.album, ...)
```

### 2. Combine Components

Components work great together:

```dart
HorizontalList.standard(
  title: 'Top Artists',
  itemCount: artists.length,
  itemBuilder: (context, index) => MediaCard.artist(
    imageUrl: artists[index].imageUrl,
    name: artists[index].name,
    genre: artists[index].genre,
  ),
)
```

### 3. Handle Network Images

Use `ImageWithFallback` for all network images:

```dart
// Automatic fallback
ImageWithFallback.albumArt(
  imageUrl: song.artworkUrl,
  size: 80,
)

// Custom fallback
ImageWithFallback(
  imageUrl: user.avatarUrl,
  width: 50,
  height: 50,
  borderRadius: 25,
  fallbackIcon: Icons.person,
)
```

### 4. Consistent Spacing

Always use DesignSystem constants:

```dart
SizedBox(height: DesignSystem.spacingMD)  // 12px
SizedBox(height: DesignSystem.spacingLG)  // 16px
SizedBox(height: DesignSystem.spacingXL)  // 24px
```

---

## 🐛 Common Issues & Solutions

### Issue: Images not loading

**Solution:** Use `ImageWithFallback` instead of `Image.network`:

```dart
// Before ❌
Image.network(url)

// After ✅
ImageWithFallback(
  imageUrl: url,
  width: 100,
  height: 100,
)
```

### Issue: Empty state not showing

**Solution:** Make sure to handle all state cases:

```dart
if (loading) return LoadingOverlay(...);
if (error) return ErrorCard(...);
if (items.isEmpty) return EmptyState(...);  // Don't forget this!
return ItemList(...);
```

### Issue: Horizontal list too tall/short

**Solution:** Set explicit height:

```dart
HorizontalList.standard(  // Height: 220px
  ...
)

// Or customize:
HorizontalList(
  itemHeight: 300,
  ...
)
```

---

## 📊 Component Decision Tree

```
Need to display...

├─ Loading? → LoadingOverlay
├─ Error? → ErrorCard (with retry)
├─ Empty list? → EmptyState
├─ Statistics? → StatCard
├─ Images?
│  ├─ Single image → ImageWithFallback
│  └─ Media items → MediaCard
├─ Lists?
│  ├─ Horizontal → HorizontalList
│  └─ Recent items → RecentActivityList
├─ Actions? → QuickActionsGrid
└─ Filters? → SearchFilterChip / HorizontalChipList
```

---

## 🎓 Learning Path

**Day 1:** Start with the basics
1. Add `QuickActionsGrid` to your home screen
2. Add a `HorizontalList` with `MediaCard`s
3. Test with real data

**Day 2:** Add state handling
1. Wrap content with `LoadingOverlay`
2. Add `ErrorCard` for errors
3. Add `EmptyState` for empty lists

**Day 3:** Polish the UI
1. Add `StatCard`s for statistics
2. Use `ImageWithFallback` everywhere
3. Add `RecentActivityList` for recent items

---

## 🚀 Next Steps

1. **Test with real data** - Replace mock data with actual API calls
2. **Customize colors** - Tweak component colors to match your brand
3. **Add more screens** - Apply patterns to search, library, profile, etc.
4. **Handle edge cases** - Add proper error handling and empty states

---

## 📚 More Resources

- **Full Documentation:** See [README.md](./README.md)
- **Component APIs:** Check inline docs in each component file
- **Design System:** Review `lib/core/theme/design_system.dart`

---

**Need help?** Check the full README or the inline documentation in each component file!
