import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_constants.dart';
import '../../mixins/page_mixin.dart';
import 'app_text_field.dart';
import '../../../widgets/common/app_button.dart';
import 'app_scaffold.dart';
import '../../../widgets/common/loading_indicator.dart';

/// A dynamic form component that integrates with BLoC pattern
/// Combines the functionality of legacy forms with modern styling
class BlocForm<TBloc extends Bloc<TEvent, TState>, TState, TEvent> extends StatefulWidget {
  final String title;
  final List<BlocFormField> fields;
  final String submitButtonText;
  final TEvent Function(Map<String, String> values) onSubmit;
  final void Function(TState state)? onStateChanged;
  final Widget Function(TState state)? customStateWidget;
  final bool Function(TState state) isLoading;
  final bool Function(TState state) isSuccess;
  final bool Function(TState state) isError;
  final String Function(TState state)? getErrorMessage;
  final String Function(TState state)? getSuccessMessage;
  final VoidCallback? onSuccess;
  final List<Widget>? additionalActions;
  final EdgeInsetsGeometry? padding;
  final bool showAppBar;
  final List<Widget>? appBarActions;

  const BlocForm({
    super.key,
    required this.title,
    required this.fields,
    required this.submitButtonText,
    required this.onSubmit,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    this.onStateChanged,
    this.customStateWidget,
    this.getErrorMessage,
    this.getSuccessMessage,
    this.onSuccess,
    this.additionalActions,
    this.padding,
    this.showAppBar = true,
    this.appBarActions,
  });

  @override
  State<BlocForm<TBloc, TState, TEvent>> createState() => _BlocFormState<TBloc, TState, TEvent>();
}

class _BlocFormState<TBloc extends Bloc<TEvent, TState>, TState, TEvent> extends State<BlocForm<TBloc, TState, TEvent>> with PageMixin {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _focusNodes = {};

    for (final field in widget.fields) {
      _controllers[field.key] = TextEditingController(text: field.initialValue);
      _focusNodes[field.key] = FocusNode();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final values = <String, String>{};
      for (final entry in _controllers.entries) {
        values[entry.key] = entry.value.text;
      }

      final event = widget.onSubmit(values);
      context.read<TBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocConsumer<TBloc, TState>(
      listener: (context, state) {
        widget.onStateChanged?.call(state);

        if (widget.isSuccess(state)) {
          final message = widget.getSuccessMessage?.call(state) ?? 'Success!';
          showSuccessSnackBar(message);
          widget.onSuccess?.call();
        } else if (widget.isError(state)) {
          final message = widget.getErrorMessage?.call(state) ?? 'An error occurred';
          showErrorSnackBar(message);
        }
      },
      builder: (context, state) {
        if (widget.customStateWidget != null) {
          final customWidget = widget.customStateWidget!(state);
          return customWidget;
        }

        if (widget.isLoading(state)) {
          return const LoadingIndicator();
        }

        return SingleChildScrollView(
          padding: widget.padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form fields
                ...widget.fields.map((field) => _buildFormField(field)),

                const SizedBox(height: 24),

                // Submit button
                AppButton(
                  text: widget.submitButtonText,
                  onPressed: widget.isLoading(state) ? null : _submitForm,
                  isLoading: widget.isLoading(state),
                ),

                // Additional actions
                if (widget.additionalActions != null) ...[
                  const SizedBox(height: 16),
                  ...widget.additionalActions!,
                ],
              ],
            ),
          ),
        );
      },
    );

    if (widget.showAppBar) {
      return AppScaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: widget.appBarActions,
        ),
        body: content,
      );
    }

    return content;
  }

  Widget _buildFormField(BlocFormField field) {
    return Column(
      children: [
        AppTextField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          labelText: field.label,
          hintText: field.hint,
          keyboardType: field.keyboardType,
          obscureText: field.obscureText,
          prefixIcon: field.prefixIcon,
          suffixIcon: field.suffixIcon,
          maxLines: field.maxLines,
          validator: field.validator,
          onChanged: field.onChanged,
          onSubmitted: (_) => _focusNextField(field.key),
        ),
        SizedBox(height: field.spacing),
      ],
    );
  }

  void _focusNextField(String currentKey) {
    final currentIndex = widget.fields.indexWhere((field) => field.key == currentKey);
    if (currentIndex < widget.fields.length - 1) {
      final nextKey = widget.fields[currentIndex + 1].key;
      _focusNodes[nextKey]?.requestFocus();
    } else {
      _focusNodes[currentKey]?.unfocus();
    }
  }
}

/// Configuration for a form field
class BlocFormField {
  final String key;
  final String label;
  final String? hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final double spacing;

  const BlocFormField({
    required this.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.spacing = 16.0,
  });

  /// Common validators
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!AppConstants.emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }
    return null;
  }

  static String? requiredValidator(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }
    return null;
  }

  static String? Function(String?) confirmPasswordValidator(TextEditingController passwordController) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    };
  }
}