import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import 'components/chat_action_button.dart';
import 'components/message_input.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendPressed;
  final ValueChanged<String>? onMessageChanged;

  const MessageInputWidget({
    super.key,
    required this.messageController,
    required this.onSendPressed,
    this.onMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        boxShadow: DesignSystem.shadowCard,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            ChatActionButton(
              icon: Icons.attach_file,
              onPressed: () {
                // TODO: Handle attachment functionality
              },
            ),

            const SizedBox(width: 16),

            // Message Input
            Expanded(
              child: MessageInput(
                controller: messageController,
                onChanged: onMessageChanged,
                onSubmitted: (_) => onSendPressed(),
              ),
            ),

            const SizedBox(width: 16),

            // Send Button
            GestureDetector(
              onTap: onSendPressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DesignSystem.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: DesignSystem.shadowMedium,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}