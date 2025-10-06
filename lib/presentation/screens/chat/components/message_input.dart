import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../widgets/common/modern_input_field.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  const MessageInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Type a message...',
  });

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      size: ModernInputFieldSize.medium,
      customBackgroundColor: DesignSystem.surfaceContainerHighest,
    );
  }
}