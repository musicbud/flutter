import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Convenient dialog utilities for common use cases.
///
/// Provides helper methods for:
/// - Confirmation dialogs
/// - Alert dialogs
/// - Input dialogs
/// - Custom dialogs
///
/// Example:
/// ```dart
/// final confirmed = await DialogUtils.showConfirmation(
///   context,
///   title: 'Delete Playlist',
///   message: 'Are you sure you want to delete this playlist?',
/// );
/// ```
class DialogUtils {
  /// Show a confirmation dialog
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  /// Show an alert dialog
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
      ),
    );
  }

  /// Show an input dialog
  static Future<String?> showInput(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  /// Show a custom dialog
  static Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// Show a loading dialog
  static void showLoading(
    BuildContext context, {
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Confirmation dialog widget
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: DesignSystem.headlineSmall,
      ),
      content: Text(
        message,
        style: DesignSystem.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? TextButton.styleFrom(
                  foregroundColor: DesignSystem.error,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Alert dialog widget
class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.icon,
  });

  final String title;
  final String message;
  final String buttonText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 48) : null,
      title: Text(
        title,
        style: DesignSystem.headlineSmall,
      ),
      content: Text(
        message,
        style: DesignSystem.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}

/// Input dialog widget
class InputDialog extends StatefulWidget {
  const InputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.maxLines,
    this.keyboardType,
    this.validator,
  });

  final String title;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      if (error != null) {
        setState(() => _errorText = error);
        return;
      }
    }
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: DesignSystem.headlineSmall,
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: _errorText,
        ),
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        autofocus: true,
        onChanged: (_) {
          if (_errorText != null) {
            setState(() => _errorText = null);
          }
        },
        onSubmitted: (_) => _onConfirm(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}

/// Loading dialog widget
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: DesignSystem.spacingMD),
              Text(
                message!,
                style: DesignSystem.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Extension on BuildContext for easy dialog access
extension DialogExtensions on BuildContext {
  /// Show confirmation dialog
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return DialogUtils.showConfirmation(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
    );
  }

  /// Show alert dialog
  Future<void> showAlertDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) {
    return DialogUtils.showAlert(
      this,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: icon,
    );
  }

  /// Show input dialog
  Future<String?> showInputDialog({
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    return DialogUtils.showInput(
      this,
      title: title,
      hint: hint,
      initialValue: initialValue,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  /// Show loading dialog
  void showLoadingDialog({String? message}) {
    DialogUtils.showLoading(this, message: message);
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    DialogUtils.hideLoading(this);
  }
}