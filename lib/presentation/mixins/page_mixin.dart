import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin providing common page functionality
mixin PageMixin<T extends StatefulWidget> on State<T> {
  /// Shows a snack bar with the given message
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows an error snack bar
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 4),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows a success snack bar
  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// Shows a loading dialog
  void showLoadingDialog({String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  /// Hides the loading dialog
  void hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  /// Navigates to a new route
  void navigateTo(String route, {Object? arguments}) {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  /// Replaces the current route
  void replaceRoute(String route, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(route, arguments: arguments);
  }

  /// Navigates back
  void goBack() {
    Navigator.of(context).pop();
  }

  /// Navigates back to a specific route
  void goBackTo(String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  /// Gets the bloc from the context
  B getBloc<B extends BlocBase>() {
    return context.read<B>();
  }

  /// Gets the bloc state from the context
  S getBlocState<B extends BlocBase<S>, S>() {
    return context.read<B>().state;
  }

  /// Adds an event to a bloc
  void addBlocEvent<B extends BlocBase, E>(E event) {
    final bloc = context.read<B>();
    try {
      // Use dynamic dispatch to call the add method
      (bloc as dynamic).add(event);
    } catch (e) {
      debugPrint('Warning: Could not add event to bloc: $e');
    }
  }

  /// Checks if the current route is the given route
  bool isCurrentRoute(String route) {
    return ModalRoute.of(context)?.settings.name == route;
  }

  /// Gets the screen size
  Size get screenSize => MediaQuery.of(context).size;

  /// Gets the screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  /// Gets the screen height
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Checks if the screen is in landscape mode
  bool get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  /// Gets the device pixel ratio
  double get devicePixelRatio => MediaQuery.of(context).devicePixelRatio;

  /// Gets the text scale factor
  double get textScaleFactor => MediaQuery.of(context).textScaleFactor;

  /// Checks if the device has a notch
  bool get hasNotch => MediaQuery.of(context).padding.top > 20;

  /// Gets the safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(context).padding;
}