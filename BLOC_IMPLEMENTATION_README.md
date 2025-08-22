# Bloc Implementation for MusicBud Flutter App

This document describes the implementation of the Bloc pattern for handling API endpoints in the MusicBud Flutter application.

## Overview

The application now includes a comprehensive Bloc architecture that handles all the major API endpoints:

- **Authentication & Service Connection**
- **User Profile Management**
- **Bud Matching & Discovery**
- **Chat & Messaging**
- **Content Management**

## Architecture

The implementation follows Clean Architecture principles with the following layers:

```
Presentation Layer (UI + Blocs)
    ↓
Domain Layer (Repositories + Use Cases)
    ↓
Data Layer (Data Sources + Models)
    ↓
Network Layer (HTTP Client + API Config)
```

## Implemented Blocs

### 1. UserProfileBloc

**Purpose**: Manages user profile operations including fetching, updating, and managing user data.

**Events**:
- `FetchUserProfile(userId)` - Get profile of specific user
- `FetchMyProfile()` - Get current user's profile
- `UpdateUserProfile(updateRequest)` - Update current user's profile
- `UpdateUserLikes(likesData)` - Update user's likes
- `FetchUserLikedContent(contentType, userId)` - Get user's liked content
- `FetchMyLikedContent(contentType)` - Get current user's liked content
- `FetchUserTopContent(contentType, userId)` - Get user's top content
- `FetchMyTopContent(contentType)` - Get current user's top content
- `FetchUserPlayedTracks(userId)` - Get user's played tracks
- `FetchMyPlayedTracks()` - Get current user's played tracks

**States**:
- `UserProfileInitial` - Initial state
- `UserProfileLoading` - Loading state
- `UserProfileLoaded` - Profile loaded successfully
- `UserProfileUpdated` - Profile updated successfully
- `UserLikesUpdated` - Likes updated successfully
- `UserContentLoaded` - User content loaded
- `MyContentLoaded` - Current user content loaded
- `UserProfileError` - Error state

**Usage Example**:
```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserProfileBloc>(),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return CircularProgressIndicator();
          } else if (state is UserProfileLoaded) {
            return ProfileWidget(profile: state.userProfile);
          }
          return Container();
        },
      ),
    );
  }
}
```

### 2. BudMatchingBloc

**Purpose**: Handles bud matching operations including searching, profile viewing, and content comparison.

**Events**:
- `SearchBuds(query, filters)` - Search for buds
- `GetBudProfile(budId)` - Get bud profile
- `GetBudLikedContent(contentType, budId)` - Get bud's liked content
- `GetBudTopContent(contentType, budId)` - Get bud's top content
- `GetBudPlayedTracks(budId)` - Get bud's played tracks
- `GetBudCommonLikedContent(contentType, budId)` - Get common liked content
- `GetBudCommonTopContent(contentType, budId)` - Get common top content
- `GetBudCommonPlayedTracks(budId)` - Get common played tracks
- `GetBudSpecificContent(contentType, contentId, budId)` - Get specific content

**States**:
- `BudMatchingInitial` - Initial state
- `BudMatchingLoading` - Loading state
- `BudsSearchResults` - Search results loaded
- `BudProfileLoaded` - Bud profile loaded
- `BudContentLoaded` - Bud content loaded
- `BudCommonContentLoaded` - Common content loaded
- `BudSpecificContentLoaded` - Specific content loaded
- `BudMatchingError` - Error state

**Usage Example**:
```dart
class BudSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BudMatchingBloc>(),
      child: BlocBuilder<BudMatchingBloc, BudMatchingState>(
        builder: (context, state) {
          if (state is BudsSearchResults) {
            return ListView.builder(
              itemCount: state.buds.length,
              itemBuilder: (context, index) {
                return BudCard(bud: state.buds[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
```

### 3. ChatManagementBloc

**Purpose**: Manages chat operations including channels, messages, and user interactions.

**Events**:
- `GetChatHome()` - Get chat home data
- `GetChatUsers()` - Get chat users
- `GetChatChannels()` - Get chat channels
- `GetUserChat(username)` - Get user chat
- `GetChannelChat(channelId)` - Get channel chat
- `SendMessage(message, channelId, username)` - Send message
- `CreateChannel(channelData)` - Create new channel
- `GetChannelDashboard(channelId)` - Get channel dashboard
- `AddChannelMember(channelId, username)` - Add member to channel
- `AcceptUserInvitation(channelId, username)` - Accept invitation
- `KickUser(channelId, username)` - Kick user from channel
- `BlockUser(channelId, username)` - Block user
- `AddModerator(channelId, username)` - Add moderator
- `DeleteMessage(messageId, channelId)` - Delete message
- `HandleInvitation(channelId, username, accept)` - Handle invitation

**States**:
- `ChatManagementInitial` - Initial state
- `ChatManagementLoading` - Loading state
- `ChatHomeLoaded` - Chat home loaded
- `ChatUsersLoaded` - Chat users loaded
- `ChatChannelsLoaded` - Chat channels loaded
- `UserChatLoaded` - User chat loaded
- `ChannelChatLoaded` - Channel chat loaded
- `MessageSent` - Message sent successfully
- `ChannelCreated` - Channel created successfully
- `ChannelDashboardLoaded` - Channel dashboard loaded
- `ChannelMemberAdded` - Member added successfully
- `UserInvitationAccepted` - Invitation accepted
- `UserKicked` - User kicked successfully
- `UserBlocked` - User blocked successfully
- `ModeratorAdded` - Moderator added successfully
- `MessageDeleted` - Message deleted successfully
- `InvitationHandled` - Invitation handled
- `ChatManagementError` - Error state

**Usage Example**:
```dart
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatManagementBloc>(),
      child: BlocBuilder<ChatManagementBloc, ChatManagementState>(
        builder: (context, state) {
          if (state is ChatChannelsLoaded) {
            return ListView.builder(
              itemCount: state.channels.length,
              itemBuilder: (context, index) {
                return ChannelCard(channel: state.channels[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
```

## Repository Layer

Each bloc has a corresponding repository that abstracts the data layer:

### UserProfileRepository
- `getUserProfile(userId)` - Get user profile
- `getMyProfile()` - Get current user profile
- `updateProfile(updateRequest)` - Update profile
- `updateLikes(likesData)` - Update likes
- `getUserLikedContent(contentType, userId)` - Get liked content
- `getMyLikedContent(contentType)` - Get current user's liked content
- `getUserTopContent(contentType, userId)` - Get top content
- `getMyTopContent(contentType)` - Get current user's top content
- `getUserPlayedTracks(userId)` - Get played tracks
- `getMyPlayedTracks()` - Get current user's played tracks

### BudMatchingRepository
- `searchBuds(query, filters)` - Search for buds
- `getBudProfile(budId)` - Get bud profile
- `getBudLikedContent(contentType, budId)` - Get bud's liked content
- `getBudTopContent(contentType, budId)` - Get bud's top content
- `getBudPlayedTracks(budId)` - Get bud's played tracks
- `getBudCommonLikedContent(contentType, budId)` - Get common liked content
- `getBudCommonTopContent(contentType, budId)` - Get common top content
- `getBudCommonPlayedTracks(budId)` - Get common played tracks
- `getBudSpecificContent(contentType, contentId, budId)` - Get specific content

### ChatManagementRepository
- `getChatHome()` - Get chat home
- `getChatUsers()` - Get chat users
- `getChatChannels()` - Get chat channels
- `getUserChat(username)` - Get user chat
- `getChannelChat(channelId)` - Get channel chat
- `sendMessage(message, channelId, username)` - Send message
- `createChannel(channelData)` - Create channel
- `getChannelDashboard(channelId)` - Get channel dashboard
- `addChannelMember(channelId, username)` - Add member
- `acceptUserInvitation(channelId, username)` - Accept invitation
- `kickUser(channelId, username)` - Kick user
- `blockUser(channelId, username)` - Block user
- `addModerator(channelId, username)` - Add moderator
- `deleteMessage(messageId, channelId)` - Delete message
- `handleInvitation(channelId, username, accept)` - Handle invitation

## Data Sources

Each repository has a corresponding remote data source that handles HTTP API calls:

### UserProfileRemoteDataSource
- Handles all user profile API endpoints
- Uses DioClient for HTTP requests
- Maps API responses to domain models

### BudMatchingRemoteDataSource
- Handles all bud matching API endpoints
- Supports content type filtering
- Handles common content comparison

### ChatManagementRemoteDataSource
- Handles all chat-related API endpoints
- Manages channel operations
- Handles user interactions

## Models

### UserProfile
- `id`, `username`, `email`
- `firstName`, `lastName`, `birthday`, `gender`
- `interests`, `profilePicture`, `bio`
- `createdAt`, `updatedAt`, `isActive`
- `connectedServices`

### UserProfileUpdateRequest
- `firstName`, `lastName`, `birthday`, `gender`
- `interests`, `bio`

## Dependency Injection

All dependencies are registered in `injection_container.dart`:

```dart
// Data Sources
sl.registerLazySingleton<UserProfileRemoteDataSource>(
  () => UserProfileRemoteDataSourceImpl(dioClient: sl<DioClient>()),
);

// Repositories
sl.registerLazySingleton<UserProfileRepository>(
  () => UserProfileRepositoryImpl(remoteDataSource: sl<UserProfileRemoteDataSource>()),
);

// BLoCs
sl.registerFactory<UserProfileBloc>(() => UserProfileBloc(
  userProfileRepository: sl<UserProfileRepository>(),
));
```

## Usage in Pages

### Basic Bloc Integration
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyBloc>(),
      child: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          // Build UI based on state
        },
      ),
    );
  }
}
```

### BlocListener for Side Effects
```dart
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    if (state is MySuccessState) {
      // Show success message
    } else if (state is MyErrorState) {
      // Show error message
    }
  },
  child: BlocBuilder<MyBloc, MyState>(
    builder: (context, state) {
      // Build UI
    },
  ),
)
```

### Dispatching Events
```dart
// In a button onPressed
context.read<MyBloc>().add(MyEvent());

// Or with parameters
context.read<MyBloc>().add(MyEventWithParams(param: value));
```

## Error Handling

All blocs include comprehensive error handling:

1. **Network Errors**: Caught and converted to user-friendly messages
2. **Validation Errors**: Handled at the repository level
3. **State Management**: Error states are properly managed and displayed
4. **User Feedback**: SnackBars and dialogs for error notifications

## Testing

The Bloc architecture makes testing straightforward:

```dart
// Test events
blocTest<MyBloc, MyEvent, MyState>(
  'emits [MyLoading, MySuccess] when MyEvent is added',
  build: () => MyBloc(repository: mockRepository),
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [MyLoading(), MySuccess()],
);
```

## Best Practices

1. **Single Responsibility**: Each bloc handles one domain area
2. **Event-Driven**: All state changes are triggered by events
3. **Immutable States**: States are immutable and use Equatable
4. **Error Handling**: Comprehensive error handling at all levels
5. **Dependency Injection**: All dependencies are injected and testable
6. **Repository Pattern**: Abstracts data sources from business logic
7. **Clean Architecture**: Clear separation of concerns

## Next Steps

1. **Implement remaining blocs** for other API endpoints
2. **Add caching layer** for offline support
3. **Implement real-time updates** using WebSockets
4. **Add analytics** and error tracking
5. **Create comprehensive tests** for all blocs
6. **Add documentation** for each bloc's specific usage

## Conclusion

The Bloc implementation provides a robust, scalable architecture for handling all API endpoints in the MusicBud Flutter application. It follows best practices for state management, error handling, and testing, making the codebase maintainable and reliable.