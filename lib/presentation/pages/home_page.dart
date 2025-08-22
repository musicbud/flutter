import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../blocs/user/user_event.dart';
import '../../domain/models/user_profile.dart';
import '../widgets/common/app_scaffold.dart';
import '../widgets/common/app_app_bar.dart';
import '../widgets/common/app_button.dart';
import '../constants/app_constants.dart';
import '../mixins/page_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageMixin {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    addBlocEvent<UserBloc, LoadMyProfile>(LoadMyProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: _handleUserStateChange,
      builder: (context, state) {
        debugPrint('UserBloc Builder State: ${state.runtimeType}');

        if (state is UserLoading) {
          return const AppScaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileLoaded) {
          debugPrint('Profile Loaded: ${state.profile.username}');
          _userProfile = state.profile;
        }

        return AppScaffold(
          appBar: AppAppBar(
            title: 'MusicBud',
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  navigateTo(AppConstants.profileRoute);
                },
              ),
            ],
          ),
          body: _buildHomeContent(),
        );
      },
    );
  }

  void _handleUserStateChange(BuildContext context, UserState state) {
    debugPrint('UserBloc State Changed: ${state.runtimeType}');
    // TODO: Handle user error states if needed
  }

  Widget _buildHomeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // App Logo/Icon
        Icon(
          Icons.music_note,
          size: 80,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 24),

        // Welcome Text
        Text(
          'Welcome to MusicBud!',
          style: AppConstants.headingStyle.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),

        // User Greeting
        if (_userProfile != null) ...[
          const SizedBox(height: 16),
          Text(
            'Hello, ${_userProfile!.username}!',
            style: AppConstants.subheadingStyle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: 16),
        Text(
          'Connect with music lovers and discover new sounds',
          style: AppConstants.captionStyle.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Chat Button
        if (_userProfile != null) ...[
          AppButton(
            text: 'Go to Chat',
            onPressed: () {
              // TODO: Implement chat navigation
              showInfoSnackBar('Chat functionality coming soon!');
            },
            icon: const Icon(Icons.chat),
            width: double.infinity,
          ),
          const SizedBox(height: 16),
        ],

        // Profile Button
        AppButton(
          text: 'View Profile',
          onPressed: () {
            navigateTo(AppConstants.profileRoute);
          },
          icon: const Icon(Icons.person),
          width: double.infinity,
        ),
        const SizedBox(height: 16),

        // Settings Button
        AppButton(
          text: 'Settings',
          onPressed: () {
            // TODO: Implement settings navigation
            showInfoSnackBar('Settings functionality coming soon!');
          },
          icon: const Icon(Icons.settings),
          width: double.infinity,
          isOutlined: true,
        ),
        const SizedBox(height: 16),

        // Help Button
        AppButton(
          text: 'Help & Support',
          onPressed: () {
            // TODO: Implement help navigation
            showInfoSnackBar('Help functionality coming soon!');
          },
          icon: const Icon(Icons.help),
          width: double.infinity,
          isOutlined: true,
        ),
      ],
    );
  }
}
