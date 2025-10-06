import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../components/discover_action_card.dart';
import '../discover_content_manager.dart';

class DiscoverMoreSection extends StatelessWidget {
  const DiscoverMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final actions = DiscoverContentManager.getDiscoverActions();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover More',
            style: appTheme.typography.headlineH7.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          Row(
            children: [
              ...actions.map((action) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: actions.last == action ? 0 : appTheme.spacing.md,
                  ),
                  child: DiscoverActionCard(
                    title: action['title'] as String,
                    subtitle: action['subtitle'] as String,
                    icon: (action['icon'] as IconData?) ?? Icons.star,
                    accentColor: (action['accentColor'] as Color?) ?? Colors.blue,
                    onTap: () {
                      // Handle discover action card tap
                    },
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}