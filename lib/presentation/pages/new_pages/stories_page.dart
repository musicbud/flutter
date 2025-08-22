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

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      appBar: AppBar(
        title: Text(
          'Stories',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.textPrimary,
          ),
        ),
        backgroundColor: appTheme.colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: appTheme.colors.textPrimary),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headphones,
              size: 80,
              color: appTheme.colors.primaryRed.withValues(alpha: 0.6),
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
    );
  }
}