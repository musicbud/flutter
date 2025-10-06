import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AppTypography extends StatelessWidget {
  const AppTypography({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      appBar: AppBar(
        title: Text(
          'Typography System',
          style: appTheme.typography.headlineH4.copyWith(
            color: appTheme.colors.white,
          ),
        ),
        backgroundColor: appTheme.colors.darkTone,
        foregroundColor: appTheme.colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(appTheme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypographySection(
              context,
              'Display Typography',
              [
                _buildTypographyExample(
                  context,
                  'Display H1',
                  appTheme.typography.displayH1.copyWith(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display H2',
                  appTheme.typography.displayH2.copyWith(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display H3',
                  appTheme.typography.displayH3.copyWith(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Headline Typography',
              [
                _buildTypographyExample(
                  context,
                  'Headline H4',
                  appTheme.typography.headlineH4.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline H5',
                  appTheme.typography.headlineH5.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline H6',
                  appTheme.typography.headlineH6.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline H7',
                  appTheme.typography.headlineH7.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Body Typography',
              [
                _buildTypographyExample(
                  context,
                  'Body H8',
                  appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body H9',
                  appTheme.typography.bodyH9.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body H10',
                  appTheme.typography.bodyH10.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Title Typography',
              [
                _buildTypographyExample(
                  context,
                  'Title Large',
                  appTheme.typography.titleLarge.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Medium',
                  appTheme.typography.titleMedium.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Small',
                  appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Caption',
                  appTheme.typography.caption.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Overline',
                  appTheme.typography.overline.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Arabic Typography',
              [
                _buildTypographyExample(
                  context,
                  'Arabic Text',
                  appTheme.typography.arabicText.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Font Families',
              [
                _buildFontFamilyExample(
                  context,
                  'Primary Font',
                  appTheme.typography.fontFamilyPrimary,
                  appTheme.colors.white,
                ),
                _buildFontFamilyExample(
                  context,
                  'Secondary Font',
                  appTheme.typography.fontFamilySecondary,
                  appTheme.colors.white,
                ),
                _buildFontFamilyExample(
                  context,
                  'Arabic Font',
                  appTheme.typography.fontFamilyArabic,
                  appTheme.colors.white,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Color Palette',
              [
                _buildColorExample(
                  context,
                  'Primary Red',
                  appTheme.colors.primaryRed,
                ),
                _buildColorExample(
                  context,
                  'Secondary Red',
                  appTheme.colors.secondaryRed,
                ),
                _buildColorExample(
                  context,
                  'Accent',
                  appTheme.colors.accent,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Neutral Colors',
              [
                _buildColorExample(
                  context,
                  'Dark Tone',
                  appTheme.colors.darkTone,
                ),
                _buildColorExample(
                  context,
                  'Light Gray',
                  appTheme.colors.lightGray,
                ),
                _buildColorExample(
                  context,
                  'White',
                  appTheme.colors.white,
                ),
                _buildColorExample(
                  context,
                  'Black',
                  appTheme.colors.black,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Semantic Colors',
              [
                _buildColorExample(
                  context,
                  'Success',
                  appTheme.colors.success,
                ),
                _buildColorExample(
                  context,
                  'Warning',
                  appTheme.colors.warning,
                ),
                _buildColorExample(
                  context,
                  'Error',
                  appTheme.colors.error,
                ),
                _buildColorExample(
                  context,
                  'Info',
                  appTheme.colors.info,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Neutral Palette',
              [
                _buildColorExample(
                  context,
                  'Neutral 50',
                  appTheme.colors.neutral[50]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 100',
                  appTheme.colors.neutral[100]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 200',
                  appTheme.colors.neutral[200]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 300',
                  appTheme.colors.neutral[300]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 400',
                  appTheme.colors.neutral[400]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 500',
                  appTheme.colors.neutral[500]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 600',
                  appTheme.colors.neutral[600]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 700',
                  appTheme.colors.neutral[700]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 800',
                  appTheme.colors.neutral[800]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 900',
                  appTheme.colors.neutral[900]!,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Spacing System',
              [
                _buildSpacingExample(
                  context,
                  'Spacing XS',
                  appTheme.spacing.xs,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing S',
                  appTheme.spacing.sm,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing M',
                  appTheme.spacing.md,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing L',
                  appTheme.spacing.lg,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XL',
                  appTheme.spacing.xl,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XXL',
                  appTheme.spacing.xxl,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XXXL',
                  appTheme.spacing.xxxl,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing Huge',
                  appTheme.spacing.huge,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Border Radius',
              [
                _buildRadiusExample(
                  context,
                  'Radius XS',
                  appTheme.radius.xs,
                ),
                _buildRadiusExample(
                  context,
                  'Radius S',
                  appTheme.radius.sm,
                ),
                _buildRadiusExample(
                  context,
                  'Radius M',
                  appTheme.radius.md,
                ),
                _buildRadiusExample(
                  context,
                  'Radius L',
                  appTheme.radius.lg,
                ),
                _buildRadiusExample(
                  context,
                  'Radius XL',
                  appTheme.radius.xl,
                ),
                _buildRadiusExample(
                  context,
                  'Radius XXL',
                  appTheme.radius.xxl,
                ),
                _buildRadiusExample(
                  context,
                  'Radius Circular',
                  appTheme.radius.circular,
                ),
              ],
            ),
            SizedBox(height: appTheme.spacing.xl),
            _buildTypographySection(
              context,
              'Shadows',
              [
                _buildShadowExample(
                  context,
                  'Shadow Small',
                  appTheme.shadows.shadowSmall,
                ),
                _buildShadowExample(
                  context,
                  'Shadow Medium',
                  appTheme.shadows.shadowMedium,
                ),
                _buildShadowExample(
                  context,
                  'Shadow Large',
                  appTheme.shadows.shadowLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographySection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.primaryRed,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),
        Container(
          padding: EdgeInsets.all(appTheme.spacing.md),
          decoration: BoxDecoration(
            color: appTheme.colors.surface,
            borderRadius: BorderRadius.circular(appTheme.radius.md),
            border: Border.all(
              color: appTheme.colors.lightGray.withValues(alpha:  0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyExample(
    BuildContext context,
    String label,
    TextStyle style,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _buildFontFamilyExample(
    BuildContext context,
    String label,
    String fontFamily,
    Color color,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Text(
            'Sample text with $fontFamily',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorExample(
    BuildContext context,
    String label,
    Color color,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(appTheme.radius.sm),
              border: Border.all(
                color: appTheme.colors.lightGray.withValues(alpha:  0.3),
              ),
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: appTheme.typography.bodyH9.copyWith(
                    color: appTheme.colors.white,
                  ),
                ),
                Text(
                  '#${color.value.toRadixString(16).toUpperCase()}',
                  style: appTheme.typography.caption.copyWith(
                    color: appTheme.colors.lightGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingExample(
    BuildContext context,
    String label,
    double spacing,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Row(
        children: [
          Container(
            width: spacing,
            height: 20,
            decoration: BoxDecoration(
              color: appTheme.colors.primaryRed,
              borderRadius: BorderRadius.circular(appTheme.radius.sm),
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Text(
            '$label: ${spacing.toStringAsFixed(0)}px',
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusExample(
    BuildContext context,
    String label,
    double radius,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: appTheme.colors.primaryRed,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Text(
            '$label: ${radius.toStringAsFixed(0)}px',
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowExample(
    BuildContext context,
    String label,
    List<BoxShadow> shadows,
  ) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: appTheme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.lightGray,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: appTheme.colors.white,
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              boxShadow: shadows,
            ),
          ),
        ],
      ),
    );
  }
}