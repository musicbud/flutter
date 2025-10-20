# BLoC Widgets Migration Guide

## Overview

This guide helps you migrate from the **legacy BLoC widgets** (in `lib/presentation/widgets/common/`) to the **enhanced BLoC widgets** (in `lib/widgets/`).

**Legacy Widgets** (❌ Old):
- `BlocForm` → Uses `AppConstants`, `PageMixin`, `AppButton`
- `BlocList` → Uses `AppConstants`, `PageMixin`
- `BlocTabView` → Uses `AppConstants`, `PageMixin`

**Enhanced Widgets** (✅ New):
- `BlocFormWidget` → Uses `Theme.of(context)`, `SnackbarUtils`, `ModernButton`
- `BlocListWidget` → Uses `Theme.of(context)`, `SnackbarUtils`
- `BlocTabViewWidget` → Uses `Theme.of(context)`, pure Flutter

---

## Why Migrate?

### Benefits of Enhanced Widgets

| Feature | Legacy | Enhanced | Improvement |
|---------|--------|----------|-------------|
| **Theme Integration** | Hardcoded colors | Material 3 theming | ✅ Better consistency |
| **Code Reduction** | ~200 lines/component | ~70 lines/component | ✅ 66% less boilerplate |
| **Analyzer Errors** | Multiple warnings | Zero errors | ✅ Clean code |
| **Documentation** | Minimal | Comprehensive | ✅ Better DX |
| **Customization** | Limited | Highly flexible | ✅ More options |
| **Maintainability** | Coupled | Decoupled | ✅ Easier updates |

---

## Migration Checklist

### Before You Start

- [  ] Read this entire guide
- [  ] Review `docs/bloc_widgets_usage_examples.md` for examples
- [  ] Identify which screens use legacy widgets (see [Finding Usage](#finding-usage))
- [  ] Start with simple screens first

### For Each Screen

- [  ] Create a git branch for the migration
- [  ] Update imports
- [  ] Migrate widget API
- [  ] Test functionality
- [  ] Run `flutter analyze`
- [  ] Commit changes

---

## Finding Usage

### Find Screens Using Legacy BLoC Widgets

```bash
# Find BlocForm usage
grep -r "BlocForm<" lib/ --include="*.dart"

# Find BlocList usage
grep -r "BlocList<" lib/ --include="*.dart"

# Find BlocTabView usage
grep -r "BlocTabView<" lib/ --include="*.dart"
```

---

## Migration Instructions

## 1. Migrating from BlocForm → BlocFormWidget

### Old API (Legacy)

```dart
import 'package:musicbud_flutter/presentation/widgets/common/bloc_form.dart';

class MyFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocForm<MyBloc, MyState, MyEvent>(
      title: 'Edit Profile',
      fields: [
        BlocFormField(
          key: 'name',
          label: 'Name',
          hint: 'Enter your name',
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        BlocFormField(
          key: 'email',
          label: 'Email',
          hint: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
        ),
      ],
      submitButtonText: 'Save',
      onSubmit: (values) => UpdateProfileEvent(
        name: values['name']!,
        email: values['email']!,
      ),
      isLoading: (state) => state is MyLoadingState,
      isSuccess: (state) => state is MySuccessState,
      isError: (state) => state is MyErrorState,
      getErrorMessage: (state) => (state as MyErrorState).message,
      onSuccess: () => Navigator.of(context).pop(),
    );
  }
}
```

### New API (Enhanced)

```dart
import 'package:musicbud_flutter/widgets/enhanced_bloc_widgets.dart';
import 'package:musicbud_flutter/presentation/widgets/enhanced/inputs/modern_input_field.dart';

class MyFormScreen extends StatefulWidget {
  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocFormWidget<MyBloc, MyState>(
        formKey: _formKey,
        formFields: (context) => [
          ModernInputField(
            controller: _nameController,
            labelText: 'Name',
            hintText: 'Enter your name',
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          ModernInputField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
        ],
        submitButtonText: 'Save',
        onSubmit: (context) {
          if (_formKey.currentState!.validate()) {
            context.read<MyBloc>().add(
              UpdateProfileEvent(
                name: _nameController.text,
                email: _emailController.text,
              ),
            );
          }
        },
        isLoading: (state) => state is MyLoadingState,
        isSuccess: (state) => state is MySuccessState,
        isError: (state) => state is MyErrorState,
        getErrorMessage: (state) => (state as MyErrorState).message,
        onSuccess: (context, state) => Navigator.of(context).pop(),
      ),
    );
  }
}
```

### Key Changes

| Aspect | Legacy | Enhanced |
|--------|--------|----------|
| **Import** | `presentation/widgets/common/bloc_form.dart` | `widgets/enhanced_bloc_widgets.dart` |
| **Widget Type** | `StatelessWidget` | `StatefulWidget` (for controllers) |
| **Form Key** | Auto-managed | You manage `GlobalKey<FormState>` |
| **Field Controllers** | String-based map | Explicit `TextEditingController` |
| **Fields Definition** | `BlocFormField` objects | `formFields: (context) => [...]` |
| **Field Widgets** | `AppTextField` (auto-generated) | `ModernInputField` (explicit) |
| **Submit Event** | Returns event from callback | Manually dispatch with `context.read` |
| **Scaffold** | Included (optional) | You provide `Scaffold` |
| **AppBar** | Included (optional) | You provide `AppBar` |

### Migration Steps

1. **Change import**:
   ```dart
   // OLD
   import 'package:musicbud_flutter/presentation/widgets/common/bloc_form.dart';
   
   // NEW
   import 'package:musicbud_flutter/widgets/enhanced_bloc_widgets.dart';
   import 'package:musicbud_flutter/presentation/widgets/enhanced/inputs/modern_input_field.dart';
   ```

2. **Convert to StatefulWidget** (if not already):
   ```dart
   class MyFormScreen extends StatefulWidget {
     @override
     State<MyFormScreen> createState() => _MyFormScreenState();
   }
   ```

3. **Add controllers and form key**:
   ```dart
   class _MyFormScreenState extends State<MyFormScreen> {
     final _formKey = GlobalKey<FormState>();
     final _nameController = TextEditingController();
     final _emailController = TextEditingController();
     
     @override
     void dispose() {
       _nameController.dispose();
       _emailController.dispose();
       super.dispose();
     }
   ```

4. **Wrap with Scaffold** (the new widget doesn't include it):
   ```dart
   return Scaffold(
     appBar: AppBar(title: const Text('Title')),
     body: BlocFormWidget<MyBloc, MyState>(
       // ...
     ),
   );
   ```

5. **Replace `BlocForm` with `BlocFormWidget`** and update parameters:
   - Remove `title` parameter (move to AppBar)
   - Change `fields:` to `formFields: (context) => [...]`
   - Replace `BlocFormField` with `ModernInputField`
   - Update `onSubmit` to dispatch events manually
   - Add `formKey` parameter

---

## 2. Migrating from BlocList → BlocListWidget

### Old API (Legacy)

```dart
import 'package:musicbud_flutter/presentation/widgets/common/bloc_list.dart';

BlocList<SongsBloc, SongsState, SongsEvent, Song>(
  title: 'My Songs',
  loadEvent: LoadSongsEvent(),
  refreshEvent: RefreshSongsEvent(),
  getItems: (state) => state is SongsLoadedState ? state.songs : [],
  isLoading: (state) => state is SongsLoadingState,
  isError: (state) => state is SongsErrorState,
  getErrorMessage: (state) => (state as SongsErrorState).message,
  itemBuilder: (context, song, index) => ListTile(
    title: Text(song.title),
    subtitle: Text(song.artist),
  ),
  emptyTitle: 'No songs',
  emptySubtitle: 'Add some songs to get started',
)
```

### New API (Enhanced)

```dart
import 'package:musicbud_flutter/widgets/enhanced_bloc_widgets.dart';

Scaffold(
  appBar: AppBar(title: const Text('My Songs')),
  body: BlocListWidget<SongsBloc, SongsState, Song>(
    getItems: (state) => state is SongsLoadedState ? state.songs : [],
    isLoading: (state) => state is SongsLoadingState,
    isError: (state) => state is SongsErrorState,
    getErrorMessage: (state) => (state as SongsErrorState).message,
    itemBuilder: (context, song) => ListTile(
      title: Text(song.title),
      subtitle: Text(song.artist),
    ),
    onRefresh: () async {
      context.read<SongsBloc>().add(RefreshSongsEvent());
      await Future.delayed(const Duration(seconds: 1));
    },
    emptyMessage: 'No songs\nAdd some songs to get started',
  ),
)
```

### Key Changes

| Aspect | Legacy | Enhanced |
|--------|--------|----------|
| **Import** | `presentation/widgets/common/bloc_list.dart` | `widgets/enhanced_bloc_widgets.dart` |
| **Event Type** | Fourth generic parameter | Not needed |
| **Load Event** | `loadEvent:` parameter | Dispatch in `initState` or provider |
| **Refresh Event** | `refreshEvent:` parameter | `onRefresh: () async {...}` callback |
| **Item Builder** | 3 parameters `(context, item, index)` | 2 parameters `(context, item)` |
| **Empty State** | `emptyTitle`, `emptySubtitle`, `emptyIcon` | `emptyMessage` or `emptyWidget` |
| **Scaffold** | Included | You provide `Scaffold` |
| **AppBar** | Included (via `title`) | You provide `AppBar` |

### Migration Steps

1. **Change import**

2. **Remove event generic parameter**:
   ```dart
   // OLD
   BlocList<MyBloc, MyState, MyEvent, MyItem>(...)
   
   // NEW
   BlocListWidget<MyBloc, MyState, MyItem>(...)
   ```

3. **Wrap with Scaffold** and move title to AppBar:
   ```dart
   Scaffold(
     appBar: AppBar(title: const Text('Title')),
     body: BlocListWidget<MyBloc, MyState, MyItem>(
       // ...
     ),
   )
   ```

4. **Remove `loadEvent`** and dispatch it manually:
   ```dart
   // In your widget's initState or BlocProvider.create:
   BlocProvider(
     create: (_) => MyBloc()..add(LoadItemsEvent()),
     child: BlocListWidget<MyBloc, MyState, MyItem>(
       // ...
     ),
   )
   ```

5. **Replace `refreshEvent` with `onRefresh` callback**:
   ```dart
   // OLD
   refreshEvent: RefreshItemsEvent(),
   
   // NEW
   onRefresh: () async {
     context.read<MyBloc>().add(RefreshItemsEvent());
     await Future.delayed(const Duration(seconds: 1));
   },
   ```

6. **Update `itemBuilder` signature**:
   ```dart
   // OLD
   itemBuilder: (context, item, index) => Widget,
   
   // NEW
   itemBuilder: (context, item) => Widget,
   ```

7. **Simplify empty state**:
   ```dart
   // OLD
   emptyTitle: 'No items',
   emptySubtitle: 'Add some items',
   emptyIcon: Icons.inbox,
   
   // NEW
   emptyMessage: 'No items\nAdd some items',
   // OR for custom widget:
   emptyWidget: CustomEmptyWidget(),
   ```

---

## 3. Migrating from BlocTabView → BlocTabViewWidget

### Old API (Legacy)

```dart
import 'package:musicbud_flutter/presentation/widgets/common/bloc_tab_view.dart';

BlocTabView<MyBloc, MyState, MyEvent>(
  title: 'Profile',
  tabs: [
    BlocTab<MyState, MyEvent>(
      title: 'Posts',
      icon: const Icon(Icons.grid_on),
      loadEvent: LoadPostsEvent(),
      isLoading: (state) => state is PostsLoadingState,
      builder: (context, state) {
        final posts = (state as PostsLoadedState).posts;
        return GridView.builder(...);
      },
    ),
    BlocTab<MyState, MyEvent>(
      title: 'Followers',
      loadEvent: LoadFollowersEvent(),
      builder: (context, state) => ListView(...),
    ),
  ],
)
```

### New API (Enhanced)

```dart
import 'package:musicbud_flutter/widgets/enhanced_bloc_widgets.dart';

BlocTabViewWidget(
  showAppBar: true,
  appBarTitle: 'Profile',
  tabs: [
    BlocTab<PostsBloc, PostsState>(
      title: 'Posts',
      icon: Icons.grid_on,
      blocProvider: () => PostsBloc()..add(LoadPostsEvent()),
      builder: (context, state) {
        if (state is PostsLoadedState) {
          return GridView.builder(...);
        }
        return Container();
      },
      isLoading: (state) => state is PostsLoadingState,
    ),
    BlocTab<FollowersBloc, FollowersState>(
      title: 'Followers',
      blocProvider: () => FollowersBloc()..add(LoadFollowersEvent()),
      builder: (context, state) {
        if (state is FollowersLoadedState) {
          return ListView(...);
        }
        return Container();
      },
      isLoading: (state) => state is FollowersLoadingState,
    ),
  ],
)
```

### Key Changes

| Aspect | Legacy | Enhanced |
|--------|--------|----------|
| **Import** | `presentation/widgets/common/bloc_tab_view.dart` | `widgets/enhanced_bloc_widgets.dart` |
| **BLoC Scope** | Shared BLoC across all tabs | **Independent BLoC per tab** |
| **Generic Parameters** | `<TBloc, TState, TEvent>` on widget | `<B, S>` on each `BlocTab` |
| **Title** | `title:` parameter | `appBarTitle:` or `showAppBar: false` |
| **BLoC Provider** | Must be provided by parent | Each tab has `blocProvider:` |
| **Load Event** | `loadEvent:` on tab | Included in `blocProvider: () => Bloc()..add(Event())` |
| **Icon** | `icon: Widget` | `icon: IconData` |

### Migration Steps

1. **Change import**

2. **Each tab needs its own BLoC now**:
   ```dart
   // OLD: One BLoC shared across tabs
   BlocProvider(
     create: (_) => ProfileBloc(),
     child: BlocTabView<ProfileBloc, ProfileState, ProfileEvent>(...)
   )
   
   // NEW: Each tab has independent BLoC
   BlocTabViewWidget(
     tabs: [
       BlocTab<PostsBloc, PostsState>(
         blocProvider: () => PostsBloc(),
         ...
       ),
       BlocTab<FollowersBloc, FollowersState>(
         blocProvider: () => FollowersBloc(),
         ...
       ),
     ],
   )
   ```

3. **Update generic parameters**:
   ```dart
   // OLD
   BlocTabView<ProfileBloc, ProfileState, ProfileEvent>(
     tabs: [
       BlocTab<ProfileState, ProfileEvent>(...)
     ],
   )
   
   // NEW
   BlocTabViewWidget(
     tabs: [
       BlocTab<PostsBloc, PostsState>(...)
     ],
   )
   ```

4. **Move `title` to `appBarTitle`**:
   ```dart
   // OLD
   BlocTabView(title: 'Profile', ...)
   
   // NEW
   BlocTabViewWidget(showAppBar: true, appBarTitle: 'Profile', ...)
   ```

5. **Add `blocProvider` to each tab**:
   ```dart
   BlocTab<MyBloc, MyState>(
     title: 'Tab Name',
     blocProvider: () => MyBloc()..add(LoadDataEvent()),
     builder: (context, state) => ...,
   )
   ```

6. **Convert icon from Widget to IconData**:
   ```dart
   // OLD
   icon: const Icon(Icons.grid_on),
   
   // NEW
   icon: Icons.grid_on,
   ```

7. **Remove `loadEvent`** (it's now in blocProvider):
   ```dart
   // OLD
   loadEvent: LoadPostsEvent(),
   
   // NEW (inside blocProvider)
   blocProvider: () => PostsBloc()..add(LoadPostsEvent()),
   ```

---

## Common Pitfalls

### 1. Forgetting to Dispose Controllers

**❌ Wrong**:
```dart
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();
  // Missing dispose!
}
```

**✅ Correct**:
```dart
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 2. Not Wrapping with Scaffold

**❌ Wrong**:
```dart
// Enhanced widgets don't include Scaffold
BlocFormWidget<MyBloc, MyState>(...)
```

**✅ Correct**:
```dart
Scaffold(
  appBar: AppBar(title: const Text('Title')),
  body: BlocFormWidget<MyBloc, MyState>(...),
)
```

### 3. Wrong Item Builder Signature

**❌ Wrong**:
```dart
// Legacy had 3 parameters
itemBuilder: (context, item, index) => Widget,
```

**✅ Correct**:
```dart
// Enhanced has 2 parameters
itemBuilder: (context, item) => Widget,
```

### 4. Forgetting to Validate Forms

**❌ Wrong**:
```dart
onSubmit: (context) {
  // Submitting without validation!
  context.read<MyBloc>().add(SubmitEvent(...));
}
```

**✅ Correct**:
```dart
onSubmit: (context) {
  if (_formKey.currentState!.validate()) {
    context.read<MyBloc>().add(SubmitEvent(...));
  }
}
```

### 5. Shared BLoC in Tab View

**❌ Wrong** (Using shared BLoC like legacy):
```dart
BlocProvider(
  create: (_) => ProfileBloc(),
  child: BlocTabViewWidget(...), // Won't work!
)
```

**✅ Correct** (Each tab has its own BLoC):
```dart
BlocTabViewWidget(
  tabs: [
    BlocTab<PostsBloc, PostsState>(
      blocProvider: () => PostsBloc(),
      ...
    ),
  ],
)
```

---

## Testing After Migration

### Checklist

- [  ] Widget builds without errors
- [  ] Form submission works correctly
- [  ] Validation displays errors
- [  ] Loading states show correctly
- [  ] Success snackbars appear
- [  ] Error snackbars appear
- [  ] Pull-to-refresh works (lists)
- [  ] Infinite scroll works (lists)
- [  ] Tab switching works
- [  ] Navigation after success works
- [  ] Run `flutter analyze` with zero errors

### Testing Commands

```bash
# Run analyzer
flutter analyze lib/

# Run tests
flutter test

# Check for deprecated usage
grep -r "presentation/widgets/common/bloc_" lib/ --include="*.dart"
```

---

## Example: Complete Migration

### Before (Legacy)

```dart
// lib/presentation/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/common/bloc_form.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocForm<ProfileBloc, ProfileState, ProfileEvent>(
      title: 'Edit Profile',
      fields: [
        BlocFormField(
          key: 'name',
          label: 'Name',
          hint: 'Your name',
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        BlocFormField(
          key: 'bio',
          label: 'Bio',
          hint: 'About you',
          maxLines: 3,
        ),
      ],
      submitButtonText: 'Save',
      onSubmit: (values) => UpdateProfileEvent(
        name: values['name']!,
        bio: values['bio'],
      ),
      isLoading: (state) => state is ProfileLoadingState,
      isSuccess: (state) => state is ProfileSuccessState,
      isError: (state) => state is ProfileErrorState,
      getErrorMessage: (state) => (state as ProfileErrorState).message,
      onSuccess: () => Navigator.of(context).pop(),
    );
  }
}
```

### After (Enhanced)

```dart
// lib/presentation/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/enhanced_bloc_widgets.dart';
import '../../widgets/enhanced/inputs/modern_input_field.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocFormWidget<ProfileBloc, ProfileState>(
        formKey: _formKey,
        formFields: (context) => [
          ModernInputField(
            controller: _nameController,
            labelText: 'Name',
            hintText: 'Your name',
            prefixIcon: Icons.person,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          ModernInputField(
            controller: _bioController,
            labelText: 'Bio',
            hintText: 'About you',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
        ],
        submitButtonText: 'Save',
        onSubmit: (context) {
          if (_formKey.currentState!.validate()) {
            context.read<ProfileBloc>().add(
              UpdateProfileEvent(
                name: _nameController.text,
                bio: _bioController.text,
              ),
            );
          }
        },
        isLoading: (state) => state is ProfileLoadingState,
        isSuccess: (state) => state is ProfileSuccessState,
        isError: (state) => state is ProfileErrorState,
        getErrorMessage: (state) => (state as ProfileErrorState).message,
        onSuccess: (context, state) => Navigator.of(context).pop(),
      ),
    );
  }
}
```

---

## Need Help?

### Resources

- **Usage Examples**: `docs/bloc_widgets_usage_examples.md`
- **Implementation Details**: `docs/bloc_widgets_implementation_summary.md`
- **Technical Analysis**: `docs/bloc_widgets_analysis_and_recommendations.md`

### Common Questions

**Q: Do I have to migrate all screens at once?**  
A: No! Migrate incrementally. Start with new screens or simple existing ones.

**Q: Can I use both legacy and enhanced widgets together?**  
A: Yes, they can coexist. Legacy widgets still work.

**Q: What if I need features not in the enhanced widgets?**  
A: The enhanced widgets are highly customizable. Check the usage examples first. If still missing, file an issue or extend the widget.

**Q: Is performance better with enhanced widgets?**  
A: Performance is comparable. The main benefits are developer experience and maintainability.

---

## Summary

### Migration Quick Reference

| Legacy | Enhanced | Key Difference |
|--------|----------|----------------|
| `BlocForm` | `BlocFormWidget` | Manual controllers, explicit Scaffold |
| `BlocList` | `BlocListWidget` | Manual event dispatch, explicit Scaffold |
| `BlocTabView` | `BlocTabViewWidget` | **Independent BLoC per tab** |

### Remember

✅ Add `Scaffold` and `AppBar` yourself  
✅ Manage `TextEditingController` lifecycle  
✅ Validate forms before submission  
✅ Each tab gets its own BLoC in `BlocTabViewWidget`  
✅ Test thoroughly after migration  

Happy migrating! 🎉
