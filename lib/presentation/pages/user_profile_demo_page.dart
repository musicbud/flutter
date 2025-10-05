import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/demo/demo_profile_bloc.dart';
import '../../blocs/demo/demo_profile_event.dart';
import '../../blocs/demo/demo_profile_state.dart';
import '../../domain/models/demo_user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_card.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

class UserProfileDemoPage extends StatelessWidget {
  const UserProfileDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<DemoProfileBloc>()
        ..add(const DemoProfileRequested()),
      child: const _UserProfileDemoView(),
    );
  }
}

class _UserProfileDemoView extends StatefulWidget {
  const _UserProfileDemoView();

  @override
  State<_UserProfileDemoView> createState() => _UserProfileDemoViewState();
}

class _UserProfileDemoViewState extends State<_UserProfileDemoView> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Demo'),
        actions: [
          BlocBuilder<DemoProfileBloc, DemoProfileState>(
            builder: (context, state) {
              if (state is DemoProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.workspace_premium),
                  color: state.profile.isPremium 
                    ? appTheme.colors.primary 
                    : appTheme.colors.shadow, // shadow is used for textSecondary
                  onPressed: () {
                    context.read<DemoProfileBloc>().add(
                      const DemoPremiumToggled(),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<DemoProfileBloc, DemoProfileState>(
        listener: (context, state) {
          if (state is DemoProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: appTheme.colors.error,
              ),
            );
          }
          if (state is DemoProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DemoProfileLoading) {
            return const LoadingView();
          }

          if (state is DemoProfileError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<DemoProfileBloc>().add(
                  const DemoProfileRequested(),
                );
              },
            );
          }

          if (state is DemoProfileLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DemoProfileBloc>().add(
                  const DemoProfileRequested(),
                );
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppTheme.spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(context, state.profile, appTheme),
                    SizedBox(height: AppTheme.spacing.md),
                    _buildStats(context, state.stats, appTheme),
                    SizedBox(height: AppTheme.spacing.md),
                    _buildPreferences(context, state.profile, appTheme),
                    SizedBox(height: AppTheme.spacing.md),
                    _buildInterests(context, state.profile, appTheme),
                    SizedBox(height: AppTheme.spacing.md),
                    _buildBadges(context, state.profile, appTheme),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    DemoUserProfile profile,
    AppTheme appTheme,
  ) {
    return ModernCard(
      child: Column(
        children: [
          if (profile.photoUrl != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profile.photoUrl!),
            )
          else
            CircleAvatar(
              radius: 50,
              backgroundColor: appTheme.colors.surfaceContainerHighest,
              child: Icon(
                Icons.person,
                size: 50,
                color: appTheme.colors.shadow, // Using shadow for textSecondary
              ),
            ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            profile.displayName,
            style: appTheme.typography.titleLarge,
          ),
          Text(
            profile.role,
            style: appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.shadow, // shadow used for textSecondary color
            ),
          ),
          SizedBox(height: appTheme.spacing.xs),
          if (profile.isPremium)
            Chip(
              backgroundColor: appTheme.colors.primary.withOpacity(0.1),
              label: Text(
                'Premium Member',
                style: appTheme.typography.labelMedium.copyWith(
                  color: appTheme.colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    Map<String, int> stats,
    AppTheme appTheme,
  ) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: appTheme.typography.titleMedium,
          ),
          SizedBox(height: appTheme.spacing.sm),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: AppTheme.spacing.sm,
            crossAxisSpacing: AppTheme.spacing.sm,
            childAspectRatio: 2,
            physics: const NeverScrollableScrollPhysics(),
            children: stats.entries.map((entry) {
              return Container(
                padding: EdgeInsets.all(AppTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radius.sm),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.value.toString(),
                      style: appTheme.typography.titleLarge,
                    ),
                    Text(
                      entry.key,
                      style: appTheme.typography.bodySmall.copyWith(
                        color: appTheme.colors.shadow, // Using shadow for textSecondary
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(
    BuildContext context,
    DemoUserProfile profile,
    AppTheme appTheme,
  ) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: appTheme.typography.titleMedium,
          ),
          SizedBox(height: appTheme.spacing.sm),
          ...profile.preferences.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(
                entry.value.toString(),
                style: appTheme.typography.bodySmall.copyWith(
                  color: appTheme.colors.shadow, // Using shadow for textSecondary
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show edit dialog
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInterests(
    BuildContext context,
    DemoUserProfile profile,
    AppTheme appTheme,
  ) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interests',
            style: appTheme.typography.titleMedium,
          ),
          SizedBox(height: appTheme.spacing.sm),
          Wrap(
            spacing: AppTheme.spacing.xs,
            runSpacing: AppTheme.spacing.xs,
            children: profile.interests.map((interest) {
              return Chip(
                label: Text(interest),
                onDeleted: () {
                  final updatedInterests = List<String>.from(profile.interests)
                    ..remove(interest);
                  context.read<DemoProfileBloc>().add(
                    DemoInterestsUpdated(updatedInterests),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(
    BuildContext context,
    DemoUserProfile profile,
    AppTheme appTheme,
  ) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badges',
            style: appTheme.typography.titleMedium,
          ),
          SizedBox(height: appTheme.spacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: profile.badges.map((badge) {
                return Padding(
                  padding: EdgeInsets.only(right: AppTheme.spacing.sm),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: appTheme.colors.surfaceContainerHighest,
                        child: Icon(
                          _getBadgeIcon(badge),
                          color: appTheme.colors.primary,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing.xs),
                      Text(
                        badge,
                        style: appTheme.typography.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBadgeIcon(String badge) {
    switch (badge.toLowerCase()) {
      case 'verified':
        return Icons.verified;
      case 'premium':
        return Icons.workspace_premium;
      case 'creator':
        return Icons.create;
      case 'influencer':
        return Icons.trending_up;
      case 'early_adopter':
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }
}
