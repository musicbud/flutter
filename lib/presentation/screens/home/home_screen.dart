import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';
import '../../../presentation/widgets/navigation/main_navigation_scaffold.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../widgets/common/app_input_field.dart';
import 'home_header_widget.dart';
import 'home_quick_actions.dart';
import 'home_recommendations.dart';
import 'home_recent_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final MainNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();

    // Load user profile and dynamic content
    debugPrint('🏠 HomeScreen: Making API calls on startup');
    context.read<UserProfileBloc>().add(FetchMyProfile());
    context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: 'tracks'));
    context.read<UserProfileBloc>().add(FetchMyTopContent(contentType: 'artists'));
    context.read<UserProfileBloc>().add(FetchMyPlayedTracks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationScaffold(
      navigationController: _navigationController,
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: DesignSystem.error,
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: DesignSystem.gradientBackground,
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: const HomeHeaderWidget(),
                ),

                // Search Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
                    child: AppInputField(
                      hint: 'Search for music, artists, or playlists...',
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // Navigate to search page with query
                          Navigator.pushNamed(
                            context,
                            '/search',
                            arguments: {'query': value},
                          );
                        }
                      },
                      variant: AppInputVariant.search,
                      size: AppInputSize.large,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: const SizedBox(height: DesignSystem.spacingLG),
                ),

                // Quick Actions Section
                SliverToBoxAdapter(
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
                    child: const HomeQuickActions(),
                  ),
                ),

                SliverToBoxAdapter(
                  child: const SizedBox(height: DesignSystem.spacingXL),
                ),

                // Dynamic Content Sections
                SliverToBoxAdapter(
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
                    child: const Column(
                      children: [
                        const HomeRecommendations(),
                        const HomeRecentActivity(),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: const SizedBox(height: DesignSystem.spacingXL),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}