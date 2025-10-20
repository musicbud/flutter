import 'package:flutter/material.dart';

/// Basic loading indicator - simple circular progress
/// For more advanced loading indicators, use LoadingIndicator from advanced_loading_indicator.dart
class BasicLoadingIndicator extends StatelessWidget {
  const BasicLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Alias for backwards compatibility
typedef SimpleLoadingIndicator = BasicLoadingIndicator;
