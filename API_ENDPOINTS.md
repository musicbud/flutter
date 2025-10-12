# MusicBud Backend API Endpoints

## Base URL
```
Production: https://api.musicbud.com/v1
Development: http://localhost:8080/api/v1
Mock: http://localhost:3000/api/v1
```

## Authentication Endpoints

### POST /auth/login
**Description**: User login
**Request**:
```json
{
  "username": "string",
  "password": "string"
}
```
**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "string",
      "username": "string",
      "email": "string",
      "displayName": "string",
      "profileImageUrl": "string"
    },
    "tokens": {
      "accessToken": "string",
      "refreshToken": "string",
      "expiresAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

### POST /auth/register
**Description**: User registration
**Request**:
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "displayName": "string"
}
```

### POST /auth/refresh
**Description**: Refresh access token
**Request**:
```json
{
  "refreshToken": "string"
}
```

### POST /auth/logout
**Description**: User logout (invalidate tokens)

## User Profile Endpoints

### GET /users/me/profile
**Description**: Get current user's profile
**Response**:
```json
{
  "success": true,
  "data": {
    "id": "string",
    "username": "string",
    "displayName": "string",
    "bio": "string",
    "profileImageUrl": "string",
    "coverImageUrl": "string",
    "location": "string",
    "stats": {
      "followers": 0,
      "following": 0,
      "playlists": 0,
      "totalPlays": 0
    },
    "preferences": {
      "favoriteGenres": ["string"],
      "topArtists": ["string"],
      "discoveryMode": "aggressive|moderate|conservative"
    },
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

### PUT /users/me/profile
**Description**: Update current user's profile
**Request**:
```json
{
  "displayName": "string",
  "bio": "string",
  "location": "string",
  "preferences": {
    "favoriteGenres": ["string"],
    "discoveryMode": "aggressive|moderate|conservative"
  }
}
```

### GET /users/{userId}/profile
**Description**: Get another user's public profile

### GET /users/me/stats
**Description**: Get detailed user statistics
**Response**:
```json
{
  "success": true,
  "data": {
    "listening": {
      "totalMinutes": 0,
      "topGenres": [{"name": "string", "percentage": 0}],
      "topArtists": [{"name": "string", "plays": 0}],
      "topTracks": [{"name": "string", "plays": 0}]
    },
    "social": {
      "buddies": 0,
      "conversations": 0,
      "matches": 0
    },
    "activity": {
      "sessionsThisWeek": 0,
      "averageSessionLength": 0,
      "lastActivity": "2024-01-01T00:00:00Z"
    }
  }
}
```

## Home Feed Endpoints

### GET /home/feed
**Description**: Get personalized home feed
**Query Parameters**:
- `page` (int): Page number
- `limit` (int): Items per page (default: 20)
- `category` (string): Filter by category (music, movies, anime)

**Response**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "string",
        "type": "recommendation|activity|trending|new_release",
        "title": "string",
        "subtitle": "string",
        "imageUrl": "string",
        "actionUrl": "string",
        "metadata": {},
        "timestamp": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "hasMore": true
    }
  }
}
```

### GET /home/recommendations
**Description**: Get personalized recommendations
**Response**:
```json
{
  "success": true,
  "data": {
    "artists": [
      {
        "id": "string",
        "name": "string",
        "imageUrl": "string",
        "genres": ["string"],
        "matchScore": 0.95
      }
    ],
    "tracks": [
      {
        "id": "string",
        "title": "string",
        "artist": "string",
        "imageUrl": "string",
        "previewUrl": "string",
        "matchScore": 0.88
      }
    ],
    "genres": [
      {
        "name": "string",
        "matchScore": 0.75,
        "topArtists": ["string"]
      }
    ]
  }
}
```

### GET /home/activity
**Description**: Get recent activity feed
**Response**:
```json
{
  "success": true,
  "data": {
    "activities": [
      {
        "id": "string",
        "type": "liked_track|new_buddy|shared_playlist|joined_room",
        "user": {
          "id": "string",
          "displayName": "string",
          "profileImageUrl": "string"
        },
        "content": {
          "title": "string",
          "subtitle": "string",
          "imageUrl": "string"
        },
        "timestamp": "2024-01-01T00:00:00Z"
      }
    ]
  }
}
```

## Buds/Matching Endpoints

### GET /buds/matches
**Description**: Get potential music buddies
**Query Parameters**:
- `type` (string): Matching type (artists, tracks, genres, all)
- `limit` (int): Number of matches (default: 20)
- `distance` (int): Max distance in km (optional)

**Response**:
```json
{
  "success": true,
  "data": {
    "matches": [
      {
        "user": {
          "id": "string",
          "displayName": "string",
          "profileImageUrl": "string",
          "location": "string",
          "bio": "string",
          "isOnline": true,
          "lastSeen": "2024-01-01T00:00:00Z"
        },
        "compatibility": {
          "overall": 0.92,
          "artists": 0.88,
          "tracks": 0.94,
          "genres": 0.90
        },
        "commonItems": {
          "artists": ["string"],
          "tracks": ["string"],
          "genres": ["string"]
        },
        "distance": 12.5
      }
    ]
  }
}
```

### POST /buds/match-request
**Description**: Send a buddy request
**Request**:
```json
{
  "targetUserId": "string",
  "message": "string"
}
```

### GET /buds/requests
**Description**: Get incoming/outgoing buddy requests
**Query Parameters**:
- `type` (string): incoming, outgoing, or all

### PUT /buds/requests/{requestId}/respond
**Description**: Respond to a buddy request
**Request**:
```json
{
  "action": "accept|decline",
  "message": "string"
}
```

## Chat Endpoints

### GET /chat/conversations
**Description**: Get user's conversations
**Response**:
```json
{
  "success": true,
  "data": {
    "conversations": [
      {
        "id": "string",
        "type": "direct|group",
        "participants": [
          {
            "id": "string",
            "displayName": "string",
            "profileImageUrl": "string",
            "isOnline": true
          }
        ],
        "lastMessage": {
          "id": "string",
          "content": "string",
          "sender": "string",
          "timestamp": "2024-01-01T00:00:00Z"
        },
        "unreadCount": 0,
        "isPinned": false,
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ]
  }
}
```

### POST /chat/conversations
**Description**: Create new conversation
**Request**:
```json
{
  "participantIds": ["string"],
  "type": "direct|group",
  "title": "string"
}
```

### GET /chat/conversations/{conversationId}/messages
**Description**: Get messages in conversation
**Query Parameters**:
- `page` (int): Page number
- `limit` (int): Messages per page
- `before` (string): Get messages before this message ID

### POST /chat/conversations/{conversationId}/messages
**Description**: Send message
**Request**:
```json
{
  "content": "string",
  "type": "text|image|audio|music_share",
  "metadata": {}
}
```

### PUT /chat/conversations/{conversationId}/read
**Description**: Mark conversation as read

## Content Endpoints

### GET /content/top-artists
**Description**: Get trending/top artists
**Query Parameters**:
- `timeframe` (string): week, month, year, all_time
- `genre` (string): Filter by genre
- `limit` (int): Number of results

**Response**:
```json
{
  "success": true,
  "data": {
    "artists": [
      {
        "id": "string",
        "name": "string",
        "imageUrl": "string",
        "genres": ["string"],
        "followers": 0,
        "popularity": 0.95
      }
    ]
  }
}
```

### GET /content/top-tracks
**Description**: Get trending/top tracks
**Response**:
```json
{
  "success": true,
  "data": {
    "tracks": [
      {
        "id": "string",
        "title": "string",
        "artist": "string",
        "album": "string",
        "imageUrl": "string",
        "previewUrl": "string",
        "duration": 180000,
        "popularity": 0.92
      }
    ]
  }
}
```

### GET /content/search
**Description**: Search for content
**Query Parameters**:
- `q` (string): Search query
- `type` (string): artists, tracks, albums, users
- `limit` (int): Number of results

### POST /content/like
**Description**: Like a content item
**Request**:
```json
{
  "itemId": "string",
  "itemType": "artist|track|album"
}
```

### DELETE /content/like/{itemId}
**Description**: Unlike a content item

## WebSocket Events (Real-time)

### Connection
```
wss://api.musicbud.com/ws?token={accessToken}
```

### Events
- `message_received`: New chat message
- `user_online`: User came online
- `user_offline`: User went offline
- `match_found`: New buddy match
- `buddy_request`: New buddy request
- `now_playing`: User started playing music

## Error Responses

### Standard Error Format
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {}
  }
}
```

### Common Error Codes
- `UNAUTHORIZED`: Invalid or expired token
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `VALIDATION_ERROR`: Request validation failed
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `SERVER_ERROR`: Internal server error

## Rate Limiting

### Limits
- Authentication: 5 requests/minute
- General API: 100 requests/minute
- Real-time events: 1000 events/minute
- File uploads: 10 uploads/hour

### Headers
- `X-RateLimit-Limit`: Request limit
- `X-RateLimit-Remaining`: Remaining requests
- `X-RateLimit-Reset`: Reset time (Unix timestamp)