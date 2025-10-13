# 🚀 MusicBud UI Components - Quick Start Guide

**Last Updated:** October 13, 2025

---

## 📦 **Import Statement**

```dart
import 'package:musicbud/presentation/widgets/imported/index.dart';
```

This single import gives you access to all 6 foundation components!

---

## 🎨 **ModernButton**

### Basic Usage
```dart
ModernButton(
  text: 'Click Me',
  onPressed: () => print('Clicked!'),
)
```

### With Icon
```dart
ModernButton(
  text: 'Save',
  icon: Icons.save,
  variant: ModernButtonVariant.primary,
  size: ModernButtonSize.large,
  onPressed: _saveData,
)
```

### Loading State
```dart
ModernButton(
  text: 'Processing...',
  isLoading: _isProcessing,
  onPressed: _process,
)
```

### Variants
- `ModernButtonVariant.primary` - Filled pink button
- `ModernButtonVariant.secondary` - Gray button
- `ModernButtonVariant.accent` - Cyan accent button
- `ModernButtonVariant.outline` - Outline only
- `ModernButtonVariant.text` - Text only
- `ModernButtonVariant.gradient` - Gradient background

---

## 📇 **ModernCard**

### Basic Card
```dart
ModernCard(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

### Elevated Card with Action
```dart
ModernCard(
  variant: ModernCardVariant.elevated,
  onTap: () => print('Card tapped'),
  child: Column(
    children: [
      Text('Title', style: MusicBudTypography.heading3),
      Text('Description', style: MusicBudTypography.bodyMedium),
    ],
  ),
)
```

### Variants
- `ModernCardVariant.elevated` - With shadow elevation
- `ModernCardVariant.filled` - Solid background
- `ModernCardVariant.outlined` - Border only

---

## ✏️ **ModernInputField**

### Basic Input
```dart
ModernInputField(
  labelText: 'Email',
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
)
```

### With Validation
```dart
ModernInputField(
  labelText: 'Password',
  obscureText: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  },
)
```

### With Controller
```dart
final _controller = TextEditingController();

ModernInputField(
  controller: _controller,
  labelText: 'Username',
  prefixIcon: Icons.person,
)
```

---

## ⏳ **LoadingIndicator**

### Simple Loading
```dart
LoadingIndicator()
```

### Custom Size and Color
```dart
LoadingIndicator(
  size: LoadingIndicatorSize.large,
  color: MusicBudColors.primaryRed,
)
```

### With Message
```dart
Column(
  children: [
    LoadingIndicator(),
    SizedBox(height: 16),
    Text('Loading...', style: MusicBudTypography.bodyMedium),
  ],
)
```

---

## 📭 **EmptyState**

### Basic Empty State
```dart
EmptyState(
  title: 'No Items Found',
  description: 'Try adjusting your search criteria',
  icon: Icons.search_off,
)
```

### With Action Button
```dart
EmptyState(
  title: 'No Messages',
  description: 'Start a conversation with your buds',
  icon: Icons.chat_bubble_outline,
  actionText: 'New Chat',
  onAction: () => _startNewChat(),
)
```

---

## ⚠️ **ErrorWidget**

### Basic Error
```dart
ErrorWidget(
  message: 'Failed to load data',
)
```

### With Retry
```dart
ErrorWidget(
  title: 'Connection Error',
  message: 'Unable to connect to server',
  onRetry: () => _retryConnection(),
)
```

---

## 🎨 **Using Design System**

### Colors
```dart
import 'package:musicbud/core/design_system/design_system.dart';

Container(
  color: MusicBudColors.primaryRed,
  child: Text(
    'Hello',
    style: TextStyle(color: MusicBudColors.textOnPrimary),
  ),
)
```

### Typography
```dart
Text('Heading', style: MusicBudTypography.heading1)
Text('Body', style: MusicBudTypography.bodyLarge)
Text('Label', style: MusicBudTypography.labelMedium)
```

### Spacing
```dart
Padding(
  padding: EdgeInsets.all(MusicBudSpacing.md), // 16px
  child: Column(
    children: [
      Text('First'),
      SizedBox(height: MusicBudSpacing.sm), // 8px
      Text('Second'),
    ],
  ),
)
```

---

## 🌓 **Dynamic Theming**

### Get Theme Service
```dart
import 'package:musicbud/services/dynamic_theme_service.dart';

final themeService = DynamicThemeService.instance;
```

### Switch Theme
```dart
// Switch to dark theme
await themeService.setThemeMode(ThemeMode.dark);

// Switch to light theme
await themeService.setThemeMode(ThemeMode.light);

// Use system theme
await themeService.setThemeMode(ThemeMode.system);
```

### Check Current Theme
```dart
final currentTheme = themeService.currentThemeName; // 'light', 'dark', or 'system'
final themeMode = themeService.themeMode;
```

---

## 📐 **Complete Example**

```dart
import 'package:flutter/material.dart';
import 'package:musicbud/presentation/widgets/imported/index.dart';
import 'package:musicbud/core/design_system/design_system.dart';

class ExampleScreen extends StatefulWidget {
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Success!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MusicBudSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Welcome',
              style: MusicBudTypography.heading1,
            ),
            SizedBox(height: MusicBudSpacing.md),
            
            // Card with form
            ModernCard(
              variant: ModernCardVariant.elevated,
              child: Padding(
                padding: EdgeInsets.all(MusicBudSpacing.lg),
                child: Column(
                  children: [
                    ModernInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: MusicBudSpacing.lg),
                    ModernButton(
                      text: 'Submit',
                      variant: ModernButtonVariant.primary,
                      size: ModernButtonSize.large,
                      isFullWidth: true,
                      isLoading: _isLoading,
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
            
            // Loading indicator
            if (_isLoading) ...[
              SizedBox(height: MusicBudSpacing.xl),
              LoadingIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 🔗 **Useful Links**

- **Full Analysis:** `UI_UX_COMPONENT_ANALYSIS.md`
- **Implementation Summary:** `PHASE_1_2_IMPLEMENTATION_SUMMARY.md`  
- **Component Index:** `lib/presentation/widgets/imported/index.dart`
- **Design System:** `lib/core/design_system/design_system.dart`

---

## 💡 **Tips & Best Practices**

1. **Always use design system tokens** instead of hardcoded values
2. **Leverage theme variants** for consistent visual hierarchy
3. **Use loading states** for async operations
4. **Implement proper error handling** with ErrorWidget
5. **Test both light and dark themes**
6. **Ensure accessibility** with semantic labels

---

**Happy Coding! 🎉**