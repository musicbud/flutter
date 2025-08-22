# MusicBud Design System

A comprehensive Flutter design system based on Figma designs, providing reusable components, consistent theming, and design tokens for the MusicBud application.

## 🎨 Overview

This design system transforms the Figma-to-Flutter code into organized, maintainable, and reusable Flutter components. It follows Material Design 3 principles while maintaining the unique visual identity of MusicBud.

## 🏗️ Architecture

```
lib/presentation/
├── constants/
│   └── app_theme.dart          # Theme constants and design tokens
├── widgets/
│   └── common/                 # Reusable component library
│       ├── app_button.dart     # Button components
│       ├── app_card.dart       # Card components
│       ├── app_input_field.dart # Input field components
│       └── app_typography.dart # Typography showcase
└── pages/
    └── theme_showcase_page.dart # Component demonstration
```

## 🎯 Design Tokens

### Colors

The design system uses a carefully crafted color palette:

#### Primary Colors
- `primaryPink` (#FF6B8F) - Main brand color
- `primaryPinkDark` (#FF265A) - Darker variant
- `primaryPinkLight` (#D08A96) - Lighter variant

#### Secondary Colors
- `secondaryBlue` (#4B4685) - Secondary brand color
- `secondaryPurple` (#5B5D9F) - Purple accent
- `secondaryNavy` (#222C4D) - Navy accent

#### Neutral Colors
- `neutralWhite` (#FFFFFF) - Pure white
- `neutralLightGray` (#CFD0FD) - Light gray
- `neutralGray` (#CED0FC) - Medium gray
- `neutralDarkGray` (#18181F) - Dark gray
- `neutralBlack` (#0E0D11) - Pure black
- `neutralText` (#1D1D34) - Text color

#### Status Colors
- `successGreen` (#1B3719) - Success states
- `warningOrange` (#684D3F) - Warning states
- `errorRed` (#FF265A) - Error states

### Typography

The typography system uses the **Josefin Sans** font family with a mathematical scale of 1.250:

#### Display Text
- `displayH1` - 107px, Weight 500
- `displayH2` - 86px, Weight 500
- `displayH3` - 69px, Weight 500
- `displayH4` - 55px, Weight 500
- `displayH5` - 44px, Weight 500

#### Headline Text
- `headlineH6` - 35px, Weight 400
- `headlineH7` - 28px, Weight 400

#### Body Text
- `bodyH8` - 23px, Weight 400, Height 1.30
- `bodyH9` - 18px, Weight 400, Height 1.67
- `bodyH10` - 14px, Weight 400, Height 1.79

#### Special Text
- `titleLarge` - 90px, Weight 400
- `titleMedium` - 50px, Weight 600
- `titleSmall` - 22px, Weight 500
- `caption` - 12px, Weight 400
- `overline` - 10px, Weight 400

### Spacing

The spacing system uses an 8px base unit:

- `spacingXS` - 4px
- `spacingS` - 8px
- `spacingM` - 12px
- `spacingL` - 16px
- `spacingXL` - 24px
- `spacingXXL` - 32px
- `spacingXXXL` - 48px
- `spacingHuge` - 72px
- `spacingMassive` - 96px

### Border Radius

- `radiusXS` - 4px
- `radiusS` - 8px
- `radiusM` - 12px
- `radiusL` - 16px
- `radiusXL` - 24px
- `radiusXXL` - 40px
- `radiusCircular` - 50px

## 🧩 Components

### AppButton

A versatile button component with multiple variants and sizes.

```dart
// Basic usage
AppButton(
  text: 'Click Me',
  onPressed: () => print('Button pressed'),
)

// With variant and size
AppButton(
  text: 'Primary Button',
  variant: AppButtonVariant.primary,
  size: AppButtonSize.large,
  onPressed: () => print('Button pressed'),
)

// Predefined button styles
AppButtons.primary(
  text: 'Primary',
  onPressed: () => print('Primary pressed'),
)

AppButtons.matchNow(
  text: 'Match Now',
  onPressed: () => print('Match now pressed'),
)

AppButtons.tag(
  text: 'Music',
  onPressed: () => print('Tag pressed'),
)
```

#### Button Variants
- `primary` - Filled button with primary color
- `secondary` - Outlined button with primary color
- `text` - Text button with primary color
- `ghost` - Semi-transparent button with border

#### Button Sizes
- `small` - 80x32px
- `medium` - 120x40px
- `large` - 160x48px
- `xlarge` - 200x56px

### AppCard

A flexible card component with multiple variants and styling options.

```dart
// Basic usage
AppCard(
  child: Text('Card content'),
)

// With variant
AppCard(
  variant: AppCardVariant.gradient,
  child: Text('Gradient card'),
)

// Predefined card styles
AppCards.musicTrack(
  child: AppCardComponents.musicTrackCard(
    imageUrl: 'https://example.com/image.jpg',
    title: 'Song Title',
    artist: 'Artist Name',
  ),
)

AppCards.profile(
  child: AppCardComponents.profileCard(
    imageUrl: 'https://example.com/avatar.jpg',
    name: 'John Doe',
    age: '25',
    location: 'New York',
  ),
)
```

#### Card Variants
- `default_` - Standard card with dark background
- `white` - White card with shadow
- `transparent` - Transparent background
- `glass` - Semi-transparent with border
- `gradient` - Gradient background
- `outlined` - Outlined border
- `bordered` - Colored border

### AppInputField

A comprehensive input field component with various styles and states.

```dart
// Basic usage
AppInputField(
  hintText: 'Enter text here',
  onChanged: (value) => print('Input: $value'),
)

// With label and validation
AppInputField(
  label: 'Email',
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
)

// Predefined input styles
AppInputs.search(
  hintText: 'Search for music...',
  onChanged: (value) => print('Searching: $value'),
)

AppInputs.chat(
  hintText: 'Type a message...',
  onSubmitted: (value) => print('Message: $value'),
)
```

#### Input Variants
- `default_` - Dark background with transparent border
- `light` - Light background with gray border
- `transparent` - Transparent background
- `glass` - Semi-transparent background

#### Input Sizes
- `small` - 40px height
- `medium` - 48px height
- `large` - 56px height
- `xlarge` - 64px height

### AppTypography

A showcase component for displaying all typography styles.

```dart
// Show all typography styles
AppTypography()

// Show typography scale
TypographyScale(
  baseSize: 18.0,
  scale: 1.250,
  levels: 10,
)
```

## 🎨 Theme Usage

### Light Theme

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  home: MyHomePage(),
)
```

### Dark Theme

```dart
MaterialApp(
  theme: AppTheme.darkTheme,
  home: MyHomePage(),
)
```

### Custom Theme

```dart
ThemeData(
  useMaterial3: true,
  fontFamily: AppTheme.fontFamily,
  primaryColor: AppTheme.primaryPink,
  scaffoldBackgroundColor: AppTheme.neutralBlack,
  // ... other theme properties
)
```

## 🚀 Getting Started

### 1. Import the Theme

```dart
import 'package:musicbud_flutter/presentation/constants/app_theme.dart';
```

### 2. Use Design Tokens

```dart
Container(
  color: AppTheme.primaryPink,
  padding: EdgeInsets.all(AppTheme.spacingL),
  child: Text(
    'Hello World',
    style: AppTheme.titleSmall,
  ),
)
```

### 3. Use Components

```dart
import 'package:musicbud_flutter/presentation/widgets/common/app_button.dart';
import 'package:musicbud_flutter/presentation/widgets/common/app_card.dart';

// In your widget
Column(
  children: [
    AppButton(
      text: 'Get Started',
      onPressed: () => print('Started'),
    ),
    AppCard(
      child: Text('Welcome to MusicBud!'),
    ),
  ],
)
```

## 📱 Component Showcase

To see all components in action, navigate to the `ThemeShowcasePage`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ThemeShowcasePage(),
  ),
);
```

This page demonstrates:
- All typography styles
- Color palette
- Button variants and sizes
- Card components
- Input field styles
- Spacing and border radius systems

## 🔧 Customization

### Extending the Theme

```dart
class CustomTheme extends AppTheme {
  static const Color customColor = Color(0xFF123456);

  static ThemeData get customTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryColor: customColor,
    // ... other customizations
  );
}
```

### Creating Custom Components

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: AppButtonSize.large,
      // Add custom styling
      backgroundColor: AppTheme.customColor,
    );
  }
}
```

## 📋 Best Practices

### 1. Use Design Tokens
Always use the predefined design tokens instead of hardcoded values:

```dart
// ✅ Good
padding: EdgeInsets.all(AppTheme.spacingL)
color: AppTheme.primaryPink

// ❌ Bad
padding: EdgeInsets.all(16.0)
color: Color(0xFFFF6B8F)
```

### 2. Leverage Predefined Components
Use the predefined component styles when possible:

```dart
// ✅ Good
AppButtons.primary(text: 'Submit', onPressed: submit)
AppCards.musicTrack(child: musicContent)

// ❌ Bad
AppButton(variant: AppButtonVariant.primary, ...)
AppCard(variant: AppCardVariant.outlined, ...)
```

### 3. Maintain Consistency
Use consistent spacing, typography, and colors throughout your app:

```dart
Column(
  children: [
    Text('Title', style: AppTheme.titleSmall),
    SizedBox(height: AppTheme.spacingM), // Consistent spacing
    Text('Content', style: AppTheme.caption),
  ],
)
```

### 4. Responsive Design
Use the spacing system for responsive layouts:

```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spacingXL,
    vertical: AppTheme.spacingL,
  ),
  child: child,
)
```

## 🐛 Troubleshooting

### Common Issues

1. **Font not loading**: Ensure Josefin Sans is included in your `pubspec.yaml`
2. **Colors not matching**: Verify you're using the correct theme (light vs dark)
3. **Component not rendering**: Check that all required parameters are provided

### Debug Mode

Enable debug mode to see component boundaries:

```dart
// In your main.dart
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: true,
      home: MyApp(),
    ),
  );
}
```

## 🤝 Contributing

When adding new components or modifying existing ones:

1. Follow the existing naming conventions
2. Use the design tokens consistently
3. Add comprehensive documentation
4. Include examples in the showcase page
5. Test across different screen sizes

## 📚 Additional Resources

- [Flutter Material Design](https://docs.flutter.dev/ui/material)
- [Material Design 3](https://m3.material.io/)
- [Figma Design Tokens](https://www.figma.com/developers/design-tokens)

## 📄 License

This design system is part of the MusicBud application and follows the same licensing terms.