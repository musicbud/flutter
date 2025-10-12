import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

class AppTypography extends StatelessWidget {
  const AppTypography({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.surface,
      appBar: AppBar(
        title: Text(
          'Typography System',
          style: DesignSystem.headlineLarge.copyWith(
            color: DesignSystem.onSurface,
          ),
        ),
        backgroundColor: DesignSystem.surface,
        foregroundColor: DesignSystem.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypographySection(
              context,
              'Display Typography',
              [
                _buildTypographyExample(
                  context,
                  'Display Large',
                  DesignSystem.displayLarge.copyWith(
                    color: DesignSystem.primary,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display Medium',
                  DesignSystem.displayMedium.copyWith(
                    color: DesignSystem.primary,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display Small',
                  DesignSystem.displaySmall.copyWith(
                    color: DesignSystem.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Headline Typography',
              [
                _buildTypographyExample(
                  context,
                  'Headline Large',
                  DesignSystem.headlineLarge.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline Medium',
                  DesignSystem.headlineMedium.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline Small',
                  DesignSystem.headlineSmall.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Body Typography',
              [
                _buildTypographyExample(
                  context,
                  'Body Large',
                  DesignSystem.bodyLarge.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body Medium',
                  DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body Small',
                  DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Title Typography',
              [
                _buildTypographyExample(
                  context,
                  'Title Large',
                  DesignSystem.titleLarge.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Medium',
                  DesignSystem.titleMedium.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Small',
                  DesignSystem.titleSmall.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Caption',
                  DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Overline',
                  DesignSystem.overline.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Arabic Typography',
              [
                _buildTypographyExample(
                  context,
                  'Arabic Text',
                  DesignSystem.arabicText.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Font Families',
              [
                _buildFontFamilyExample(
                  context,
                  'Primary Font',
                  DesignSystem.fontFamilyPrimary,
                  DesignSystem.onSurface,
                ),
                _buildFontFamilyExample(
                  context,
                  'Secondary Font',
                  DesignSystem.fontFamilySecondary,
                  DesignSystem.onSurface,
                ),
                _buildFontFamilyExample(
                  context,
                  'Arabic Font',
                  DesignSystem.fontFamilyArabic,
                  DesignSystem.onSurface,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Color Palette',
              [
                _buildColorExample(
                  context,
                  'Primary',
                  DesignSystem.primary,
                ),
                _buildColorExample(
                  context,
                  'Secondary',
                  DesignSystem.secondary,
                ),
                _buildColorExample(
                  context,
                  'Accent Blue',
                  DesignSystem.accentBlue,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Neutral Colors',
              [
                _buildColorExample(
                  context,
                  'Surface',
                  DesignSystem.surface,
                ),
                _buildColorExample(
                  context,
                  'On Surface',
                  DesignSystem.onSurface,
                ),
                _buildColorExample(
                  context,
                  'On Surface Variant',
                  DesignSystem.onSurfaceVariant,
                ),
                _buildColorExample(
                  context,
                  'Border',
                  DesignSystem.border,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Semantic Colors',
              [
                _buildColorExample(
                  context,
                  'Success',
                  DesignSystem.success,
                ),
                _buildColorExample(
                  context,
                  'Warning',
                  DesignSystem.warning,
                ),
                _buildColorExample(
                  context,
                  'Error',
                  DesignSystem.error,
                ),
                _buildColorExample(
                  context,
                  'Info',
                  DesignSystem.info,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Neutral Palette',
              [
                _buildColorExample(
                  context,
                  'Neutral 50',
                  DesignSystem.neutral[50]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 100',
                  DesignSystem.neutral[100]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 200',
                  DesignSystem.neutral[200]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 300',
                  DesignSystem.neutral[300]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 400',
                  DesignSystem.neutral[400]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 500',
                  DesignSystem.neutral[500]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 600',
                  DesignSystem.neutral[600]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 700',
                  DesignSystem.neutral[700]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 800',
                  DesignSystem.neutral[800]!,
                ),
                _buildColorExample(
                  context,
                  'Neutral 900',
                  DesignSystem.neutral[900]!,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Spacing System',
              [
                _buildSpacingExample(
                  context,
                  'Spacing XS',
                  DesignSystem.spacingXS,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing SM',
                  DesignSystem.spacingSM,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing MD',
                  DesignSystem.spacingMD,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing LG',
                  DesignSystem.spacingLG,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XL',
                  DesignSystem.spacingXL,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XXL',
                  DesignSystem.spacingXXL,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing XXXL',
                  DesignSystem.spacingXXXL,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing Huge',
                  DesignSystem.spacingHuge,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Border Radius',
              [
                _buildRadiusExample(
                  context,
                  'Radius XS',
                  DesignSystem.radiusXS,
                ),
                _buildRadiusExample(
                  context,
                  'Radius SM',
                  DesignSystem.radiusSM,
                ),
                _buildRadiusExample(
                  context,
                  'Radius MD',
                  DesignSystem.radiusMD,
                ),
                _buildRadiusExample(
                  context,
                  'Radius LG',
                  DesignSystem.radiusLG,
                ),
                _buildRadiusExample(
                  context,
                  'Radius XL',
                  DesignSystem.radiusXL,
                ),
                _buildRadiusExample(
                  context,
                  'Radius XXL',
                  DesignSystem.radiusXXL,
                ),
                _buildRadiusExample(
                  context,
                  'Radius Circular',
                  DesignSystem.radiusCircular,
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildTypographySection(
              context,
              'Shadows',
              [
                _buildShadowExample(
                  context,
                  'Shadow Small',
                  DesignSystem.shadowSmall,
                ),
                _buildShadowExample(
                  context,
                  'Shadow Medium',
                  DesignSystem.shadowMedium,
                ),
                _buildShadowExample(
                  context,
                  'Shadow Large',
                  DesignSystem.shadowLarge,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.primary,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            border: Border.all(
              color: DesignSystem.onSurfaceVariant.withOpacity(0.2),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
              border: Border.all(
                color: DesignSystem.onSurfaceVariant.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurface,
                  ),
                ),
                Text(
                  '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Row(
        children: [
          Container(
            width: spacing,
            height: 20,
            decoration: BoxDecoration(
              color: DesignSystem.primary,
              borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          Text(
            '$label: ${spacing.toStringAsFixed(0)}px',
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: DesignSystem.primary,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          Text(
            '$label: ${radius.toStringAsFixed(0)}px',
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: DesignSystem.onSurface,
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              boxShadow: shadows,
            ),
          ),
        ],
      ),
    );
  }
}