import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/main/main_screen_bloc.dart';
import '../../../blocs/main/main_screen_state.dart';
import '../../../core/theme/design_system.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: Row(
            children: [
              // Profile Avatar
              _ProfileAvatar(state: state),
              const SizedBox(width: DesignSystem.spacingMD),
              // Welcome Text
              Expanded(
                child: _WelcomeText(state: state),
              ),
              // Notification Icon
              const _NotificationIcon(),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final MainScreenState state;

  const _ProfileAvatar({required this.state});

  @override
  Widget build(BuildContext context) {
    String? avatarUrl;
    if (state is MainScreenAuthenticated) {
      final userProfile = (state as MainScreenAuthenticated).userProfile;
      avatarUrl = userProfile['avatarUrl'] as String?;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
        boxShadow: DesignSystem.shadowCard,
        border: Border.all(
          color: DesignSystem.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: DesignSystem.primary,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null
            ? const Icon(
                Icons.person,
                color: DesignSystem.onPrimary,
                size: 28,
              )
            : null,
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  final MainScreenState state;

  const _WelcomeText({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: DesignSystem.bodySmall.copyWith(
            color: DesignSystem.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingXS),
        if (state is MainScreenLoading)
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
                ),
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              Text(
                'Loading profile...',
                style: DesignSystem.headlineSmall.copyWith(
                  color: DesignSystem.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )
        else if (state is MainScreenAuthenticated)
          Text(
            (state as MainScreenAuthenticated).userProfile['displayName'] ?? (state as MainScreenAuthenticated).userProfile['username'] ?? 'User',
            style: DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w700,
            ),
          )
        else
          Text(
            'Welcome!',
            style: DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingXS),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: const Icon(
        Icons.notifications_outlined,
        color: DesignSystem.onSurfaceVariant,
        size: 24,
      ),
    );
  }
}