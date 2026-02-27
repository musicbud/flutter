import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class AppTypography extends StatelessWidget {
  const AppTypography({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.surface,
      appBar: AppBar(
        title: Text(
          'Typography System',
          style: DesignSystem.headlineMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: DesignSystem.surface,
        foregroundColor: Colors.white,
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
                    color: DesignSystem.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display Medium',
                  DesignSystem.displayMedium.copyWith(
                    color: DesignSystem.primaryRed,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Display Small',
                  DesignSystem.displaySmall.copyWith(
                    color: DesignSystem.primaryRed,
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
                  'Headline Medium',
                  DesignSystem.headlineMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Headline Small',
                  DesignSystem.headlineSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Large',
                  DesignSystem.titleLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Medium',
                  DesignSystem.titleMedium.copyWith(
                    color: Colors.white,
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
                  'Body H8',
                  DesignSystem.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body H9',
                  DesignSystem.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Body H10',
                  DesignSystem.bodySmall.copyWith(
                    color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Medium',
                  DesignSystem.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Title Small',
                  DesignSystem.titleSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                _buildTypographyExample(
                  context,
                  'Caption',
                  DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
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
                  Colors.white,
                ),
                _buildFontFamilyExample(
                  context,
                  'Secondary Font',
                  DesignSystem.fontFamilySecondary,
                  Colors.white,
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
                  'Primary Red',
                  DesignSystem.primaryRed,
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
                  'Dark Tone',
                  DesignSystem.surface,
                ),
                _buildColorExample(
                  context,
                  'Light Gray',
                  DesignSystem.onSurfaceVariant,
                ),
                _buildColorExample(
                  context,
                  'White',
                  Colors.white,
                ),
                _buildColorExample(
                  context,
                  'Black',
                  DesignSystem.onSurface,
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
                  DesignSystem.neutral50,
                ),
                _buildColorExample(
                  context,
                  'Neutral 100',
                  DesignSystem.neutral100,
                ),
                _buildColorExample(
                  context,
                  'Neutral 200',
                  DesignSystem.neutral200,
                ),
                _buildColorExample(
                  context,
                  'Neutral 300',
                  DesignSystem.neutral300,
                ),
                _buildColorExample(
                  context,
                  'Neutral 400',
                  DesignSystem.neutral400,
                ),
                _buildColorExample(
                  context,
                  'Neutral 500',
                  DesignSystem.neutral500,
                ),
                _buildColorExample(
                  context,
                  'Neutral 600',
                  DesignSystem.neutral600,
                ),
                _buildColorExample(
                  context,
                  'Neutral 700',
                  DesignSystem.neutral700,
                ),
                _buildColorExample(
                  context,
                  'Neutral 800',
                  DesignSystem.neutral800,
                ),
                _buildColorExample(
                  context,
                  'Neutral 900',
                  DesignSystem.neutral900,
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
                  'Spacing S',
                  DesignSystem.spacingSM,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing M',
                  DesignSystem.spacingMD,
                ),
                _buildSpacingExample(
                  context,
                  'Spacing L',
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
                  'Radius S',
                  DesignSystem.radiusSM,
                ),
                _buildRadiusExample(
                  context,
                  'Radius M',
                  DesignSystem.radiusMD,
                ),
                _buildRadiusExample(
                  context,
                  'Radius L',
                  DesignSystem.radiusLG,
                ),
                _buildRadiusExample(
                  context,
                  'Radius XL',
                  DesignSystem.radiusXL,
                ),
                _buildRadiusExample(
                  context,
                  'Radius Circular',
                  DesignSystem.radiusFull,
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
          style: DesignSystem.titleLarge.copyWith(
            color: DesignSystem.primaryRed,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          decoration: BoxDecoration(
            color: DesignSystem.surface,
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            border: Border.all(
              color: DesignSystem.onSurfaceVariant.withAlpha((255 * 0.2).round()),
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
                color: DesignSystem.onSurfaceVariant.withAlpha((255 * 0.3).round()),
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
                  style: DesignSystem.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '#${color.red.toRadixString(16).padLeft(2, '0')}'
                  '${color.green.toRadixString(16).padLeft(2, '0')}'
                  '${color.blue.toRadixString(16).padLeft(2, '0')}',
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
              color: DesignSystem.primaryRed,
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
              color: DesignSystem.primaryRed,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              boxShadow: shadows,
            ),
          ),
        ],
      ),
    );
  }
}