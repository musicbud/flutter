# Login Redirect Fix

## Problem
After a successful login, the app was not redirecting users to the home screen. The user would remain on the login page even though the backend authentication succeeded and tokens were stored.

## Root Cause
The `MainScreenWithGuest` widget was only checking authentication status in `initState()`, which runs once when the widget is first created. When users logged in and the navigation popped back to `MainScreenWithGuest`, the authentication status was not being re-checked, so the UI remained in the "guest" state showing the login prompt.

## Solution
Implemented three key changes to `lib/presentation/screens/main_screen_with_guest.dart`:

### 1. Added WidgetsBindingObserver
```dart
class _MainScreenWithGuestState extends State<MainScreenWithGuest> with WidgetsBindingObserver
```
This allows the widget to observe app lifecycle changes and refresh authentication status when the app resumes.

### 2. Added Lifecycle Callbacks
```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  // Re-check auth status when app resumes
  if (state == AppLifecycleState.resumed) {
    _checkAuthStatus();
  }
}
```

### 3. Added Callback from Login Screen
Modified `GuestProfileScreen` to accept an `onAuthChanged` callback that:
- Waits for the login navigation to complete
- Re-checks authentication status
- Navigates to the home tab

```dart
onPressed: () async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
  // Trigger auth refresh after returning from login
  onAuthChanged?.call();
}
```

### 4. Navigate to Home After Login
Added a `_navigateToHome()` method that switches to the home tab (index 0) after successful authentication:

```dart
GuestProfileScreen(
  onAuthChanged: () {
    _checkAuthStatus();
    _navigateToHome();
  },
)
```

## Testing
To test the fix:

1. Run the app: `./run-flutter-fhs.sh`
2. Navigate to the Profile tab (should show guest login screen)
3. Tap "Sign In" button
4. Enter credentials (testuser / any_password based on your logs)
5. Tap Login button
6. **Expected Result**: After successful login, you should be:
   - Redirected back to the main screen
   - Authenticated state should be active
   - Home tab should be displayed
   - Profile tab should now show the actual profile instead of login prompt

## Files Modified
- `lib/presentation/screens/main_screen_with_guest.dart`

## Additional Notes
- The fix ensures auth state is refreshed both when returning from login and when app lifecycle changes
- No changes were needed to the `AuthBloc` or `LoginBloc` - the issue was purely in the UI layer
- The authentication flow (LoginBloc -> TokenProvider -> AuthBloc) was already working correctly
