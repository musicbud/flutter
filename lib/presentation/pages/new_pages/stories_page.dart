import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      color: appTheme.colors.background,
      child: Column(
        children: [
          // App Bar equivalent
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: appTheme.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: appTheme.colors.textPrimary,
                ),
                const SizedBox(width: 16),
                Text(
                  'Stories',
                  style: appTheme.typography.headlineH6.copyWith(
                    color: appTheme.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Body content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.headphones,
                    size: 80,
                    color: appTheme.colors.primaryRed.withValues(alpha:  0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Stories Coming Soon!',
                    style: appTheme.typography.headlineH6.copyWith(
                      color: appTheme.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Music stories and audio content\nwill be available here soon.',
                    style: appTheme.typography.bodyMedium.copyWith(
                      color: appTheme.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}