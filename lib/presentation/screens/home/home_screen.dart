import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/app_theme.dart';
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
    final appTheme = AppTheme.of(context);

    return MainNavigationScaffold(
      navigationController: _navigationController,
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: appTheme.colors.errorRed,
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: appTheme.gradients.backgroundGradient,
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: HomeHeaderWidget(),
                ),

                // Search Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
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
                  child: SizedBox(height: appTheme.spacing.lg),
                ),

                // Quick Actions Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                    child: HomeQuickActions(),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
                ),

                // Dynamic Content Sections
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                    child: Column(
                      children: [
                        HomeRecommendations(),
                        HomeRecentActivity(),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}