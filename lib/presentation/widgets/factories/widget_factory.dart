import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../builders/index.dart';
import '../composers/index.dart';

/// A factory class for creating widgets dynamically based on type.
/// Provides a centralized way to create widgets with consistent configuration and styling.
///
/// **Features:**
/// - Dynamic widget creation based on type strings
/// - Consistent widget configuration and styling
/// - Support for custom widget builders
/// - Error handling for unknown widget types
/// - Integration with existing builders and composers
/// - Type-safe widget creation with generics
///
/// **Usage:**
/// ```dart
/// final factory = WidgetFactory();
///
/// // Register custom widget types
/// factory.registerWidgetType(
///   'custom_card',
///   (data) => CustomCard.fromData(data),
/// );
///
/// // Create widgets dynamically
/// final widget = factory.createWidget(
///   type: 'music_tile',
///   data: {'title': 'Song Title', 'artist': 'Artist'},
/// );
/// ```
class WidgetFactory {
  static WidgetFactory? _instance;
  final Map<String, WidgetBuilder> _builders = {};
  final Map<String, Widget Function(Map<String, dynamic>)> _dataBuilders = {};

  /// Private constructor for singleton pattern
  WidgetFactory._();

  /// Gets the singleton instance
  factory WidgetFactory.instance() {
    _instance ??= WidgetFactory._();
    return _instance!;
  }

  /// Registers a widget builder for a specific type
  void registerWidgetBuilder(String type, WidgetBuilder builder) {
    _builders[type] = builder;
  }

  /// Registers a data-based widget builder for a specific type
  void registerDataWidgetBuilder(
    String type,
    Widget Function(Map<String, dynamic>) builder,
  ) {
    _dataBuilders[type] = builder;
  }

  /// Creates a widget based on the provided type
  Widget? createWidget({
    required String type,
    Map<String, dynamic>? data,
    Key? key,
  }) {
    try {
      // Try data-based builder first
      if (data != null && _dataBuilders.containsKey(type)) {
        return _dataBuilders[type]!(data);
      }

      // Try standard builder
      if (_builders.containsKey(type)) {
        return _builders[type]!(key);
      }

      // Use built-in widget creation
      return _createBuiltInWidget(type, data, key);
    } catch (e) {
      return _createErrorWidget(type, e);
    }
  }

  /// Creates a list of widgets from a list of type configurations
  List<Widget> createWidgets(List<WidgetConfig> configs) {
    return configs.map((config) {
      return createWidget(
        type: config.type,
        data: config.data,
        key: config.key,
      ) ?? _createErrorWidget(config.type, 'Failed to create widget');
    }).toList();
  }

  Widget _createBuiltInWidget(String type, Map<String, dynamic>? data, Key? key) {
    switch (type) {
      case 'card':
        return _createCard(data, key);
      case 'list':
        return _createList(data, key);
      case 'state':
        return _createState(data, key);
      case 'section':
        return _createSection(data, key);
      case 'responsive_layout':
        return _createResponsiveLayout(data, key);
      case 'music_tile':
        return _createMusicTile(data, key);
      case 'playlist_card':
        return _createPlaylistCard(data, key);
      case 'loading_state':
        return _createLoadingState(data, key);
      default:
        throw UnsupportedError('Widget type "$type" is not supported');
    }
  }

  Widget _createCard(Map<String, dynamic>? data, Key? key) {
    final builder = CardBuilder();

    if (data != null) {
      if (data.containsKey('variant')) {
        builder.withVariant(_parseCardVariant(data['variant']));
      }
      if (data.containsKey('padding')) {
        builder.withPadding(_parseEdgeInsets(data['padding']));
      }
      if (data.containsKey('title')) {
        builder.withHeader(
          title: data['title'],
          subtitle: data['subtitle'],
        );
      }
      if (data.containsKey('onTap')) {
        builder.withOnTap(data['onTap'] as VoidCallback);
      }
    }

    return builder.build();
  }

  Widget _createList(Map<String, dynamic>? data, Key? key) {
    final builder = ListBuilder<String>();

    if (data != null) {
      if (data.containsKey('items')) {
        builder.withItems(List<String>.from(data['items']));
      }
      if (data.containsKey('loadingState')) {
        builder.withLoadingState(_parseLoadingState(data['loadingState']));
      }
      if (data.containsKey('emptyMessage')) {
        builder.withEmptyMessage(data['emptyMessage']);
      }
    }

    return builder.build();
  }

  Widget _createState(Map<String, dynamic>? data, Key? key) {
    final builder = StateBuilder();

    if (data != null) {
      if (data.containsKey('state')) {
        builder.withState(_parseStateType(data['state']));
      }
      if (data.containsKey('message')) {
        builder.withLoadingMessage(data['message']);
        builder.withEmptyMessage(data['message']);
        builder.withErrorMessage(data['message']);
      }
    }

    return builder.build();
  }

  Widget _createSection(Map<String, dynamic>? data, Key? key) {
    final composer = SectionComposer();

    if (data != null) {
      if (data.containsKey('title')) {
        composer.withTitle(data['title']);
      }
      if (data.containsKey('subtitle')) {
        composer.withSubtitle(data['subtitle']);
      }
      if (data.containsKey('actionText') && data.containsKey('onActionPressed')) {
        composer.withAction(
          text: data['actionText'],
          onPressed: data['onActionPressed'],
        );
      }
    }

    return composer.build();
  }

  Widget _createResponsiveLayout(Map<String, dynamic>? data, Key? key) {
    return ResponsiveLayout(
      key: key,
      builder: (context, breakpoint) {
        return Container(
          color: breakpoint.isMobile ? Colors.blue : Colors.green,
          child: Text('Responsive: ${breakpoint.name}'),
        );
      },
    );
  }

  Widget _createMusicTile(Map<String, dynamic>? data, Key? key) {
    // This would integrate with existing MusicTile widget
    return Container(
      key: key,
      padding: EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data?['title'] ?? 'Music Title',
            style: DesignSystem.titleMedium,
          ),
          SizedBox(height: DesignSystem.spacingXS),
          Text(
            data?['artist'] ?? 'Artist',
            style: DesignSystem.bodySmall.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPlaylistCard(Map<String, dynamic>? data, Key? key) {
    // This would integrate with existing PlaylistCard widget
    return Container(
      key: key,
      padding: EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: (data?['accentColor'] as Color?) ?? DesignSystem.primary,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
            ),
          ),
          SizedBox(height: DesignSystem.spacingMD),
          Text(
            data?['title'] ?? 'Playlist Title',
            style: DesignSystem.titleSmall,
          ),
          Text(
            data?['trackCount'] ?? '0 tracks',
            style: DesignSystem.caption,
          ),
        ],
      ),
    );
  }

  Widget _createLoadingState(Map<String, dynamic>? data, Key? key) {
    return LoadingStateWidget(
      key: key,
      state: data?['state'] == 'loading'
          ? LoadingState.loading
          : data?['state'] == 'error'
              ? LoadingState.error
              : LoadingState.empty,
      emptyMessage: data?['emptyMessage'],
      errorMessage: data?['errorMessage'],
      onRetry: data?['onRetry'],
    );
  }

  Widget _createErrorWidget(String type, Object error) {
    return Container(
      padding: EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: Border.all(color: DesignSystem.error),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: DesignSystem.error,
            size: 32,
          ),
          SizedBox(height: DesignSystem.spacingSM),
          Text(
            'Widget Error',
            style: DesignSystem.titleSmall.copyWith(
              color: DesignSystem.error,
            ),
          ),
          SizedBox(height: DesignSystem.spacingXS),
          Text(
            'Type: $type\nError: $error',
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper parsing methods
  CardVariant _parseCardVariant(dynamic value) {
    if (value is CardVariant) return value;
    if (value is String) {
      switch (value) {
        case 'primary':
          return CardVariant.primary;
        case 'secondary':
          return CardVariant.secondary;
        case 'accent':
          return CardVariant.accent;
        case 'outlined':
          return CardVariant.outlined;
        default:
          return CardVariant.primary;
      }
    }
    return CardVariant.primary;
  }

  EdgeInsetsGeometry _parseEdgeInsets(dynamic value) {
    if (value is EdgeInsetsGeometry) return value;
    if (value is double) return EdgeInsets.all(value);
    if (value is Map) {
      return EdgeInsets.only(
        left: value['left'] ?? 0,
        top: value['top'] ?? 0,
        right: value['right'] ?? 0,
        bottom: value['bottom'] ?? 0,
      );
    }
    return EdgeInsets.all(DesignSystem.spacingMD);
  }

  ListLoadingState _parseLoadingState(dynamic value) {
    if (value is ListLoadingState) return value;
    if (value is String) {
      switch (value) {
        case 'loading':
          return ListLoadingState.loading;
        case 'empty':
          return ListLoadingState.empty;
        case 'error':
          return ListLoadingState.error;
        default:
          return ListLoadingState.none;
      }
    }
    return ListLoadingState.none;
  }

  StateType _parseStateType(dynamic value) {
    if (value is StateType) return value;
    if (value is String) {
      switch (value) {
        case 'loading':
          return StateType.loading;
        case 'empty':
          return StateType.empty;
        case 'error':
          return StateType.error;
        case 'success':
          return StateType.success;
        default:
          return StateType.loading;
      }
    }
    return StateType.loading;
  }
}

/// Configuration class for widget creation
class WidgetConfig {
  final String type;
  final Map<String, dynamic>? data;
  final Key? key;

  const WidgetConfig({
    required this.type,
    this.data,
    this.key,
  });
}

/// Type definition for widget builders
typedef WidgetBuilder = Widget Function(Key? key);