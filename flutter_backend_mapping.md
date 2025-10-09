# Flutter App Components to Backend Endpoints Mapping

## Overview

This document maps Flutter app screens and components to their corresponding backend API endpoints. The MusicBud Flutter app follows a clean architecture pattern with BLoC state management and RESTful API integration.

## API Configuration

**Base URL:** `http://84.235.170.234`
**WebSocket URL:** `ws://84.235.170.234/ws/v1`
**Authentication:** Bearer token in Authorization header

## Screen-to-Endpoint Mapping

### 1. Home Screen (`lib/presentation/screens/home/`)

#### Components Using Dynamic Data:
- **HomeHeaderWidget**: Displays user profile information
- **HomeRecommendations**: Shows liked songs and top artists
- **HomeRecentActivity**: Displays recently played tracks

#### Backend Endpoints:
```
GET /me/profile
- Returns: User profile data (displayName, username, avatarUrl)
- Auth: Required
- Used by: HomeHeaderWidget, WelcomeCard

GET /me/liked/tracks?page=1
- Returns: Array of liked tracks with pagination
- Auth: Required
- Used by: HomeRecommendations (shows first 5)

GET /me/top/artists?page=1
- Returns: Array of top artists with pagination
- Auth: Required
- Used by: HomeRecommendations (shows first 5)

GET /me/played/tracks?page=1
- Returns: Array of recently played tracks with pagination
- Auth: Required
- Used by: HomeRecentActivity (shows first 5)
```

#### Static Data:
- **HomeQuickActions**: Navigation shortcuts (hardcoded actions)
  - Discover, My Library, Chat, Spotify Control, Find Buds, Connect Services

### 2. Profile Screen (`lib/presentation/screens/profile/`)

#### Components Using Dynamic Data:
- **ProfileHeaderWidget**: User profile information
- **ProfileMusicWidget**: Music statistics and preferences
- **ProfileActivityWidget**: Recent activity
- **ProfileSettingsWidget**: User settings

#### Backend Endpoints by Tab:

**Profile Tab:**
```
GET /me/profile
- Returns: Complete user profile data
- Auth: Required
- Used by: ProfileHeaderWidget
```

**Top Items Tab:**
```
GET /me/top/tracks?page=1
- Returns: User's top tracks
- Auth: Required

GET /me/top/artists?page=1
- Returns: User's top artists
- Auth: Required

GET /me/top/genres?page=1
- Returns: User's top genres
- Auth: Required
```

**Liked Items Tab:**
```
GET /me/liked/tracks?page=1
- Returns: User's liked tracks
- Auth: Required

GET /me/liked/artists?page=1
- Returns: User's liked artists
- Auth: Required

GET /me/liked/genres?page=1
- Returns: User's liked genres
- Auth: Required
```

**Buds Tab:**
- Currently placeholder - no API integration yet

### 3. Discover Screen (`lib/presentation/screens/discover/`)

#### Components Using Dynamic Data:
- **FeaturedArtistsSection**: Popular artists
- **TrendingTracksSection**: Trending music
- **NewReleasesSection**: Latest albums
- **DiscoverMoreSection**: Action cards (with fallback static data)

#### Backend Endpoints:
```
GET /discover/featured-artists
- Returns: Featured artists data
- Auth: Required
- Used by: FeaturedArtistsSection

GET /discover/trending-tracks
- Returns: Trending tracks
- Auth: Required
- Used by: TrendingTracksSection

GET /discover/new-releases
- Returns: New album releases
- Auth: Required
- Used by: NewReleasesSection

GET /discover/actions
- Returns: Discover action configurations
- Auth: Required
- Used by: DiscoverMoreSection (fallback to static data on error)
```

#### Static Data:
- **DiscoverMoreSection**: Fallback actions when API fails
  - Create Playlist, Follow Artists

### 4. Library Screen (`lib/presentation/screens/library/`)

#### Components Using Dynamic Data:
- **PlaylistsTab**: User playlists
- **LikedSongsTab**: Liked tracks
- **DownloadsTab**: Downloaded content
- **RecentlyPlayedTab**: Play history

#### Backend Endpoints:
```
GET /library/playlists
- Returns: User playlists
- Auth: Required
- Used by: PlaylistsTab

GET /library/liked
- Returns: Liked content
- Auth: Required
- Used by: LikedSongsTab

GET /library/downloads
- Returns: Downloaded content
- Auth: Required
- Used by: DownloadsTab

GET /library/recent
- Returns: Recently played items
- Auth: Required
- Used by: RecentlyPlayedTab
```

### 5. Buds Screen (`lib/presentation/screens/buds/`)

#### Components Using Dynamic Data:
- **BudMatchingBloc**: Handles all bud finding operations

#### Backend Endpoints:
```
POST /bud/top/artists
- Body: {page: 1}
- Returns: Users with similar top artists
- Auth: Required

POST /bud/top/tracks
- Body: {page: 1}
- Returns: Users with similar top tracks
- Auth: Required

POST /bud/top/genres
- Body: {page: 1}
- Returns: Users with similar top genres
- Auth: Required

POST /bud/top/anime
- Body: {page: 1}
- Returns: Users with similar top anime
- Auth: Required

POST /bud/top/manga
- Body: {page: 1}
- Returns: Users with similar top manga
- Auth: Required

POST /bud/liked/artists
- Body: {page: 1}
- Returns: Users with similar liked artists
- Auth: Required

POST /bud/liked/tracks
- Body: {page: 1}
- Returns: Users with similar liked tracks
- Auth: Required

POST /bud/liked/genres
- Body: {page: 1}
- Returns: Users with similar liked genres
- Auth: Required

POST /bud/liked/albums
- Body: {page: 1}
- Returns: Users with similar liked albums
- Auth: Required

POST /bud/liked/aio
- Body: {page: 1}
- Returns: Users with all similar preferences
- Auth: Required

POST /bud/played/tracks
- Body: {page: 1}
- Returns: Users with similar played tracks
- Auth: Required
```

### 6. Chat Screen (`lib/presentation/screens/chat/`)

#### Components Using Dynamic Data:
- **ComprehensiveChatBloc**: Manages chat functionality

#### Backend Endpoints:
```
GET /chat/channels/
- Returns: User's chat channels
- Auth: Required
- Used by: Channel list display

GET /chat/channel/messages/?channel_id={id}
- Returns: Messages for specific channel
- Auth: Required
- Used by: Message history

POST /chat/channel/send_message/
- Body: {channel_id: string, content: string}
- Returns: Sent message confirmation
- Auth: Required
- Used by: Message sending

POST /chat/user/send_message/
- Body: {user_id: string, content: string}
- Returns: Sent message confirmation
- Auth: Required
- Used by: Direct message sending
```

### 7. Authentication Flow

#### Backend Endpoints:
```
POST /login/
- Body: {username: string, password: string}
- Returns: JWT tokens
- Auth: None

POST /register/
- Body: {email: string, username: string, password: string}
- Returns: User creation confirmation
- Auth: None

POST /token/refresh/
- Body: {refresh: string}
- Returns: New access token
- Auth: None (uses refresh token)
```

### 8. Service Integration

#### Backend Endpoints:
```
POST /spotify/connect
- Body: {code: string}
- Returns: Spotify connection status
- Auth: Required

POST /lastfm/connect
- Body: {token: string}
- Returns: Last.fm connection status
- Auth: Required

POST /ytmusic/connect
- Body: {token: string}
- Returns: YouTube Music connection status
- Auth: Required

POST /mal/connect
- Body: {token: string}
- Returns: MyAnimeList connection status
- Auth: Required
```

## Data Flow Requirements

### Authentication
- All endpoints except login/register require Bearer token
- Token refresh handled automatically
- Failed auth requests trigger logout flow

### Pagination
- Most list endpoints support `?page={number}` parameter
- Default page size: 20 items
- Max page size: 100 items

### Error Handling
- HTTP 401: Token expired → refresh token or logout
- HTTP 403: Forbidden → show permission error
- HTTP 404: Not found → show appropriate message
- HTTP 500: Server error → show retry option

### Caching Strategy
- User profile: 1 hour cache
- Content lists: 30 minutes cache
- Static assets: No cache (CDN handled)

### Real-time Updates
- Chat messages: WebSocket connection
- Friend activity: Polling every 30 seconds
- Music playback: Real-time sync via Spotify API

## Missing Endpoints/Data Transformations

### Identified Gaps:

1. **Profile Statistics**
   - Missing: `/me/stats` for comprehensive user statistics
   - Current: Scattered across multiple endpoints

2. **Social Features**
   - Missing: `/buds/follow`, `/buds/unfollow` for bud relationships
   - Missing: `/feed` for social activity feed

3. **Content Details**
   - Missing: `/tracks/{id}/details` for full track information
   - Missing: `/artists/{id}/details` for artist biography/discography

4. **Search Functionality**
   - Partially implemented: `/search` exists but limited scope
   - Missing: Advanced filters, fuzzy search

5. **Analytics**
   - Basic: `/analytics` exists
   - Missing: Detailed listening history analytics

### Data Transformation Needs:

1. **Common Item Format**
   - Standardize track/artist/genre response format across endpoints
   - Current: Inconsistent field naming (name vs title, artistName vs artist)

2. **Pagination Response**
   - Standardize pagination metadata (total_count, has_next, etc.)
   - Current: Inconsistent pagination response format

3. **Error Response Format**
   - Standardize error response structure
   - Current: Varies by endpoint

## Recommendations

1. **API Standardization**
   - Implement consistent response formats
   - Add comprehensive error handling
   - Standardize pagination across all list endpoints

2. **Missing Features**
   - Add social following/unfollowing endpoints
   - Implement detailed content pages
   - Enhance search with filters and suggestions

3. **Performance Optimization**
   - Implement proper caching headers
   - Add endpoint for bulk data fetching
   - Optimize image loading with CDN

4. **Real-time Features**
   - Expand WebSocket usage beyond chat
   - Add push notifications for social interactions

This mapping provides a complete overview of the current API integration state and identifies areas for enhancement.