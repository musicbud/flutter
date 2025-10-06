import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../widgets/home/quick_actions_grid.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return QuickActionsGrid(
          crossAxisCount: 1,
          actions: [
            QuickAction(
              title: 'Discover',
              icon: Icons.explore,
              onPressed: () {
                Navigator.pushNamed(context, '/discover');
              },
              isPrimary: true,
            ),
            QuickAction(
              title: 'My Library',
              icon: Icons.library_music,
              onPressed: () {
                Navigator.pushNamed(context, '/library');
              },
              isPrimary: false,
            ),
          ],
        );
      },
    );
  }
}