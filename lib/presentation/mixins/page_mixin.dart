import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_constants.dart';

/// A mixin that provides common functionality for pages
mixin PageMixin<T extends StatefulWidget> on State<T> {
  // Navigation methods
  void navigateTo(String route) {
    Navigator.of(context).pushNamed(route);
  }

  void replaceRoute(String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  void navigateBackWithResult(dynamic result) {
    Navigator.of(context).pop(result);
  }

  // Snackbar methods
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dialog methods
  void showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  Future<String?> showInputDialog({
    required String title,
    required String message,
    String hintText = '',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Bloc utility methods
  void addBlocEvent<B extends BlocBase<dynamic>, E>(E event) {
    try {
      final bloc = context.read<B>();
      if (bloc is Bloc<dynamic, dynamic>) {
        bloc.add(event);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  S? getBlocState<B extends BlocBase<S>, S>(BuildContext context) {
    try {
      return context.read<B>().state;
    } catch (e) {
      return null;
    }
  }

  bool isBlocInState<B extends BlocBase<S>, S>(BuildContext context, bool Function(S state) condition) {
    try {
      final state = context.read<B>().state;
      return condition(state);
    } catch (e) {
      return false;
    }
  }

  // Contextual properties
  Size get screenSize => MediaQuery.of(context).size;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  Color get primaryColor => Theme.of(context).primaryColor;
  double get defaultPadding => 16.0;
  double get defaultBorderRadius => 12.0;
  EdgeInsets get screenPadding => MediaQuery.of(context).padding;
  double get statusBarHeight => MediaQuery.of(context).padding.top;
  double get bottomPadding => MediaQuery.of(context).padding.bottom;
  bool get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;
  bool get isPortrait => MediaQuery.of(context).orientation == Orientation.portrait;
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  double get aspectRatio => MediaQuery.of(context).size.aspectRatio;
  bool get isTablet => screenWidth > 600;
  bool get isPhone => screenWidth <= 600;
}