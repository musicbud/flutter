# Dynamic Component System Guide

This guide explains how to use the new dynamic component system that combines the functionality of legacy pages with the modern styling of new pages.

## Overview

The component system provides three main components:
1. **BlocForm** - Dynamic forms with bloc integration
2. **BlocList** - Dynamic lists with pagination and pull-to-refresh
3. **BlocTabView** - Dynamic tab views with category support

## Components

### 1. BlocForm

A dynamic form component that integrates with BLoC pattern, providing modern styling with full functionality.

#### Features
- Automatic form validation
- BLoC state management integration
- Modern UI styling
- Custom error/success handling
- Form field configuration
- Built-in validators

#### Example Usage

```dart
BlocForm<RegisterBloc, RegisterState, RegisterEvent>(
  title: 'Create Account',
  fields: [
    BlocFormField(
      key: 'email',
      label: 'Email Address',
      validator: BlocFormField.emailValidator,
      prefixIcon: const Icon(Icons.email_outlined),
    ),
    BlocFormField(
      key: 'password',
      label: 'Password',
      obscureText: true,
      validator: BlocFormField.passwordValidator,
    ),
  ],
  submitButtonText: 'Register',
  onSubmit: (values) => RegisterSubmitted(
    email: values['email']!,
    password: values['password']!,
  ),
  isLoading: (state) => state is RegisterLoading,
  isSuccess: (state) => state is RegisterSuccess,
  isError: (state) => state is RegisterFailure,
  onSuccess: () => navigateTo('/home'),
)
```

#### Available Validators
- `BlocFormField.emailValidator`
- `BlocFormField.passwordValidator`
- `BlocFormField.usernameValidator`
- `BlocFormField.requiredValidator`
- `BlocFormField.confirmPasswordValidator`

### 2. BlocList

A dynamic list component with pagination, pull-to-refresh, and modern styling.

#### Features
- Automatic pagination
- Pull-to-refresh
- Loading states
- Error handling
- Empty state handling
- Custom item builders

#### Example Usage

```dart
BlocList<StoryBloc, StoryState, StoryEvent, Story>(
  title: 'Stories',
  loadEvent: StoriesRequested(page: 1),
  refreshEvent: StoriesRefreshRequested(),
  loadMoreEvent: StoriesLoadMoreRequested(),
  getItems: (state) => state is StoryLoaded ? state.stories : [],
  isLoading: (state) => state is StoryLoading,
  isLoadingMore: (state) => state is StoryLoadingMore,
  isError: (state) => state is StoryFailure,
  hasReachedEnd: (state) => state is StoryLoaded ? state.hasReachedEnd : false,
  itemBuilder: (context, story, index) => StoryCard(story: story),
)
```

### 3. BlocTabView & CategoryTabView

Dynamic tab view components with bloc integration and modern styling.

#### CategoryTabView Example

```dart
CategoryTabView<BudBloc, BudState, BudEvent, BudMatch>(
  title: 'Find Your Music Buds',
  categories: ['liked/artists', 'liked/tracks', 'top/artists'],
  getCategoryEvent: (category) => BudCategoryRequested(category),
  getItems: (state, category) {
    if (state is BudLoaded) {
      return state.buds.where((bud) => bud.category == category).toList();
    }
    return [];
  },
  isLoading: (state) => state is BudLoading,
  isError: (state) => state is BudFailure,
  itemBuilder: (context, bud, index) => BudCard(bud: bud),
  getCategoryTitle: (category) => category.split('/').join(' ').toTitleCase(),
)
```

#### Advanced BlocTabView Example

```dart
BlocTabView<BudBloc, BudState, BudEvent>(
  title: 'Music Buds',
  tabs: [
    BlocTab<BudState, BudEvent>(
      title: 'Liked Artists',
      icon: const Icon(Icons.favorite_outline),
      loadEvent: const BudCategoryRequested('liked/artists'),
      isLoading: (state) => state is BudLoading,
      isError: (state) => state is BudFailure,
      builder: (context, state) => BudsList(state: state),
    ),
    // Add more tabs...
  ],
)
```

## Migration from Legacy Pages

### Before (Legacy)
```dart
class SignUpPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          // Handle state changes manually
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const LoadingIndicator();
          }
          return Form(
            child: Column(
              children: [
                TextFormField(/* email field */),
                TextFormField(/* password field */),
                ElevatedButton(/* submit button */),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### After (Modern)
```dart
class RegisterPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return BlocForm<RegisterBloc, RegisterState, RegisterEvent>(
      title: 'Create Account',
      fields: [
        BlocFormField(
          key: 'email',
          label: 'Email Address',
          validator: BlocFormField.emailValidator,
        ),
        BlocFormField(
          key: 'password',
          label: 'Password',
          obscureText: true,
          validator: BlocFormField.passwordValidator,
        ),
      ],
      submitButtonText: 'Create Account',
      onSubmit: (values) => RegisterSubmitted(
        email: values['email']!,
        password: values['password']!,
      ),
      isLoading: (state) => state is RegisterLoading,
      isSuccess: (state) => state is RegisterSuccess,
      isError: (state) => state is RegisterFailure,
      onSuccess: () => navigateTo('/home'),
    );
  }
}
```

## Benefits

1. **Reduced Boilerplate**: Less repetitive code across pages
2. **Consistent Styling**: All components use the same modern design system
3. **Built-in Functionality**: Pagination, validation, error handling included
4. **Type Safety**: Full TypeScript/Dart type safety with generics
5. **Maintainability**: Centralized component logic
6. **Reusability**: Components can be used across different pages

## Best Practices

### 1. Form Validation
Always use the built-in validators or create custom ones:

```dart
// Custom validator
String? customValidator(String? value) {
  if (value == null || value.length < 3) {
    return 'Must be at least 3 characters';
  }
  return null;
}
```

### 2. State Management
Keep state management functions pure and predictable:

```dart
isLoading: (state) => state is MyLoadingState,
isError: (state) => state is MyErrorState,
getItems: (state) => state is MyLoadedState ? state.items : [],
```

### 3. Error Handling
Provide meaningful error messages:

```dart
getErrorMessage: (state) {
  if (state is MyFailureState) {
    switch (state.errorType) {
      case ErrorType.network:
        return 'Network error. Please check your connection.';
      case ErrorType.server:
        return 'Server error. Please try again later.';
      default:
        return 'An unknown error occurred.';
    }
  }
  return null;
},
```

### 4. Custom State Widgets
Use custom state widgets for complex scenarios:

```dart
customStateWidget: (state) {
  if (state is SpecialState) {
    return CustomWidget(data: state.data);
  }
  return null;
},
```

## Common Patterns

### 1. Master-Detail Pattern
```dart
// Master list
BlocList<ItemBloc, ItemState, ItemEvent, Item>(
  itemBuilder: (context, item, index) => ListTile(
    title: Text(item.name),
    onTap: () => navigateTo('/item/${item.id}'),
  ),
)

// Detail form
BlocForm<ItemBloc, ItemState, ItemEvent>(
  fields: [/* item fields */],
  onSubmit: (values) => ItemUpdateRequested(values),
)
```

### 2. Search with Results
```dart
Column(
  children: [
    // Search form
    BlocForm<SearchBloc, SearchState, SearchEvent>(
      showAppBar: false,
      fields: [
        BlocFormField(
          key: 'query',
          label: 'Search',
          onChanged: (value) => context.read<SearchBloc>().add(
            SearchQueryChanged(value),
          ),
        ),
      ],
    ),

    // Results list
    Expanded(
      child: SimpleBlocList<SearchBloc, SearchState, SearchResult>(
        getItems: (state) => state is SearchLoaded ? state.results : [],
        isLoading: (state) => state is SearchLoading,
        isError: (state) => state is SearchFailure,
        itemBuilder: (context, result, index) => SearchResultCard(result),
      ),
    ),
  ],
)
```

### 3. Tabbed Content with Forms
```dart
BlocTabView<ContentBloc, ContentState, ContentEvent>(
  tabs: [
    BlocTab(
      title: 'Edit',
      builder: (context, state) => BlocForm<ContentBloc, ContentState, ContentEvent>(
        showAppBar: false,
        fields: [/* form fields */],
        onSubmit: (values) => ContentUpdateRequested(values),
      ),
    ),
    BlocTab(
      title: 'Preview',
      builder: (context, state) => ContentPreview(state: state),
    ),
  ],
)
```

## Styling Customization

All components respect the `AppConstants` styling system:

```dart
// lib/presentation/constants/app_constants.dart
class AppConstants {
  static const Color primaryColor = Color(0xFFFF6B8F);
  static const Color backgroundColor = Colors.black;
  static const Color surfaceColor = Color.fromARGB(121, 59, 59, 59);
  // ... more styling constants
}
```

Components automatically use these constants for consistent theming across the app.

## Integration with Existing Code

The new components are designed to work alongside existing legacy code. You can gradually migrate pages one by one:

1. Start with simple forms (login, register)
2. Move to list pages (buds, stories)
3. Finally tackle complex tabbed pages

Each component is self-contained and doesn't affect other parts of the app.