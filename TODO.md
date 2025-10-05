# Project TODO List

**Generated:** $(date)

---

## 🔴 Critical TODOs (Blocking Compilation)

### Syntax Fixes
- [ ] Fix `lib/presentation/pages/search_page.dart` - Multiple missing brackets
- [ ] Fix `lib/presentation/pages/library_page.dart` - Missing closing brace at line 155
- [ ] Fix `lib/presentation/pages/profile_page.dart` - Missing closing parenthesis at line 49
- [ ] Fix `lib/blocs/match/match_bloc.dart` - Complete rewrite needed (corrupted)

### Missing Files to Create
- [ ] Create `lib/data/data_sources/remote/admin_remote_data_source.dart`
- [ ] Create `lib/data/data_sources/remote/search_remote_data_source.dart`
- [ ] Create `lib/models/settings/settings_model.dart`
- [ ] Create `lib/constants/app_constants.dart`
- [ ] Create `lib/presentation/core/widgets/loading_indicator.dart`
- [ ] Create `lib/presentation/core/widgets/error_view.dart`

---

## 🟠 High Priority TODOs

### Dependency Injection Fixes
- [ ] Fix parameter names in `lib/injection_container.dart`
  - Line 310: `adminRemoteDataSource` → `remoteDataSource`
  - Line 372: `adminRepository` → `repository`
  - Line 377: `channelRepository` → `repository`
  - Line 382: `searchRepository` → `repository`
- [ ] Create `ApiConfig` class or fix reference
- [ ] Fix `DioClient` to `Dio` type mismatch at line 216

### Repository Fixes
- [ ] Fix `AdminRepositoryImpl.getAdminStats` return type
- [ ] Add optional parameters to `ChannelRepositoryImpl.getChannels`
- [ ] Add missing `message` parameters to error constructors in:
  - `admin_repository_impl.dart` (lines 42, 56, 70, 84)
  - `search_repository_impl.dart` (lines 40, 60, 74, 88, 102, 116)

### Type Definitions
- [ ] Create or import `ChannelSettings` type
- [ ] Create or import `ChannelStats` type
- [ ] Verify `AppTheme` is properly exported

---

## 🟡 Medium Priority TODOs

### Feature Implementation (Home Page)
- [ ] TODO: Implement `FetchMyProfile()` event in UserProfileBloc
- [ ] TODO: Implement `FetchFeaturedContent()` event in ContentBloc
- [ ] TODO: Implement `FetchRecentActivities()` event in ContentBloc
- [ ] TODO: Implement search functionality in home page
- [ ] TODO: Implement navigation to discover page
- [ ] TODO: Implement navigation to library page
- [ ] TODO: Implement track details navigation
- [ ] TODO: Implement activity card tap handler

### Bloc Fixes
- [ ] Fix `comprehensive_chat_bloc.dart` - `fold` method issue
- [ ] Fix `match_state.dart` - Remove default values from redirecting factory
- [ ] Add `type` getter to `Channel` model

---

## 🟢 Low Priority TODOs

### Code Quality
- [ ] Replace all `print()` statements with proper logging:
  - `lib/blocs/auth/login/login_bloc.dart`
  - `lib/blocs/discover/discover_bloc.dart`
  - `lib/blocs/match/match_bloc.dart`
  - `lib/legacy/blocs_old/profile/profile_bloc.dart`

### Cleanup
- [ ] Remove unused imports across the project
- [ ] Add `const` constructors where applicable
- [ ] Use initializing formals where appropriate
- [ ] Remove unused local variables

### Legacy Code
- [ ] Review and potentially remove `lib/legacy/` folder
- [ ] Or fix all legacy bloc dependencies

---

## 📋 Implementation Notes

### Home Page Events (Commented Out)
```dart
// TODO: Uncomment and implement these after fixing ContentBloc
// context.read<UserProfileBloc>().add(FetchMyProfile());
// context.read<ContentBloc>().add(FetchFeaturedContent());
// context.read<ContentBloc>().add(FetchRecentActivities());
```

### Missing Widget Implementations
- `LoadingIndicator` - Create a reusable loading widget
- `ErrorView` - Create a reusable error display widget

---

## 🎯 Immediate Action Plan

1. **Phase 1: Fix Syntax Errors** (30 min)
   - Fix search_page.dart
   - Fix library_page.dart
   - Fix profile_page.dart
   - Rewrite match_bloc.dart

2. **Phase 2: Create Missing Files** (20 min)
   - Create stub implementations for all missing files
   - Ensure they compile without errors

3. **Phase 3: Fix Dependency Injection** (15 min)
   - Fix all parameter name mismatches
   - Create missing type definitions

4. **Phase 4: Fix Repository Issues** (20 min)
   - Fix return types
   - Add missing parameters

5. **Phase 5: Code Quality** (30 min)
   - Remove unused imports
   - Replace print statements
   - Add const constructors

**Total Estimated Time:** ~2 hours

---

## 📊 Progress Tracking

- [ ] Phase 1: Syntax Errors (0/4 files)
- [ ] Phase 2: Missing Files (0/6 files)
- [ ] Phase 3: Dependency Injection (0/5 issues)
- [ ] Phase 4: Repository Issues (0/8 issues)
- [ ] Phase 5: Code Quality (0/4 categories)

**Overall Progress:** 0%
