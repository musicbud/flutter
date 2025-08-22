import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

/// Typography Showcase Component based on Figma Design
class AppTypography extends StatelessWidget {
  final bool showLabels;
  final bool showColors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppTypography({
    super.key,
    this.showLabels = true,
    this.showColors = true,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingMassive),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.neutralWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
        border: Border.all(
          color: AppTheme.neutralBlack,
          width: 10,
        ),
        boxShadow: AppTheme.shadowLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppTheme.spacingHuge),
          _buildDisplayTexts(),
          SizedBox(height: AppTheme.spacingHuge),
          _buildHeadlineTexts(),
          SizedBox(height: AppTheme.spacingHuge),
          _buildBodyTexts(),
          SizedBox(height: AppTheme.spacingHuge),
          _buildSpecialTexts(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mathematic Scale',
          style: AppTheme.displayH1.copyWith(
            color: AppTheme.neutralText,
          ),
        ),
        Text(
          ' 1.250 — Major Third - Base size 18px',
          style: AppTheme.displayH2.copyWith(
            color: AppTheme.accentRed,
            height: 1.21,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextRow('Display Text H1', AppTheme.displayH1, 'H1'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Display Text H2', AppTheme.displayH2, 'H2'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Display Text H3', AppTheme.displayH3, 'H3'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Display Text H4', AppTheme.displayH4, 'H4'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Display Text H5', AppTheme.displayH5, 'H5'),
      ],
    );
  }

  Widget _buildHeadlineTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextRow('Headline Text H6', AppTheme.headlineH6, 'H6'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Headline Text H7', AppTheme.headlineH7, 'H7'),
      ],
    );
  }

  Widget _buildBodyTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextRow('Body text H8', AppTheme.bodyH8, 'H8'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Body text H9', AppTheme.bodyH9, 'H9'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Body text H10', AppTheme.bodyH10, 'H10'),
      ],
    );
  }

  Widget _buildSpecialTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextRow('Title Large', AppTheme.titleLarge, 'Title'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Title Medium', AppTheme.titleMedium, 'Title'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Title Small', AppTheme.titleSmall, 'Title'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Caption', AppTheme.caption, 'Caption'),
        SizedBox(height: AppTheme.spacingHuge),
        _buildTextRow('Overline', AppTheme.overline, 'Overline'),
      ],
    );
  }

  Widget _buildTextRow(String label, TextStyle style, String highlight) {
    return SizedBox(
      width: 951,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label\n',
              style: style.copyWith(
                color: AppTheme.neutralText,
              ),
            ),
            TextSpan(
              text: ' $highlight',
              style: style.copyWith(
                color: AppTheme.secondaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Typography Scale Component
class TypographyScale extends StatelessWidget {
  final double baseSize;
  final double scale;
  final int levels;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const TypographyScale({
    super.key,
    this.baseSize = 18.0,
    this.scale = 1.250,
    this.levels = 10,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Typography Scale',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          ...List.generate(levels, (index) {
            final fontSize = baseSize * (scale * (index + 1));
            return Padding(
              padding: EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Level ${index + 1}',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.neutralLightGray,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacingL),
                  Text(
                    '${fontSize.toStringAsFixed(1)}px',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.primaryPink,
                    ),
                  ),
                  SizedBox(width: AppTheme.spacingXL),
                  Expanded(
                    child: Text(
                      'Sample Text for Level ${index + 1}',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.neutralWhite,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Color Palette Component
class ColorPalette extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ColorPalette({
    super.key,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color Palette',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingL,
            runSpacing: AppTheme.spacingL,
            children: [
              _buildColorSwatch('Primary Pink', AppTheme.primaryPink),
              _buildColorSwatch('Primary Pink Dark', AppTheme.primaryPinkDark),
              _buildColorSwatch('Primary Pink Light', AppTheme.primaryPinkLight),
              _buildColorSwatch('Secondary Blue', AppTheme.secondaryBlue),
              _buildColorSwatch('Secondary Purple', AppTheme.secondaryPurple),
              _buildColorSwatch('Secondary Navy', AppTheme.secondaryNavy),
              _buildColorSwatch('Neutral White', AppTheme.neutralWhite),
              _buildColorSwatch('Neutral Light Gray', AppTheme.neutralLightGray),
              _buildColorSwatch('Neutral Gray', AppTheme.neutralGray),
              _buildColorSwatch('Neutral Dark Gray', AppTheme.neutralDarkGray),
              _buildColorSwatch('Neutral Black', AppTheme.neutralBlack),
              _buildColorSwatch('Neutral Text', AppTheme.neutralText),
              _buildColorSwatch('Accent Red', AppTheme.accentRed),
              _buildColorSwatch('Accent Green', AppTheme.accentGreen),
              _buildColorSwatch('Accent Brown', AppTheme.accentBrown),
              _buildColorSwatch('Success Green', AppTheme.successGreen),
              _buildColorSwatch('Warning Orange', AppTheme.warningOrange),
              _buildColorSwatch('Error Red', AppTheme.errorRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.neutralBlack,
              width: 5,
            ),
            boxShadow: AppTheme.shadowLarge,
          ),
        ),
        SizedBox(height: AppTheme.spacingS),
        Text(
          name,
          style: AppTheme.overline.copyWith(
            color: AppTheme.neutralWhite,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppTheme.spacingS),
        Text(
          '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
          style: AppTheme.overline.copyWith(
            color: AppTheme.neutralLightGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Spacing System Component
class SpacingSystem extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SpacingSystem({
    super.key,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spacing System',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          _buildSpacingRow('XS', AppTheme.spacingXS),
          _buildSpacingRow('S', AppTheme.spacingS),
          _buildSpacingRow('M', AppTheme.spacingM),
          _buildSpacingRow('L', AppTheme.spacingL),
          _buildSpacingRow('XL', AppTheme.spacingXL),
          _buildSpacingRow('XXL', AppTheme.spacingXXL),
          _buildSpacingRow('XXXL', AppTheme.spacingXXXL),
          _buildSpacingRow('Huge', AppTheme.spacingHuge),
          _buildSpacingRow('Massive', AppTheme.spacingMassive),
        ],
      ),
    );
  }

  Widget _buildSpacingRow(String label, double spacing) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTheme.caption.copyWith(
                color: AppTheme.neutralLightGray,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacingL),
          Text(
            '${spacing.toStringAsFixed(1)}px',
            style: AppTheme.caption.copyWith(
              color: AppTheme.primaryPink,
            ),
          ),
          SizedBox(width: AppTheme.spacingXL),
          Container(
            width: spacing,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.primaryPink,
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
          ),
        ],
      ),
    );
  }
}

/// Border Radius Component
class BorderRadiusSystem extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BorderRadiusSystem({
    super.key,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Border Radius System',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingL,
            runSpacing: AppTheme.spacingL,
            children: [
              _buildRadiusExample('XS', AppTheme.radiusXS),
              _buildRadiusExample('S', AppTheme.radiusS),
              _buildRadiusExample('M', AppTheme.radiusM),
              _buildRadiusExample('L', AppTheme.radiusL),
              _buildRadiusExample('XL', AppTheme.radiusXL),
              _buildRadiusExample('XXL', AppTheme.radiusXXL),
              _buildRadiusExample('Circular', AppTheme.radiusCircular),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusExample(String label, double radius) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryPink,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        SizedBox(height: AppTheme.spacingS),
        Text(
          label,
          style: AppTheme.overline.copyWith(
            color: AppTheme.neutralWhite,
          ),
        ),
        Text(
          '${radius.toStringAsFixed(1)}px',
          style: AppTheme.overline.copyWith(
            color: AppTheme.neutralLightGray,
          ),
        ),
      ],
    );
  }
}