import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

class ChatHeaderWidget extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final String status;
  final VoidCallback? onBackPressed;
  final VoidCallback? onVideoCallPressed;
  final VoidCallback? onVoiceCallPressed;

  const ChatHeaderWidget({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.status,
    this.onBackPressed,
    this.onVideoCallPressed,
    this.onVoiceCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: DesignSystem.surfaceContainer,
        boxShadow: DesignSystem.shadowCard,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: onBackPressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DesignSystem.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Chat Partner Info
            Expanded(
              child: Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: DesignSystem.error.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: DesignSystem.primary,
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: status == 'Online'
                                    ? DesignSystem.secondary
                                    : DesignSystem.onSurfaceVariant,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: DesignSystem.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Row(
              children: [
                GestureDetector(
                  onTap: onVideoCallPressed,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.video_call,
                      color: DesignSystem.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onVoiceCallPressed,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.call,
                      color: DesignSystem.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}