import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/main/main_screen_bloc.dart';
import '../../../blocs/main/main_screen_event.dart';
import '../../../blocs/main/main_screen_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/widgets/common/modern_input_field.dart';
import '../../../presentation/widgets/navigation/main_navigation_scaffold.dart';
import '../../../presentation/navigation/main_navigation.dart';
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
    context.read<MainScreenBloc>().add(MainScreenInitialized());
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
      body: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          if (state is MainScreenLoading) {
            return Container(
              decoration: const BoxDecoration(
                gradient: DesignSystem.gradientBackground,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is MainScreenFailure) {
            return Container(
              decoration: const BoxDecoration(
                gradient: DesignSystem.gradientBackground,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load data',
                      style: DesignSystem.headlineMedium.copyWith(
                        color: DesignSystem.onSurface,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainScreenBloc>().add(MainScreenInitialized());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // For authenticated or other states, show the content
          return BlocListener<MainScreenBloc, MainScreenState>(
            listener: (context, state) {
              if (state is MainScreenFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.error}'),
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
                        child: ModernInputField(
                          hintText: 'Search for music, artists, or playlists...',
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
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: const SizedBox(height: DesignSystem.spacingLG),
                    ),

                    // Quick Actions Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
                        child: HomeQuickActions(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: DesignSystem.spacingXL),
                    ),

                    // Dynamic Content Sections
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
                        child: Column(
                          children: [
                            HomeRecommendations(),
                            HomeRecentActivity(),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: DesignSystem.spacingXL),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}