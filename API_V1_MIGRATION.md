# API v1 Migration Guide

## Overview

This document describes the migration from the legacy MusicBud API to the new FastAPI v1 backend API. The migration includes updates to endpoints, HTTP methods, and response schemas to align with the new backend implementation.

## Date: 2025

## Changes Made

### 1. API Configuration Updates (`lib/config/api_config.dart`)

#### Base URL Changes
- **Old**: `/api/` (various inconsistent paths)
- **New**: `/v1/` (consistent versioned API)

#### Endpoint Updates

##### User Profile Endpoints
- `GET /v1/users/profile` - Get current user profile (changed from POST to GET)
- `PUT /v1/users/profile` - Update user profile (changed from POST to PUT)
- `GET /v1/users/preferences` - Get user preferences
- `PUT /v1/users/preferences` - Update user preferences (changed from POST to PUT)
- `GET /v1/users/matching/preferences` - Get matching preferences
- `PUT /v1/users/matching/preferences` - Update matching preferences (changed from POST to PUT)

##### Settings Endpoints
- `GET /v1/users/settings` - Get user settings
- `PUT /v1/users/settings/notifications` - Update notification settings (changed from PATCH to PUT)
- `PUT /v1/users/settings/privacy` - Update privacy settings (changed from PATCH to PUT)
- `PUT /v1/users/settings/theme` - Update theme (changed from PATCH to PUT)
- `PUT /v1/users/settings/language` - Update language (changed from PATCH to PUT)

##### Public Discovery Endpoints
- `GET /v1/public/discover/featured-artists` - Get featured artists
- `GET /v1/public/discover/trending-tracks` - Get trending tracks
- `GET /v1/public/discover/new-releases` - Get new releases
- `GET /v1/public/discover/actions` - Get discover actions
- `GET /v1/public/discover/categories` - Get discover categories

##### Search Endpoints
- `GET /v1/search` - Perform search
- `GET /v1/search/suggestions` - Get search suggestions
- `GET /v1/search/recent` - Get recent searches
- `GET /v1/search/trending` - Get trending searches
- `GET /v1/search/tracks` - Search tracks
- `GET /v1/search/artists` - Search artists
- `GET /v1/search/albums` - Search albums
- `POST /v1/search/recent` - Save recent search
- `DELETE /v1/search/recent` - Clear recent searches

##### Bud Endpoints
- `POST /v1/buds/profile` - Get bud profile (still POST, requires bud_id in body)
- `POST /v1/buds/top/artists` - Get buds by top artists
- `POST /v1/buds/top/tracks` - Get buds by top tracks
- `POST /v1/buds/top/genres` - Get buds by top genres
- `POST /v1/buds/top/anime` - Get buds by top anime
- `POST /v1/buds/top/manga` - Get buds by top manga
- `POST /v1/buds/liked/artists` - Get buds by liked artists
- `POST /v1/buds/liked/tracks` - Get buds by liked tracks
- `POST /v1/buds/liked/genres` - Get buds by liked genres
- `POST /v1/buds/liked/albums` - Get buds by liked albums
- `POST /v1/buds/liked/aio` - Get buds by all in one
- `POST /v1/buds/played/tracks` - Get buds by played tracks
- `POST /v1/buds/artist` - Get buds by artist
- `POST /v1/buds/track` - Get buds by track
- `POST /v1/buds/genre` - Get buds by genre

##### Chat Endpoints
- `GET /v1/chat/channels` - Get all channels
- `GET /v1/chat/channels/{id}/` - Get specific channel
- `POST /v1/chat/channels/create` - Create channel
- `POST /v1/chat/send` - Send message
- `POST /v1/chat/channels/{id}/add-member` - Add channel member
- `GET /v1/chat/users` - Get chat users
- `GET /v1/chat/users/{username}/` - Get user chat
- `POST /v1/chat/delete` - Delete message
- `GET /v1/chat/channels/{id}/dashboard/` - Get channel dashboard
- `POST /v1/chat/channels/{id}/moderator` - Add moderator
- `POST /v1/chat/channels/{id}/kick/{user_id}/` - Kick user
- `POST /v1/chat/channels/{id}/block/{user_id}/` - Block user
- `POST /v1/chat/channels/{id}/invitation/handle` - Handle invitation

##### Auth Endpoints (mostly unchanged)
- `POST /v1/auth/login` - Login
- `POST /v1/auth/register` - Register
- `POST /v1/auth/refresh-token` - Refresh token
- `POST /v1/auth/logout` - Logout
- `GET /v1/auth/service-login` - Get service login URL
- `POST /v1/auth/spotify/connect` - Connect Spotify
- `POST /v1/auth/spotify/refresh-token` - Refresh Spotify token
- `POST /v1/auth/ytmusic/connect` - Connect YouTube Music
- `POST /v1/auth/ytmusic/refresh-token` - Refresh YouTube Music token
- `POST /v1/auth/lastfm/connect` - Connect Last.fm
- `POST /v1/auth/mal/connect` - Connect MyAnimeList

### 2. Data Source Updates

#### User Profile Remote Data Source
- Changed `getMyProfile()` from POST to GET
- Changed `updateProfile()` from POST to PUT
- Updated `updateLikes()` to use PUT instead of POST
- Updated `getMyLikedContent()` to fetch from preferences endpoint using GET

#### Search Remote Data Source
- Updated all search endpoints to use `/v1/search/*` prefix
- All search methods now use proper v1 endpoints

#### Settings Remote Data Source
- Updated base URL to `/v1/users/settings`
- Changed all PATCH methods to PUT for consistency with v1 API

#### Auth Remote Data Source
- No significant changes (already compatible)

#### Chat Remote Data Source
- Already using ApiConfig endpoints (no changes needed)

#### Bud Matching Remote Data Source
- Already using ApiConfig endpoints (no changes needed)

### 3. HTTP Method Changes

The following HTTP method changes were made to align with RESTful best practices:

| Operation | Old Method | New Method | Reason |
|-----------|-----------|-----------|--------|
| Get profile | POST | GET | Read operation should use GET |
| Update profile | POST | PUT | Full update should use PUT |
| Update preferences | POST | PUT | Full update should use PUT |
| Update settings | PATCH | PUT | Consistency with v1 API |
| Get preferences | POST | GET | Read operation should use GET |

### 4. Response Schema Changes

#### User Preferences Response
The preferences are now returned in a structured format:
```json
{
  "artists": [...],
  "tracks": [...],
  "genres": [...],
  "albums": [...]
}
```

Previously, pagination was used for content retrieval. In v1, preferences don't use pagination.

### 5. Deprecated Endpoints

The following endpoints have been marked as deprecated and removed:
- Legacy discover endpoints without `/public/` prefix
- Old API paths without version prefix
- Inconsistent endpoint naming conventions

## Testing

After migration:
1. Run `flutter analyze` to check for compilation errors
2. Test all API calls with the new backend
3. Verify authentication flow
4. Test profile updates
5. Test preferences updates
6. Test search functionality
7. Test discover features
8. Test bud matching
9. Test chat functionality

## Rollback Plan

If issues arise, the API configuration can be rolled back by:
1. Reverting `lib/config/api_config.dart` to the previous version
2. Reverting data source implementations to use old HTTP methods
3. Restarting the Flutter app

## Known Issues

1. Some backup files in `lib/presentation/screens/discover/backup/` had broken imports and were removed
2. Minor warnings about unused variables in blocs (non-critical)
3. Deprecated `.value` usage on Color objects in models (non-breaking)

## Future Work

1. Consider implementing response caching for frequently accessed endpoints
2. Add request retry logic for network failures
3. Implement proper error handling for all API responses
4. Add analytics to track API usage and performance
5. Consider implementing GraphQL for more efficient data fetching

## References

- FastAPI Backend Repository: `https://github.com/musicbud/backend.git`
- API Documentation: (to be added)
- Backend API v1 Implementation Date: 2025

## Contributors

- Migration completed by AI Assistant
- Backend API developed by MusicBud Team
