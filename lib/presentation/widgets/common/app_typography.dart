import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

class AppTypography extends StatelessWidget {
  const AppTypography({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>()!;

    return Scaffold(
      backgroundColor: design.designSystemColors.surface,
      appBar: AppBar(
        title: Text(
          'Typography System',
          style: design.designSystemTypography.headlineMedium.copyWith(
            color: design.designSystemColors.white,
          ),
        ),
        backgroundColor: design.designSystemColors.surface,
        foregroundColor: design.designSystemColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(design.designSystemSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypographySection(
              context,
              design,
              'Display Typography',
              [
                _buildTypographyExample(
                  context,
                  design,
                  'Display Large',
                  design.designSystemTypography.displayLarge.copyWith(
                    color: design.designSystemColors.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Display Medium',
                  design.designSystemTypography.displayMedium.copyWith(
                    color: design.designSystemColors.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Display Small',
                  design.designSystemTypography.displaySmall.copyWith(
                    color: design.designSystemColors.primaryRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Headline Typography',
              [
                _buildTypographyExample(
                  context,
                  design,
                  'Headline Medium',
                  design.designSystemTypography.headlineMedium.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Headline Small',
                  design.designSystemTypography.headlineSmall.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Title Large',
                  design.designSystemTypography.titleLarge.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Title Medium',
                  design.designSystemTypography.titleMedium.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Body Typography',
              [
                _buildTypographyExample(
                  context,
                  design,
                  'Body H8',
                  design.designSystemTypography.bodyLarge.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Body H9',
                  design.designSystemTypography.bodyMedium.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Body H10',
                  design.designSystemTypography.bodySmall.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Title Typography',
              [
                _buildTypographyExample(
                  context,
                  design,
                  'Title Large',
                  design.designSystemTypography.titleLarge.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Title Medium',
                  design.designSystemTypography.titleMedium.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Title Small',
                  design.designSystemTypography.titleSmall.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Caption',
                  design.designSystemTypography.caption.copyWith(
                    color: design.designSystemColors.onSurfaceVariant,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  design,
                  'Overline',
                  design.designSystemTypography.overline.copyWith(
                    color: design.designSystemColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Arabic Typography',
              [
                _buildTypographyExample(
                  context,
                  design,
                  'Arabic Text',
                  design.designSystemTypography.arabicText.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Font Families',
              [
                _buildFontFamilyExample(
                  context,
                  design,
                  'Primary Font',
                  DesignSystem.fontFamilyPrimary,
                  design.designSystemColors.white,
                ),
                _buildFontFamilyExample(
                  context,
                  design,
                  'Secondary Font',
                  DesignSystem.fontFamilySecondary,
                  design.designSystemColors.white,
                ),
                _buildFontFamilyExample(
                  context,
                  design,
                  'Arabic Font',
                  DesignSystem.fontFamilyArabic,
                  design.designSystemColors.white,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Color Palette',
              [
                _buildColorExample(
                  context,
                  design,
                  'Primary Red',
                  design.designSystemColors.primaryRed,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Secondary',
                  design.designSystemColors.secondary,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Accent Blue',
                  design.designSystemColors.accentBlue,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Neutral Colors',
              [
                _buildColorExample(
                  context,
                  design,
                  'Dark Tone',
                  design.designSystemColors.surface,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Light Gray',
                  design.designSystemColors.onSurfaceVariant,
                ),
                _buildColorExample(
                  context,
                  design,
                  'White',
                  design.designSystemColors.white,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Black',
                  design.designSystemColors.onSurface,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Semantic Colors',
              [
                _buildColorExample(
                  context,
                  design,
                  'Success',
                  design.designSystemColors.success,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Warning',
                  design.designSystemColors.warning,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Error',
                  design.designSystemColors.error,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Info',
                  design.designSystemColors.info,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Neutral Palette',
              [
                _buildColorExample(
                  context,
                  design,
                  'Neutral 50',
                  DesignSystem.neutral[50]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 100',
                  DesignSystem.neutral[100]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 200',
                  DesignSystem.neutral[200]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 300',
                  DesignSystem.neutral[300]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 400',
                  DesignSystem.neutral[400]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 500',
                  DesignSystem.neutral[500]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 600',
                  DesignSystem.neutral[600]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 700',
                  DesignSystem.neutral[700]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 800',
                  DesignSystem.neutral[800]!,
                ),
                _buildColorExample(
                  context,
                  design,
                  'Neutral 900',
                  DesignSystem.neutral[900]!,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Spacing System',
              [
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing XS',
                  design.designSystemSpacing.xs,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing S',
                  design.designSystemSpacing.sm,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing M',
                  design.designSystemSpacing.md,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing L',
                  design.designSystemSpacing.lg,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing XL',
                  design.designSystemSpacing.xl,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing XXL',
                  design.designSystemSpacing.xxl,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing XXXL',
                  design.designSystemSpacing.xxxl,
                ),
                _buildSpacingExample(
                  context,
                  design,
                  'Spacing Huge',
                  design.designSystemSpacing.huge,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Border Radius',
              [
                _buildRadiusExample(
                  context,
                  design,
                  'Radius XS',
                  design.designSystemRadius.xs,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius S',
                  design.designSystemRadius.sm,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius M',
                  design.designSystemRadius.md,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius L',
                  design.designSystemRadius.lg,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius XL',
                  design.designSystemRadius.xl,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius XXL',
                  design.designSystemRadius.xxl,
                ),
                _buildRadiusExample(
                  context,
                  design,
                  'Radius Circular',
                  design.designSystemRadius.circular,
                ),
              ],
            ),
            SizedBox(height: design.designSystemSpacing.xl),
            _buildTypographySection(
              context,
              design,
              'Shadows',
              [
                _buildShadowExample(
                  context,
                  design,
                  'Shadow Small',
                  design.designSystemShadows.small,
                ),
                _buildShadowExample(
                  context,
                  design,
                  'Shadow Medium',
                  design.designSystemShadows.medium,
                ),
                _buildShadowExample(
                  context,
                  design,
                  'Shadow Large',
                  design.designSystemShadows.large,
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
    DesignSystemThemeExtension design,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: design.designSystemTypography.titleLarge.copyWith(
            color: design.designSystemColors.primaryRed,
          ),
        ),
        SizedBox(height: design.designSystemSpacing.md),
        Container(
          padding: EdgeInsets.all(design.designSystemSpacing.md),
          decoration: BoxDecoration(
            color: design.designSystemColors.surface,
            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
            border: Border.all(
              color: design.designSystemColors.onSurfaceVariant.withValues(alpha: 0.2),
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
    DesignSystemThemeExtension design,
    String label,
    TextStyle style,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.designSystemSpacing.sm),
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
    DesignSystemThemeExtension design,
    String label,
    String fontFamily,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.designSystemSpacing.sm),
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
    DesignSystemThemeExtension design,
    String label,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
              border: Border.all(
                color: design.designSystemColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          SizedBox(width: design.designSystemSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: design.designSystemTypography.bodyMedium.copyWith(
                    color: design.designSystemColors.white,
                  ),
                ),
                Text(
                  '#${color.toARGB32().toRadixString(16).toUpperCase()}',
                  style: design.designSystemTypography.caption.copyWith(
                    color: design.designSystemColors.onSurfaceVariant,
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
    DesignSystemThemeExtension design,
    String label,
    double spacing,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Row(
        children: [
          Container(
            width: spacing,
            height: 20,
            decoration: BoxDecoration(
              color: design.designSystemColors.primaryRed,
              borderRadius: BorderRadius.circular(design.designSystemRadius.sm),
            ),
          ),
          SizedBox(width: design.designSystemSpacing.md),
          Text(
            '$label: ${spacing.toStringAsFixed(0)}px',
            style: design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusExample(
    BuildContext context,
    DesignSystemThemeExtension design,
    String label,
    double radius,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: design.designSystemColors.primaryRed,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          SizedBox(width: design.designSystemSpacing.md),
          Text(
            '$label: ${radius.toStringAsFixed(0)}px',
            style: design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowExample(
    BuildContext context,
    DesignSystemThemeExtension design,
    String label,
    List<BoxShadow> shadows,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.designSystemSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: design.designSystemTypography.caption.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.designSystemSpacing.sm),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: design.designSystemColors.white,
              borderRadius: BorderRadius.circular(design.designSystemRadius.md),
              boxShadow: shadows,
            ),
          ),
        ],
      ),
    );
  }
}