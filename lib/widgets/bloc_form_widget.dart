import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/widgets/enhanced/utils/snackbar_utils.dart';
import '../presentation/widgets/enhanced/buttons/modern_button.dart';

/// A reusable form widget that integrates with BLoC pattern.
///
/// This widget handles common form scenarios including:
/// - Loading states with progress indicators
/// - Success states with automatic navigation
/// - Error states with snackbar notifications
/// - Form submission with validation
///
/// Example usage:
/// ```dart
/// BlocFormWidget<MyFormBloc, MyFormState>(
///   formKey: _formKey,
///   formFields: (context) => [
///     ModernInputField(
///       controller: _nameController,
///       labelText: 'Name',
///       validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
///     ),
///     ModernInputField(
///       controller: _emailController,
///       labelText: 'Email',
///       validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
///     ),
///   ],
///   submitButtonText: 'Save',
///   onSubmit: (context) {
///     if (_formKey.currentState!.validate()) {
///       context.read<MyFormBloc>().add(
///         SubmitForm(name: _nameController.text, email: _emailController.text),
///       );
///     }
///   },
///   isLoading: (state) => state is MyFormLoadingState,
///   isSuccess: (state) => state is MyFormSuccessState,
///   isError: (state) => state is MyFormErrorState,
///   getErrorMessage: (state) => (state as MyFormErrorState).message,
///   onSuccess: (context, state) => Navigator.of(context).pop(),
/// )
/// ```
class BlocFormWidget<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  /// Global key for form validation
  final GlobalKey<FormState> formKey;

  /// Builder function that returns list of form field widgets
  final List<Widget> Function(BuildContext context) formFields;

  /// Text to display on submit button
  final String submitButtonText;

  /// Callback when submit button is pressed
  final void Function(BuildContext context) onSubmit;

  /// Function to determine if state represents loading
  final bool Function(S state) isLoading;

  /// Function to determine if state represents success
  final bool Function(S state) isSuccess;

  /// Function to determine if state represents error
  final bool Function(S state) isError;

  /// Function to extract error message from error state
  final String Function(S state) getErrorMessage;

  /// Optional callback when success state is reached
  final void Function(BuildContext context, S state)? onSuccess;

  /// Optional callback when error state is reached
  final void Function(BuildContext context, S state)? onError;

  /// Optional padding for the form content
  final EdgeInsetsGeometry? padding;

  /// Optional spacing between form fields
  final double fieldSpacing;

  /// Optional custom loading widget
  final Widget? loadingWidget;

  /// Whether to show loading overlay or inline indicator
  final bool showLoadingOverlay;

  /// Optional button variant for submit button
  final ModernButtonVariant submitButtonVariant;

  const BlocFormWidget({
    super.key,
    required this.formKey,
    required this.formFields,
    required this.submitButtonText,
    required this.onSubmit,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.getErrorMessage,
    this.onSuccess,
    this.onError,
    this.padding,
    this.fieldSpacing = 16.0,
    this.loadingWidget,
    this.showLoadingOverlay = true,
    this.submitButtonVariant = ModernButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (isSuccess(state)) {
          SnackbarUtils.showSuccess(
            context,
            'Operation completed successfully',
          );
          onSuccess?.call(context, state);
        } else if (isError(state)) {
          SnackbarUtils.showError(
            context,
            getErrorMessage(state),
          );
          onError?.call(context, state);
        }
      },
      builder: (context, state) {
        final loading = isLoading(state);

        return Stack(
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...formFields(context).expand(
                      (field) => [
                        field,
                        SizedBox(height: fieldSpacing),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    ModernButton(
                      text: submitButtonText,
                      onPressed: loading ? null : () => onSubmit(context),
                      variant: submitButtonVariant,
                      isLoading: loading && !showLoadingOverlay,
                    ),
                  ],
                ),
              ),
            ),
            if (loading && showLoadingOverlay)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: loadingWidget ??
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Processing...',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
