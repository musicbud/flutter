import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/design_system.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(DesignSystem.spacingLG),
          child: Row(
            children: [
              // Profile Avatar
              _ProfileAvatar(state: state),
              SizedBox(width: DesignSystem.spacingMD),
              // Welcome Text
              Expanded(
                child: _WelcomeText(state: state),
              ),
              // Notification Icon
              _NotificationIcon(),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final UserProfileState state;

  const _ProfileAvatar({required this.state});

  @override
  Widget build(BuildContext context) {
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
        backgroundImage: state is UserProfileLoaded && (state as UserProfileLoaded).userProfile.avatarUrl != null
            ? NetworkImage((state as UserProfileLoaded).userProfile.avatarUrl!)
            : null,
        child: state is UserProfileLoaded && (state as UserProfileLoaded).userProfile.avatarUrl == null
            ? Icon(
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
  final UserProfileState state;

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
        SizedBox(height: DesignSystem.spacingXS),
        Text(
          state is UserProfileLoaded
              ? ((state as UserProfileLoaded).userProfile.displayName ?? (state as UserProfileLoaded).userProfile.username)
              : 'Loading...',
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
      padding: EdgeInsets.all(DesignSystem.spacingXS),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Icon(
        Icons.notifications_outlined,
        color: DesignSystem.onSurfaceVariant,
        size: 24,
      ),
    );
  }
}