import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_event.dart';
import '../../../blocs/bud/bud_state.dart';
import '../../../domain/models/bud_match.dart';
import '../../widgets/common/bloc_tab_view.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class ModernBudsPage extends StatefulWidget {
  final int initialCategoryIndex;

  const ModernBudsPage({Key? key, this.initialCategoryIndex = 0}) : super(key: key);

  @override
  State<ModernBudsPage> createState() => _ModernBudsPageState();
}

class _ModernBudsPageState extends State<ModernBudsPage> with PageMixin {
  final List<String> _categories = [
    'liked/artists',
    'liked/tracks',
    'liked/genres',
    'top/artists',
    'top/tracks',
    'top/genres',
    'played/tracks'
  ];

  @override
  Widget build(BuildContext context) {
    return CategoryTabView<BudBloc, BudState, BudEvent, BudMatch>(
      title: 'Find Your Music Buds',
      categories: _categories,
      getCategoryEvent: (category) => BudCategoryRequested(category),
      getItems: (state, category) {
        if (state is BudLoaded) {
          return state.buds.where((bud) => bud.category == category).toList();
        }
        return [];
      },
      isLoading: (state) => state is BudLoading,
      isError: (state) => state is BudFailure,
      itemBuilder: (context, bud, index) => _buildBudItem(bud),
      getCategoryTitle: _getCategoryTitle,
    );
  }

  Widget _buildBudItem(BudMatch bud) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppConstants.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onBudTap(bud),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withOpacity(0.2),
                  image: bud.profileImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(bud.profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: bud.profileImageUrl == null
                    ? Icon(
                        Icons.person,
                        size: 30,
                        color: AppConstants.primaryColor,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bud.username,
                      style: AppConstants.subheadingStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (bud.displayName != null && bud.displayName!.isNotEmpty) ...[
                      Text(
                        bud.displayName!,
                        style: AppConstants.captionStyle.copyWith(
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bud.matchPercentage}% match',
                          style: AppConstants.captionStyle.copyWith(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (bud.location != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppConstants.textSecondaryColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            bud.location!,
                            style: AppConstants.captionStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Connect',
                  style: AppConstants.captionStyle.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryTitle(String category) {
    final parts = category.split('/');
    return parts.map((word) => _capitalize(word)).join(' ');
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _onBudTap(BudMatch bud) {
    // Navigate to bud profile or show connection options
    showDialog(
      context: context,
      builder: (context) => _buildBudDialog(bud),
    );
  }

  Widget _buildBudDialog(BudMatch bud) {
    return Dialog(
      backgroundColor: AppConstants.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.primaryColor.withOpacity(0.2),
                image: bud.profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(bud.profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: bud.profileImageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: AppConstants.primaryColor,
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // Name and Match
            Text(
              bud.username,
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              '${bud.matchPercentage}% match',
              style: AppConstants.bodyStyle.copyWith(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Common Interests (if available)
            if (bud.commonItems != null && bud.commonItems!.isNotEmpty) ...[
              Text(
                'Common Interests',
                style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: bud.commonItems!.take(5).map((item) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item,
                      style: AppConstants.captionStyle.copyWith(
                        color: AppConstants.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  )
                ).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppConstants.bodyStyle.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _connectWithBud(bud);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Connect'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _viewBudProfile(bud);
                  },
                  child: Text(
                    'View Profile',
                    style: AppConstants.bodyStyle.copyWith(
                      color: AppConstants.primaryColor,
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

  void _connectWithBud(BudMatch bud) {
    context.read<BudBloc>().add(BudConnectionRequested(bud.userId));
    showSuccessSnackBar('Connection request sent to ${bud.username}!');
  }

  void _viewBudProfile(BudMatch bud) {
    navigateTo('/profile/${bud.userId}');
  }
}

/// Alternative implementation using BlocTabView for more complex tab scenarios
class AdvancedBudsPage extends StatefulWidget {
  const AdvancedBudsPage({Key? key}) : super(key: key);

  @override
  State<AdvancedBudsPage> createState() => _AdvancedBudsPageState();
}

class _AdvancedBudsPageState extends State<AdvancedBudsPage> with PageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocTabView<BudBloc, BudState, BudEvent>(
      title: 'Music Buds',
      isScrollable: true,
      tabs: [
        BlocTab<BudState, BudEvent>(
          title: 'Liked Artists',
          icon: const Icon(Icons.favorite_outline, size: 20),
          loadEvent: const BudCategoryRequested('liked/artists'),
          isLoading: (state) => state is BudLoading,
          isError: (state) => state is BudFailure,
          builder: (context, state) => _buildBudsList(state, 'liked/artists'),
        ),
        BlocTab<BudState, BudEvent>(
          title: 'Liked Tracks',
          icon: const Icon(Icons.music_note_outlined, size: 20),
          loadEvent: const BudCategoryRequested('liked/tracks'),
          isLoading: (state) => state is BudLoading,
          isError: (state) => state is BudFailure,
          builder: (context, state) => _buildBudsList(state, 'liked/tracks'),
        ),
        BlocTab<BudState, BudEvent>(
          title: 'Top Artists',
          icon: const Icon(Icons.trending_up, size: 20),
          loadEvent: const BudCategoryRequested('top/artists'),
          isLoading: (state) => state is BudLoading,
          isError: (state) => state is BudFailure,
          builder: (context, state) => _buildBudsList(state, 'top/artists'),
        ),
        // Add more tabs as needed...
      ],
    );
  }

  Widget _buildBudsList(BudState state, String category) {
    if (state is BudLoaded) {
      final buds = state.buds.where((bud) => bud.category == category).toList();

      if (buds.isEmpty) {
        return const Center(
          child: Text(
            'No buds found for this category',
            style: AppConstants.captionStyle,
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: buds.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
              child: Text(
                buds[index].username[0].toUpperCase(),
                style: AppConstants.bodyStyle.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              buds[index].username,
              style: AppConstants.bodyStyle,
            ),
            subtitle: Text(
              '${buds[index].matchPercentage}% match',
              style: AppConstants.captionStyle.copyWith(
                color: AppConstants.primaryColor,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppConstants.textSecondaryColor,
            ),
            onTap: () {
              // Handle bud tap
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}