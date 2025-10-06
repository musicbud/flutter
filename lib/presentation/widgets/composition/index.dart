// Widget Composition Patterns - Main Export File
//
// This file provides a centralized export for all widget composition patterns.
// Import this file to access all builders, composers, and factories.
//
// Usage:
// ```dart
// import 'package:musicbud_flutter/presentation/widgets/composition/index.dart';
//
// // Use any of the composition patterns
// final card = CardBuilder().withVariant(CardVariant.primary).build();
// final section = SectionComposer().withTitle('My Section').build();
// final playlistCard = CardFactory().createPlaylistCard(/* ... */);
// ```

// ===========================================================================
// BUILDERS
// ===========================================================================

export '../builders/card_builder.dart';
export '../builders/list_builder.dart';
export '../builders/state_builder.dart';

// ===========================================================================
// COMPOSERS
// ===========================================================================

export '../composers/responsive_layout.dart';
export '../composers/section_composer.dart';
export '../composers/card_composer.dart';

// ===========================================================================
// FACTORIES
// ===========================================================================

export '../factories/widget_factory.dart';
export '../factories/card_factory.dart';
export '../factories/state_factory.dart';

// ===========================================================================
// COMMON TYPES AND ENUMS
// ===========================================================================

// Re-export commonly used types for convenience
export '../builders/card_builder.dart' show CardVariant;
export '../builders/list_builder.dart' show ListLoadingState;
export '../builders/state_builder.dart' show StateType;
export '../composers/responsive_layout.dart' show ResponsiveBreakpoint, ResponsiveValue;
export '../composers/section_composer.dart' show SectionSpacing;
export '../composers/card_composer.dart' show CardLayout, CardSection;
export '../factories/state_factory.dart' show EmptyStateType, ErrorStateType;

// ===========================================================================
// CONVENIENCE EXTENSIONS
// ===========================================================================

// Extension for quick access to builders
extension WidgetCompositionExtensions on Widget {
  CardBuilder get card => CardBuilder().withContent(child: this);
  SectionComposer get section => SectionComposer().withContent(child: this);
}

// Extension for quick access to factory instances
extension FactoryExtensions on Type {
  static CardFactory get cards => CardFactory();
  static StateFactory get states => StateFactory();
  static WidgetFactory get widgets => WidgetFactory.instance();
}