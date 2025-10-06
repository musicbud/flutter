# Widget Composition Patterns

This directory contains a comprehensive set of widget composition patterns designed to help developers easily compose atomic widgets together in the MusicBud Flutter application.

## Overview

The widget composition system is organized into three main categories:

1. **Builders** - Fluent APIs for building widgets with consistent patterns
2. **Composers** - Layout composers for complex widget arrangements
3. **Factories** - Pre-configured widget factories for common use cases

## Directory Structure

```
lib/presentation/widgets/
├── builders/          # Widget builders and composers
│   ├── card_builder.dart      # Card composition patterns
│   ├── list_builder.dart      # List/grid composition patterns
│   └── state_builder.dart     # State display patterns
├── composers/         # Layout composers
│   ├── responsive_layout.dart # Responsive design patterns
│   ├── section_composer.dart  # Section layout patterns
│   └── card_composer.dart     # Complex card layouts
└── factories/         # Widget factories
    ├── widget_factory.dart    # Dynamic widget creation
    ├── card_factory.dart      # Specific card types
    └── state_factory.dart     # State display factories
```

## Quick Start

### Using Builders

```dart
import 'package:musicbud_flutter/presentation/widgets/builders/card_builder.dart';

// Create a simple card
final card = CardBuilder()
  .withVariant(CardVariant.primary)
  .withHeader(
    title: 'My Card',
    subtitle: 'Card description',
  )
  .withContent(
    child: Text('Card content goes here'),
  )
  .withActions([
    TextButton(onPressed: () {}, child: Text('Cancel')),
    ElevatedButton(onPressed: () {}, child: Text('Save')),
  ])
  .build();
```

### Using Composers

```dart
import 'package:musicbud_flutter/presentation/widgets/composers/section_composer.dart';

// Create a section with header and content
final section = SectionComposer()
  .withTitle('Featured Playlists')
  .withAction(
    text: 'View All',
    onPressed: () => navigateToAllPlaylists(),
  )
  .withContent(
    child: ListBuilder<String>()
      .withItems(['Playlist 1', 'Playlist 2', 'Playlist 3'])
      .withItemBuilder((context, item, index) => ListTile(title: Text(item)))
      .build(),
  )
  .build();
```

### Using Factories

```dart
import 'package:musicbud_flutter/presentation/widgets/factories/card_factory.dart';

// Create pre-configured card types
final playlistCard = CardFactory().createPlaylistCard(
  title: 'My Playlist',
  trackCount: '25 tracks',
  imageUrl: 'https://example.com/playlist.jpg',
  accentColor: DesignSystem.primary,
  onTap: () => navigateToPlaylist(),
);
```

## Builders

### CardBuilder

A fluent API for building cards with consistent styling and behavior.

**Features:**
- Multiple card variants (primary, secondary, accent, outlined)
- Customizable padding, margins, and styling
- Support for headers, content, footers, and actions
- Interactive cards with tap callbacks
- Consistent with app's design system

**Example:**
```dart
final card = CardBuilder()
  .withVariant(CardVariant.accent)
  .withPadding(EdgeInsets.all(DesignSystem.spacingMD))
  .withHeader(
    title: 'Premium Feature',
    subtitle: 'Unlock exclusive content',
    badge: 'Premium',
  )
  .withContent(
    child: Column(
      children: [
        Text('Feature description...'),
        SizedBox(height: DesignSystem.spacingMD),
        LinearProgressIndicator(value: 0.7),
      ],
    ),
  )
  .withActions([
    TextButton(onPressed: () {}, child: Text('Learn More')),
    ElevatedButton(onPressed: () {}, child: Text('Upgrade')),
  ])
  .build();
```

### ListBuilder

A fluent API for building lists and grids with consistent layouts.

**Features:**
- Support for both list and grid layouts
- Customizable item spacing and separators
- Built-in support for loading, error, and empty states
- Flexible item builder patterns
- Consistent styling with design system

**Example:**
```dart
final listWidget = ListBuilder<Track>()
  .withItems(tracks)
  .withItemBuilder((context, track, index) {
    return TrackTile(
      track: track,
      onTap: () => playTrack(track),
    );
  })
  .withSeparatorBuilder((context, index) {
    return Divider(height: 1, color: DesignSystem.border);
  })
  .withPadding(EdgeInsets.all(DesignSystem.spacingMD))
  .withLoadingState(ListLoadingState.none)
  .build();
```

### StateBuilder

A fluent API for building state displays with proper fallbacks.

**Features:**
- Support for loading, error, empty, and success states
- Customizable state-specific widgets and messages
- Built-in retry functionality for error states
- Consistent styling with design system
- Flexible state management and transitions

**Example:**
```dart
final stateWidget = StateBuilder()
  .withState(StateType.loading)
  .withLoadingMessage('Fetching your music...')
  .withLoadingWidget(
    Lottie.asset('assets/loading_animation.json'),
  )
  .withEmptyMessage('No tracks found')
  .withEmptyIcon(Icons.music_note)
  .withErrorMessage('Failed to load music')
  .withOnRetry(() => loadMusicData())
  .build();
```

## Composers

### ResponsiveLayout

A composer for handling responsive design patterns.

**Features:**
- Breakpoint-based responsive design
- Flexible grid and flex layouts
- Adaptive spacing and sizing
- Support for custom breakpoints
- Built-in common responsive patterns

**Example:**
```dart
final responsiveLayout = ResponsiveLayout(
  builder: (context, breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.xs:
        return Column(children: [/* mobile layout */]);
      case ResponsiveBreakpoint.sm:
        return Row(children: [/* tablet layout */]);
      case ResponsiveBreakpoint.md:
      case ResponsiveBreakpoint.lg:
      case ResponsiveBreakpoint.xl:
        return Row(children: [/* desktop layout */]);
    }
  },
);
```

### SectionComposer

A composer for creating sections with headers and content.

**Features:**
- Flexible header configuration with actions
- Support for multiple content layouts
- Built-in spacing and styling consistency
- Responsive design support
- Customizable dividers and separators

**Example:**
```dart
final section = SectionComposer()
  .withTitle('Recently Played')
  .withSubtitle('Your listening history')
  .withAction(
    text: 'View All',
    onPressed: () => navigateToHistory(),
  )
  .withContent(
    child: ResponsiveGrid(
      children: recentTracks.map((track) => TrackCard(track: track)).toList(),
      crossAxisCount: ResponsiveValue(xs: 1, sm: 2, md: 3, lg: 4, xl: 5),
    ),
  )
  .withSpacing(SectionSpacing.comfortable)
  .withDivider(true)
  .build();
```

### CardComposer

A composer for creating complex card layouts.

**Features:**
- Multi-section card layouts
- Flexible content arrangement
- Built-in card variants and styling
- Support for overlays and badges
- Customizable aspect ratios and sizing

**Example:**
```dart
final complexCard = CardComposer()
  .withLayout(CardLayout.featured)
  .withMedia(
    imageUrl: 'https://example.com/album-art.jpg',
    aspectRatio: 16 / 9,
  )
  .withHeader(
    title: 'New Release',
    subtitle: 'Artist Name • 2024',
    badge: 'New',
  )
  .withContent(
    sections: [
      CardSection(
        title: 'About',
        child: Text('Album description...'),
      ),
      CardSection(
        title: 'Tracks',
        child: Column(
          children: trackList.map((track) => TrackItem(track: track)).toList(),
        ),
      ),
    ],
  )
  .withFooter(
    actions: [
      IconButton(onPressed: () {}, icon: Icon(Icons.share)),
      IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
      ElevatedButton(onPressed: () {}, child: Text('Play Album')),
    ],
  )
  .build();
```

## Factories

### WidgetFactory

A factory for creating widgets dynamically based on type.

**Features:**
- Dynamic widget creation based on type strings
- Consistent widget configuration and styling
- Support for custom widget builders
- Error handling for unknown widget types
- Type-safe widget creation with generics

**Example:**
```dart
final factory = WidgetFactory();

// Register custom widget types
factory.registerWidgetType(
  'custom_card',
  (data) => CustomCard.fromData(data),
);

// Create widgets dynamically
final widgets = factory.createWidgets([
  WidgetConfig(type: 'music_tile', data: {'title': 'Song', 'artist': 'Artist'}),
  WidgetConfig(type: 'playlist_card', data: {'title': 'Playlist', 'count': '25'}),
  WidgetConfig(type: 'loading_state', data: {'state': 'loading'}),
]);
```

### CardFactory

A factory for creating specific card types.

**Features:**
- Pre-configured card types for music content
- Consistent styling and behavior
- Easy customization and extension
- Integration with existing card widgets

**Example:**
```dart
final factory = CardFactory();

// Create different card types
final playlistCard = factory.createPlaylistCard(
  title: 'My Playlist',
  trackCount: '25 tracks',
  imageUrl: 'https://example.com/playlist.jpg',
  accentColor: DesignSystem.primary,
  onTap: () => navigateToPlaylist(),
);

final artistCard = factory.createArtistCard(
  name: 'Artist Name',
  genre: 'Pop',
  followerCount: '1.2M followers',
  imageUrl: 'https://example.com/artist.jpg',
  onTap: () => navigateToArtist(),
);
```

### StateFactory

A factory for creating state displays.

**Features:**
- Pre-configured state displays for music app scenarios
- Consistent styling and behavior
- Easy customization and extension
- Integration with existing state widgets

**Example:**
```dart
final factory = StateFactory();

// Create different state displays
final loadingState = factory.createLoadingState(
  message: 'Loading your music...',
  showProgress: true,
);

final emptyState = factory.createEmptyState(
  type: EmptyStateType.playlist,
  actionText: 'Create Playlist',
  onActionPressed: () => createNewPlaylist(),
);
```

## Best Practices

### 1. Consistency
- Always use the design system constants for colors, spacing, and typography
- Follow consistent naming conventions for widget properties
- Use the same patterns across similar widgets

### 2. Performance
- Use `const` constructors where possible
- Avoid unnecessary widget rebuilds
- Consider using `ListView.builder` for large lists

### 3. Accessibility
- Provide proper semantic labels for screen readers
- Ensure sufficient color contrast
- Support both touch and keyboard navigation

### 4. Responsiveness
- Use `ResponsiveLayout` for adaptive designs
- Test on multiple screen sizes
- Consider both portrait and landscape orientations

### 5. Error Handling
- Provide fallback content for error states
- Use appropriate error messages for different scenarios
- Include retry mechanisms where applicable

## Migration Guide

### From Direct Widget Usage

**Before:**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Title', style: TextStyle(fontSize: 18)),
        Text('Subtitle', style: TextStyle(fontSize: 14)),
        // ... more widgets
      ],
    ),
  ),
)
```

**After:**
```dart
CardBuilder()
  .withVariant(CardVariant.primary)
  .withPadding(EdgeInsets.all(DesignSystem.spacingMD))
  .withHeader(
    title: 'Title',
    subtitle: 'Subtitle',
  )
  .withContent(
    child: // ... your content
  )
  .build()
```

### From Custom State Management

**Before:**
```dart
if (isLoading) {
  return CircularProgressIndicator();
} else if (hasError) {
  return Column(
    children: [
      Icon(Icons.error),
      Text('Error message'),
      ElevatedButton(onPressed: onRetry, child: Text('Retry')),
    ],
  );
} else if (items.isEmpty) {
  return Text('No items');
} else {
  return ListView.builder(/* ... */);
}
```

**After:**
```dart
StateBuilder()
  .withState(isLoading ? StateType.loading : (hasError ? StateType.error : (items.isEmpty ? StateType.empty : StateType.success)))
  .withLoadingMessage('Loading...')
  .withErrorMessage('Error message')
  .withEmptyMessage('No items')
  .withOnRetry(onRetry)
  .build()
```

## Testing

### Unit Tests

```dart
test('CardBuilder creates card with correct properties', () {
  final card = CardBuilder()
    .withVariant(CardVariant.primary)
    .withTitle('Test Card')
    .build();

  expect(card, isA<Card>());
  // Add more specific assertions
});
```

### Widget Tests

```dart
testWidgets('CardBuilder responds to tap', (WidgetTester tester) async {
  var tapped = false;

  await tester.pumpWidget(
    MaterialApp(
      home: CardBuilder()
        .withOnTap(() => tapped = true)
        .withContent(child: Text('Tap me'))
        .build(),
    ),
  );

  await tester.tap(find.text('Tap me'));
  expect(tapped, isTrue);
});
```

## Contributing

When adding new composition patterns:

1. Follow the existing directory structure
2. Maintain consistency with the design system
3. Add comprehensive documentation and examples
4. Include proper error handling
5. Write unit tests for new functionality
6. Update this README with new patterns

## Support

For questions or issues with the widget composition patterns, please:

1. Check the examples in this documentation
2. Review the existing widget implementations
3. Consult the design system documentation
4. Create an issue with detailed information about your use case