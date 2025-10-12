# Flutter App Analysis - BLoCs and Backend Endpoints

## Screens Requiring Real Data

### 1. Home Screen (`home_screen.dart`)
**Current BLoCs**: MainScreenBloc, UserBloc  
**Data Needed**:
- User profile data ✅ (has UserBloc)
- Top tracks, artists, genres ✅ (has UserBloc) 
- Recommendations ❌ **MISSING BLOC**
- Recent activity ❌ **MISSING BLOC**

**Missing**:
- `RecommendationsBloc` - for personalized recommendations
- `RecentActivityBloc` - for recent listening/activity

### 2. Discover Screen (`discover_screen.dart`)
**Current BLoCs**: DiscoverBloc  
**Data Needed**:
- Featured artists ✅
- Trending tracks ✅
- New releases ✅
- Categories ✅

**Status**: ✅ Has DiscoverBloc

### 3. Buds Screen (`buds_screen.dart`)
**Current BLoCs**: BudBloc, BudMatchingBloc  
**Data Needed**:
- List of matched buds ✅
- Bud profiles ✅
- Common music taste ✅

**Status**: ✅ Has BudBloc and BudMatchingBloc

### 4. Library Screen (`library_screen.dart`)
**Current BLoCs**: LibraryBloc  
**Data Needed**:
- Liked tracks/artists/albums ✅
- Playlists ✅
- Downloads ✅
- Recent ✅

**Status**: ✅ Has LibraryBloc

### 5. Profile Screen (`profile_screen.dart`)
**Current BLoCs**: ProfileBloc  
**Data Needed**:
- User profile ✅
- Top items ✅
- Statistics ❌ **MISSING ENDPOINT**

**Missing**:
- User statistics endpoint

### 6. Chat Screen (`chat_screen.dart`)
**Current BLoCs**: ChatBloc, ChatScreenBloc, ChatRoomBloc  
**Data Needed**:
- Channels ✅
- Messages ✅
- Users ✅

**Status**: ✅ Has multiple chat BLoCs

### 7. Search Screen (`search_screen.dart`)
**Current BLoCs**: None apparent  
**Data Needed**:
- Search results ❌ **MISSING BLOC**
- Search suggestions ❌ **MISSING BLOC**
- Recent searches ❌ **MISSING BLOC**

**Missing**:
- `SearchBloc` - for search functionality

### 8. Settings Screen (`settings_screen.dart`)
**Current BLoCs**: SettingsBloc  
**Data Needed**:
- User preferences ✅
- Connected services ✅

**Status**: ✅ Has SettingsBloc

### 9. Artist Details Screen (`artist_details_screen.dart`)
**Current BLoCs**: ArtistBloc  
**Data Needed**:
- Artist info ✅
- Artist tracks ✅
- Artist albums ✅

**Status**: ✅ Has ArtistBloc

### 10. Track Details Screen (`track_details_screen.dart`)
**Current BLoCs**: None apparent  
**Data Needed**:
- Track info ❌ **MISSING BLOC**
- Track statistics ❌ **MISSING ENDPOINT**
- Related tracks ❌ **MISSING ENDPOINT**

**Missing**:
- `TrackDetailsBloc`
- Track details endpoint

## Summary of Missing Components

### Missing BLoCs (Need to Create)
1. **RecommendationsBloc** - For home screen recommendations
2. **RecentActivityBloc** - For recent activity tracking
3. **SearchBloc** - For search functionality
4. **TrackDetailsBloc** - For track details screen

### Missing Backend Endpoints (Need to Create)
1. **GET `/v1/recommendations/`** - Get personalized recommendations
2. **GET `/v1/activity/recent/`** - Get recent user activity
3. **GET `/v1/search/`** - Search for tracks/artists/albums
4. **GET `/v1/search/suggestions/`** - Get search suggestions
5. **GET `/v1/search/recent/`** - Get recent searches
6. **GET `/v1/track/<id>/`** - Get track details
7. **GET `/v1/track/<id>/related/`** - Get related tracks
8. **GET `/v1/user/statistics/`** - Get user statistics

### Existing But Need Verification
- Analytics endpoints (already exist in Django)
- Content endpoints (already exist in Django)

## Priority Order for Implementation

### Phase 1: Critical (For Home Screen)
1. Create `RecommendationsBloc` + backend endpoint
2. Create `RecentActivityBloc` + backend endpoint

### Phase 2: Important (For Search)
3. Create `SearchBloc` + backend endpoints

### Phase 3: Nice-to-Have (For Details)
4. Create `TrackDetailsBloc` + backend endpoints
5. Add user statistics endpoint
