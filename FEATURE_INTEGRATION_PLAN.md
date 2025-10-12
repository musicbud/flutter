# Feature Integration Plan
## Analysis Summary

### ✅ **What We Have:**
- **Complete BLoC Architecture**: OnboardingBloc, EventBloc, StoryBloc, WatchPartyBloc
- **Domain/Repository Layer**: All repositories and models exist
- **Basic Onboarding Page**: Simple welcome screen exists
- **Navigation Infrastructure**: Enhanced navigation system in place

### ❌ **What's Missing:**
- **UI Screens**: Event, Story, WatchParty screens
- **Navigation Integration**: Routes and navigation hooks
- **Backend Mock Data**: API endpoints for new features
- **Main Navigation Access**: No way to reach these features

---

## Integration Plan

### 1. **Navigation Integration**

#### Add to Bottom Navigation (Home Screen Quick Actions)
```dart
// Add to _buildQuickActions in enhanced_home_screen.dart
- Events (navigate to /events)
- Stories (navigate to /stories) 
- Watch Party (navigate to /watch-party)
```

#### Routes to Add:
- `/onboarding` - Enhanced onboarding flow
- `/events` - Events list screen
- `/events/create` - Create event screen
- `/events/:id` - Event detail screen
- `/stories` - Stories feed screen
- `/stories/create` - Create story screen  
- `/watch-party` - Watch party list screen
- `/watch-party/create` - Create watch party screen
- `/watch-party/:id` - Watch party room screen

### 2. **UI Screens to Implement**

#### **Events Feature**
- `lib/presentation/screens/events/events_screen.dart` - Events list with filter tabs
- `lib/presentation/screens/events/create_event_screen.dart` - Create/edit events
- `lib/presentation/screens/events/event_detail_screen.dart` - Event details and RSVP
- `lib/presentation/screens/events/components/event_card.dart` - Event card component

#### **Stories Feature** 
- `lib/presentation/screens/stories/stories_screen.dart` - Stories feed
- `lib/presentation/screens/stories/create_story_screen.dart` - Create story
- `lib/presentation/screens/stories/components/story_card.dart` - Story card component
- `lib/presentation/screens/stories/components/story_viewer.dart` - Full-screen story viewer

#### **Watch Party Feature**
- `lib/presentation/screens/watch_party/watch_parties_screen.dart` - List of parties
- `lib/presentation/screens/watch_party/create_party_screen.dart` - Create watch party
- `lib/presentation/screens/watch_party/party_room_screen.dart` - Live watch party room
- `lib/presentation/screens/watch_party/components/party_card.dart` - Party list item
- `lib/presentation/screens/watch_party/components/chat_overlay.dart` - Party chat

#### **Enhanced Onboarding**
- `lib/presentation/screens/onboarding/enhanced_onboarding_screen.dart` - Multi-step onboarding
- `lib/presentation/screens/onboarding/steps/welcome_step.dart` - Welcome screen
- `lib/presentation/screens/onboarding/steps/preferences_step.dart` - Music preferences  
- `lib/presentation/screens/onboarding/steps/permissions_step.dart` - App permissions

### 3. **Backend API Endpoints**

#### **Events Endpoints**
- `GET /events` - List events with pagination
- `POST /events` - Create new event
- `GET /events/:id` - Get event details
- `PUT /events/:id` - Update event
- `DELETE /events/:id` - Delete event
- `POST /events/:id/rsvp` - RSVP to event
- `GET /events/my` - User's events
- `GET /events/upcoming` - Upcoming events

#### **Stories Endpoints**
- `GET /stories` - Get stories feed
- `POST /stories` - Create new story
- `POST /stories/:id/like` - Like/unlike story
- `POST /stories/:id/comment` - Comment on story
- `POST /stories/:id/share` - Share story
- `DELETE /stories/:id` - Delete story

#### **Watch Party Endpoints**
- `GET /watch-parties` - List watch parties
- `POST /watch-parties` - Create watch party
- `GET /watch-parties/:id` - Get party details
- `PUT /watch-parties/:id` - Update party
- `POST /watch-parties/:id/join` - Join party
- `POST /watch-parties/:id/leave` - Leave party
- `POST /watch-parties/:id/end` - End party
- `WebSocket /watch-parties/:id/sync` - Real-time sync
- `WebSocket /watch-parties/:id/chat` - Party chat

#### **Onboarding Endpoints**
- `GET /onboarding/steps` - Get onboarding steps
- `POST /onboarding/complete-step` - Complete step
- `POST /onboarding/skip-step` - Skip step
- `GET /onboarding/preferences` - Get user preferences
- `PUT /onboarding/preferences` - Update preferences
- `POST /onboarding/reset` - Reset onboarding

### 4. **Component Library Extensions**

Add to `lib/core/components/musicbud_components.dart`:

#### **Event Components**
- `EventCard` - Event list item with RSVP button
- `EventHeader` - Event detail header with cover image
- `RSVPButton` - Animated RSVP status button

#### **Story Components**  
- `StoryCard` - Story feed item with interactions
- `StoryViewer` - Full-screen story display
- `StoryCreator` - Story creation interface

#### **Watch Party Components**
- `PartyCard` - Watch party list item
- `PartyControls` - Media controls for host
- `PartyChat` - Chat interface overlay
- `ParticipantsList` - Live participants list

### 5. **Enhanced Navigation Updates**

#### Update `enhanced_main_screen.dart`:
Add conditional navigation items based on user preferences/features enabled.

#### Update Quick Actions Grid:
Replace static grid with dynamic feature-based actions including:
- Events (if enabled)
- Stories (if enabled)  
- Watch Party (if enabled)
- Original actions (Find Buds, Chat, Discover, Profile)

### 6. **Data Flow Integration**

#### **Home Screen Integration**
- Add "Upcoming Events" section
- Add "Latest Stories" carousel  
- Add "Active Watch Parties" section
- Update with real BLoC data

#### **Profile Screen Integration**
- Add "My Events" tab
- Add "My Stories" section
- Add "Watch Party History"

---

## Implementation Priority

### Phase 1: Core Screens (High Priority)
1. Events list screen with basic functionality
2. Stories feed screen  
3. Watch party list screen
4. Navigation integration to access these screens

### Phase 2: Creation Flows (Medium Priority)  
1. Create event screen
2. Create story screen
3. Create watch party screen
4. Enhanced onboarding flow

### Phase 3: Advanced Features (Low Priority)
1. Real-time watch party synchronization
2. Story viewer with animations
3. Event detail screens with maps/photos
4. Advanced filtering and search

---

## Technical Dependencies

### Required BLoC Integrations:
- Add EventBloc, StoryBloc, WatchPartyBloc to main.dart providers
- Register in injection container
- Handle state management in UI screens

### Mock Data Requirements:
- Sample events data with various types and dates
- Sample stories with media content
- Sample watch parties with different statuses
- Onboarding steps and preferences data

### Navigation Updates:
- Update DynamicNavigationService with new routes
- Add route guards for authenticated features  
- Handle deep linking for shareable content

This plan provides a comprehensive roadmap for integrating all missing features while maintaining the existing architecture and design system consistency.