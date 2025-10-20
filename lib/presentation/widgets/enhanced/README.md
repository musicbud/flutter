# Enhanced UI Components

A comprehensive collection of modern, reusable UI components adapted for the MusicBud design system.

## 📁 Directory Structure

```
enhanced/
├── cards/              # Card components
│   ├── stat_card.dart
│   └── media_card.dart
├── common/            # Common utilities
│   └── image_with_fallback.dart
├── home/              # Home screen widgets
│   ├── quick_actions_grid.dart
│   └── recent_activity_list.dart
├── lists/             # List components
│   └── horizontal_list.dart
├── search/            # Search & filter components
│   └── search_filter_chip.dart
└── state/             # State display widgets
    ├── empty_state.dart
    ├── loading_overlay.dart
    └── error_card.dart
```

---

## 🎯 Component Catalog

### Cards

#### StatCard
Display statistics with animated numbers and trend indicators.

```dart
StatCard(
  title: 'Total Plays',
  value: '1,234',
  icon: Icons.play_circle,
  trend: 12.5,
  color: DesignSystem.primary,
)
```

**Features:**
- Animated number transitions
- Trend indicators with up/down arrows
- Customizable icons and colors
- Compact variant available

#### MediaCard
Display media items (albums, playlists, artists) with images.

```dart
MediaCard.album(
  imageUrl: album.artworkUrl,
  title: album.title,
  artist: album.artist,
  onTap: () => navigateToAlbum(album),
  showPlayButton: true,
)
```

**Factory constructors:**
- `MediaCard.album()` - Square album cards
- `MediaCard.playlist()` - Square playlist cards  
- `MediaCard.artist()` - Circular artist cards

**Features:**
- Image loading states
- Play button overlay
- Badge support (NEW, EXPLICIT)
- Text overlay option

---

### Home Screen

#### QuickActionsGrid
Grid of action buttons for quick access.

```dart
QuickActionsGrid(
  actions: [
    QuickAction(
      icon: Icons.library_music,
      label: 'My Library',
      onTap: () => navigateToLibrary(),
    ),
    QuickAction(
      icon: Icons.favorite,
      label: 'Favorites',
      onTap: () => navigateToFavorites(),
    ),
  ],
)
```

**Layouts:**
- Grid layout (default)
- Single row layout
- Customizable columns (2-4)

#### RecentActivityList
Horizontal scrolling list of recent activities.

```dart
RecentActivityList(
  activities: [
    RecentActivity(
      title: 'Song Name',
      subtitle: 'Artist',
      imageUrl: song.artworkUrl,
      timestamp: DateTime.now(),
      onTap: () => playSong(song),
    ),
  ],
)
```

**Features:**
- Time formatting (e.g., "2 hours ago")
- Image thumbnails with fallback
- Horizontal scrolling
- Tap handling

---

### Lists

#### HorizontalList
Horizontal scrolling list with section header.

```dart
HorizontalList(
  title: 'Recently Played',
  itemCount: albums.length,
  itemBuilder: (context, index) => MediaCard.album(...),
  onSeeAll: () => navigateToAllAlbums(),
)
```

**Factory constructors:**
- `HorizontalList.compact()` - Small items (120x180)
- `HorizontalList.standard()` - Medium items (160x220)
- `HorizontalList.large()` - Large items (200x280)

**Additional variants:**
- `HorizontalChipList` - For filter chips
- `SnapHorizontalList` - With page snapping

---

### Search & Filters

#### SearchFilterChip
Filter chip for search results.

```dart
SearchFilterChip(
  label: 'Rock',
  selected: selectedGenre == 'Rock',
  onTap: () => selectGenre('Rock'),
)
```

**Features:**
- Selected/unselected states
- Icon support
- Close button option
- Customizable colors

---

### State Management

#### EmptyState
Display when lists or data are empty.

```dart
EmptyState(
  icon: Icons.music_note,
  title: 'No songs yet',
  message: 'Start adding songs to your library',
  actionLabel: 'Browse Music',
  onAction: () => navigateToBrowse(),
)
```

**Presets:**
- `EmptyState.noResults()` - For search results
- `EmptyState.noFavorites()` - For empty favorites
- `EmptyState.noPlaylists()` - For empty playlists

#### LoadingOverlay
Full-screen or inline loading indicator.

```dart
LoadingOverlay(
  isLoading: state.isLoading,
  message: 'Loading your music...',
  child: YourContent(),
)
```

**Features:**
- Blocks user interaction while loading
- Optional loading message
- Customizable indicator
- Backdrop blur effect

#### ErrorCard
Display error states with retry option.

```dart
ErrorCard(
  error: 'Failed to load music',
  details: errorDetails,
  onRetry: () => retryLoadMusic(),
)
```

**Presets:**
- `ErrorCard.networkError()` - For network issues
- `ErrorCard.notFound()` - For 404 errors
- `ErrorCard.permissionDenied()` - For permission errors
- `ErrorCard.generic()` - For general errors

**Additional variant:**
- `ErrorBanner` - Compact inline error banner

---

### Common Utilities

#### ImageWithFallback
Network image with loading and error handling.

```dart
ImageWithFallback(
  imageUrl: album.artworkUrl,
  width: 100,
  height: 100,
  borderRadius: 8,
  fallbackIcon: Icons.album,
)
```

**Factory constructors:**
- `ImageWithFallback.circular()` - For avatars
- `ImageWithFallback.square()` - For thumbnails
- `ImageWithFallback.albumArt()` - For album covers
- `ImageWithFallback.artist()` - For artist images

**Features:**
- Automatic fallback on error
- Loading indicators
- Circular and square variants
- Custom placeholder icons

---

## 🚀 Quick Start

### 1. Import Components

```dart
import 'package:musicbud_flutter/presentation/widgets/enhanced/home/quick_actions_grid.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/cards/media_card.dart';
```

### 2. Use in Your Screens

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        QuickActionsGrid(actions: myActions),
        
        HorizontalList.standard(
          title: 'New Releases',
          itemCount: albums.length,
          itemBuilder: (context, index) => MediaCard.album(
            imageUrl: albums[index].artworkUrl,
            title: albums[index].title,
            artist: albums[index].artist,
            onTap: () => openAlbum(albums[index]),
          ),
        ),
        
        RecentActivityList(activities: recentActivities),
      ],
    );
  }
}
```

---

## 🎨 Design System Integration

All components are integrated with your existing `DesignSystem`:

- **Colors**: Use `DesignSystem.primary`, `DesignSystem.surface`, etc.
- **Typography**: Use `DesignSystem.headlineSmall`, `DesignSystem.bodyMedium`, etc.
- **Spacing**: Use `DesignSystem.spacingMD`, `DesignSystem.spacingLG`, etc.
- **Radius**: Use `DesignSystem.radiusMD`, `DesignSystem.radiusLG`, etc.

---

## 📱 Flutter 3.x Compatibility

All components use modern Flutter 3.x APIs:

- `withValues(alpha: 0.5)` instead of deprecated `withOpacity()`
- Latest Material 3 components
- Null-safety throughout
- Performance optimizations

---

## 🔧 Customization

Every component supports extensive customization:

```dart
// Customize colors
MediaCard(
  title: 'Song',
  subtitle: 'Artist',
  // ... other params
)

// Customize spacing
QuickActionsGrid(
  actions: actions,
  spacing: 24,
  padding: EdgeInsets.all(20),
)

// Customize behavior
HorizontalList(
  title: 'Featured',
  itemCount: items.length,
  itemBuilder: (context, index) => CustomWidget(),
  onSeeAll: () => showAll(),
)
```

---

## 📊 Usage Examples

### Home Screen with Multiple Components

```dart
ListView(
  children: [
    // Quick actions
    QuickActionsGrid(
      actions: [
        QuickAction(
          icon: Icons.library_music,
          label: 'Library',
          onTap: () => navigateToLibrary(),
        ),
      ],
    ),
    
    SizedBox(height: DesignSystem.spacingLG),
    
    // Recent activity
    RecentActivityList(
      activities: recentActivities,
    ),
    
    SizedBox(height: DesignSystem.spacingLG),
    
    // New releases
    HorizontalList.standard(
      title: 'New Releases',
      itemCount: albums.length,
      itemBuilder: (context, index) => MediaCard.album(
        imageUrl: albums[index].artworkUrl,
        title: albums[index].title,
        artist: albums[index].artist,
        badge: MediaCardBadge.newRelease(),
      ),
    ),
  ],
)
```

### Search Screen with Filters

```dart
Column(
  children: [
    // Search bar
    SearchBar(),
    
    // Filter chips
    HorizontalChipList(
      items: ['All', 'Songs', 'Albums', 'Artists'],
      selectedItems: {selectedFilter},
      onTap: (filter) => setFilter(filter),
    ),
    
    // Results or empty state
    results.isEmpty
      ? EmptyState.noResults()
      : ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) => ResultItem(results[index]),
        ),
  ],
)
```

### Error Handling

```dart
BlocBuilder<MusicBloc, MusicState>(
  builder: (context, state) {
    if (state is MusicLoading) {
      return LoadingOverlay(
        isLoading: true,
        message: 'Loading music...',
      );
    }
    
    if (state is MusicError) {
      return ErrorCard(
        error: state.message,
        onRetry: () => context.read<MusicBloc>().add(LoadMusic()),
      );
    }
    
    if (state is MusicLoaded && state.music.isEmpty) {
      return EmptyState(
        title: 'No music yet',
        message: 'Start by adding some songs',
        actionLabel: 'Browse Music',
        onAction: () => navigateToBrowse(),
      );
    }
    
    return MusicList(music: state.music);
  },
)
```

---

## ✨ Best Practices

1. **Use Factory Constructors**: They provide sensible defaults
   ```dart
   MediaCard.album(...) // Instead of MediaCard(...)
   ```

2. **Leverage Presets**: For common scenarios
   ```dart
   EmptyState.noResults() // Instead of manual configuration
   ```

3. **Consistent Spacing**: Use DesignSystem constants
   ```dart
   SizedBox(height: DesignSystem.spacingLG)
   ```

4. **Handle All States**: Loading, error, empty, success
   ```dart
   if (loading) return LoadingOverlay(...);
   if (error) return ErrorCard(...);
   if (empty) return EmptyState(...);
   return Content(...);
   ```

---

## 🔍 Component Selection Guide

| Use Case | Component | Why |
|----------|-----------|-----|
| Album/Playlist grid | `MediaCard.album()` | Image + metadata display |
| Action buttons | `QuickActionsGrid` | Quick access to features |
| Recent items | `RecentActivityList` | Time-based horizontal list |
| Statistics | `StatCard` | Numbers with trends |
| Search filters | `SearchFilterChip` | Toggle filters |
| Empty lists | `EmptyState` | User-friendly empty states |
| Loading | `LoadingOverlay` | Block interaction while loading |
| Errors | `ErrorCard` | Retry failed operations |
| Images | `ImageWithFallback` | Graceful image loading |
| Horizontal sections | `HorizontalList` | Categorized content |

---

## 📝 Notes

- All components are **production-ready** and tested
- Components follow **Material Design 3** guidelines
- Full **null-safety** support
- Compatible with **Flutter 3.x+**
- Integrated with your **existing DesignSystem**

---

## 🤝 Contributing

When adding new components:

1. Place in appropriate subdirectory
2. Follow existing naming conventions
3. Include comprehensive documentation
4. Add usage examples
5. Test with real data
6. Update this README

---

For detailed API documentation, see the inline comments in each component file.
