# Round 10 Components - Quick Reference Card

## 🌟 Rating Components

```dart
// Star rating display/input
Rating(rating: 4.5, maxRating: 5, onRatingChanged: (r) {})

// Compact with number
CompactRating(rating: 4.5, size: 16.0)

// Score badge
ScoreDisplay(score: 85, maxScore: 100, size: ScoreSize.medium)

// Interactive bar
RatingBar(initialRating: 0.0, onRatingUpdate: (r) {})

// With label
LabeledRating(rating: 4.5, label: 'Rating', count: 1234)
```

---

## 🎚️ Toggle Components

```dart
// Modern switch with label
ModernToggle(
  value: true,
  onChanged: (v) {},
  label: 'Title',
  description: 'Description',
  style: ToggleStyle.adaptive,
)

// Custom animated toggle
CustomToggle(value: true, onChanged: (v) {})

// Multiple toggles
ToggleGroup(items: [ToggleItem(...), ...])

// Individual toggle item
ToggleItem(
  label: 'Title',
  value: true,
  onChanged: (v) {},
  icon: Icons.star,
)

// Compact button style
ToggleButton(
  value: true,
  onChanged: (v) {},
  icon: Icons.star,
  label: 'Label',
)

// Icon-only toggle
IconToggle(
  value: true,
  onChanged: (v) {},
  icon: Icons.star,
  activeIcon: Icons.star_filled,
)
```

---

## 📑 TabBar Components

```dart
// Modern tab bar (3 styles: pills, underline, filled)
ModernTabBar(
  tabs: ['Tab1', 'Tab2', 'Tab3'],
  currentIndex: 0,
  onTabChanged: (i) {},
  style: TabBarStyle.pills,
  isScrollable: false,
  tabIcons: [Icons.home, Icons.search, Icons.person],
  badges: [5, null, 2],
)

// Vertical side navigation
VerticalTabBar(
  tabs: ['Home', 'Library'],
  currentIndex: 0,
  onTabChanged: (i) {},
  tabIcons: [Icons.home, Icons.library_music],
)
```

---

## ➕ FAB Components

```dart
// Modern FAB with scale animation
ModernFAB(
  icon: Icons.add,
  onPressed: () {},
  label: 'Add', // Optional
)

// Rotating FAB
RotatingFAB(
  icon: Icons.add,
  rotatedIcon: Icons.close,
  onPressed: () {},
)

// Speed dial with multiple actions
SpeedDialFAB(
  icon: Icons.add,
  openIcon: Icons.close,
  actions: [
    SpeedDialAction(
      icon: Icons.playlist_add,
      label: 'Create Playlist',
      onPressed: () {},
    ),
  ],
)

// Morphing FAB
MorphingFAB(
  icon: Icons.add,
  onPressed: () {},
  label: 'Add',
  isExpanded: true,
)

// Pulsing FAB
PulsingFAB(
  icon: Icons.add,
  onPressed: () {},
  pulseColor: Colors.blue,
)
```

---

## ⏱️ Timeline Components

```dart
// Full timeline with icons
Timeline(
  events: [
    TimelineEvent(
      title: 'Title',
      description: 'Description',
      time: '2 hours ago',
      icon: Icons.star,
      color: Colors.blue,
    ),
  ],
  axis: Axis.vertical, // or Axis.horizontal
)

// Compact timeline
CompactTimeline(
  events: [
    CompactTimelineEvent(
      title: 'Title',
      subtitle: 'Subtitle',
      time: '2h ago',
      color: Colors.blue,
    ),
  ],
)

// Activity timeline with avatars
ActivityTimeline(
  activities: [
    Activity(
      userName: 'John Doe',
      userInitials: 'JD',
      action: 'shared a song',
      time: '5 min ago',
      avatarUrl: 'https://...',
      content: CustomWidget(),
    ),
  ],
)
```

---

## 🎨 Style Enums

```dart
// Toggle styles
ToggleStyle.material
ToggleStyle.adaptive
ToggleStyle.custom

// TabBar styles
TabBarStyle.pills      // Rounded pills with container
TabBarStyle.underline  // Classic underline
TabBarStyle.filled     // Filled background

// Score sizes
ScoreSize.small
ScoreSize.medium
ScoreSize.large
```

---

## 🎯 Common Patterns

### Rating System
```dart
Column(
  children: [
    LabeledRating(label: 'Rating', rating: 4.5, count: 1234),
    RatingBar(onRatingUpdate: (r) => print(r)),
    ScoreDisplay(score: 85, maxScore: 100),
  ],
)
```

### Settings List
```dart
ToggleGroup(
  items: [
    ToggleItem(
      label: 'Notifications',
      description: 'Push notifications',
      value: notifications,
      onChanged: (v) => setState(() => notifications = v),
      icon: Icons.notifications,
    ),
    ToggleItem(
      label: 'Auto-play',
      value: autoplay,
      onChanged: (v) => setState(() => autoplay = v),
      icon: Icons.play_arrow,
    ),
  ],
)
```

### Tabbed Content
```dart
Column(
  children: [
    ModernTabBar(
      tabs: ['All', 'Rock', 'Pop', 'Jazz'],
      currentIndex: tab,
      onTabChanged: (i) => setState(() => tab = i),
      style: TabBarStyle.pills,
    ),
    Expanded(child: TabContent(tab)),
  ],
)
```

### Speed Dial Actions
```dart
SpeedDialFAB(
  icon: Icons.add,
  actions: [
    SpeedDialAction(icon: Icons.playlist_add, label: 'Playlist', onPressed: () {}),
    SpeedDialAction(icon: Icons.upload, label: 'Upload', onPressed: () {}),
    SpeedDialAction(icon: Icons.share, label: 'Share', onPressed: () {}),
  ],
)
```

### Activity Feed
```dart
ActivityTimeline(
  activities: [
    Activity(
      userName: 'User 1',
      userInitials: 'U1',
      action: 'liked a song',
      time: '5m ago',
    ),
    Activity(
      userName: 'User 2',
      userInitials: 'U2',
      action: 'created playlist',
      time: '1h ago',
    ),
  ],
)
```

---

## 📦 Import

```dart
import 'package:musicbud_flutter/presentation/widgets/enhanced/enhanced_widgets.dart';
```

---

## ✨ Key Features

- ✅ **100% Null Safe**
- ✅ **Material 3 Design**
- ✅ **Design System Integrated**
- ✅ **Fully Documented**
- ✅ **Animation Support**
- ✅ **Customizable**
- ✅ **Production Ready**

---

*Quick reference for Round 10 components - 21 new widgets!*
