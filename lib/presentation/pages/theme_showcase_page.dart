import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

/// Theme Showcase Page - Demonstrates all reusable components
class ThemeShowcasePage extends StatefulWidget {
  const ThemeShowcasePage({super.key});

  @override
  State<ThemeShowcasePage> createState() => _ThemeShowcasePageState();
}

class _ThemeShowcasePageState extends State<ThemeShowcasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      appBar: AppBar(
        backgroundColor: appTheme.colors.surface,
        elevation: 0,
        title: Text(
          'Design System Showcase',
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: appTheme.colors.primary,
          unselectedLabelColor: appTheme.colors.lightGray,
          indicatorColor: appTheme.colors.primary,
          tabs: [
            Tab(text: 'Typography'),
            Tab(text: 'Colors'),
            Tab(text: 'Buttons'),
            Tab(text: 'Cards'),
            Tab(text: 'Inputs'),
            Tab(text: 'Spacing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTypographyTab(),
          _buildColorsTab(),
          _buildButtonsTab(),
          _buildCardsTab(),
          _buildInputsTab(),
          _buildSpacingTab(),
        ],
      ),
    );
  }

  Widget _buildTypographyTab() {
    return const AppTypography();
  }

  Widget _buildColorsTab() {
    return const ColorPalette();
  }

  Widget _buildButtonsTab() {
    final appTheme = AppTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Button Components',
            style: appTheme.typography.displayH2.copyWith(
              color: appTheme.colors.primary,
            ),
          ),
          SizedBox(height: appTheme.spacing.xl),

          // Button Variants
          _buildButtonSection(
            'Button Variants',
            [
              AppButtons.primary(text: 'Primary Button', onPressed: () => _showSnackBar('Primary pressed')),
              AppButtons.secondary(text: 'Secondary Button', onPressed: () => _showSnackBar('Secondary pressed')),
              AppButtons.ghost(text: 'Ghost Button', onPressed: () => _showSnackBar('Ghost pressed')),
              AppButtons.tag(text: 'Tag Button', onPressed: () => _showSnackBar('Tag pressed')),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Button Sizes
          _buildButtonSection(
            'Button Sizes',
            [
              AppButtons.primary(text: 'Small', onPressed: () {}, size: AppButtonSize.small),
              AppButtons.primary(text: 'Medium', onPressed: () {}, size: AppButtonSize.medium),
              AppButtons.primary(text: 'Large', onPressed: () {}, size: AppButtonSize.large),
              AppButtons.primary(text: 'XLarge', onPressed: () {}, size: AppButtonSize.xlarge),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Buttons with Icons
          _buildButtonSection(
            'Buttons with Icons',
            [
              AppButtons.primary(text: 'With Icon', onPressed: () {}, icon: Icons.star),
              AppButtons.secondary(text: 'With Icon', onPressed: () {}, icon: Icons.favorite),
              AppButtons.ghost(text: 'With Icon', onPressed: () {}, icon: Icons.thumb_up),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Loading States
          _buildButtonSection(
            'Loading States',
            [
              AppButton(
                text: 'Loading...',
                onPressed: () {},
                isLoading: true,
              ),
              AppButton(
                text: 'Disabled',
                onPressed: () {},
                isDisabled: true,
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Custom Colors
          _buildButtonSection(
            'Custom Colors',
            [
              AppButtons.ghost(
                text: 'Custom Ghost',
                onPressed: () {},
                textColor: appTheme.colors.success,
                borderColor: appTheme.colors.success,
              ),
              AppButtons.ghost(
                text: 'Custom Ghost 2',
                onPressed: () {},
                textColor: appTheme.colors.warning,
                borderColor: appTheme.colors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardsTab() {
    final appTheme = AppTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Components',
            style: appTheme.typography.displayH2.copyWith(
              color: appTheme.colors.primary,
            ),
          ),
          SizedBox(height: appTheme.spacing.xl),

          // Card Variants
          _buildCardSection(
            'Card Variants',
            [
              AppCards.defaultCard(
                child: Text(
                  'Default Card',
                  style: appTheme.typography.titleMedium,
                ),
              ),
              AppCards.white(
                child: Text(
                  'White Card',
                  style: appTheme.typography.titleMedium.copyWith(color: appTheme.colors.darkTone),
                ),
              ),
              AppCards.transparent(
                child: Text(
                  'Transparent Card',
                  style: appTheme.typography.titleMedium,
                ),
              ),
              AppCards.glass(
                child: Text(
                  'Glass Card',
                  style: appTheme.typography.titleMedium,
                ),
              ),
              AppCards.gradient(
                child: Text(
                  'Gradient Card',
                  style: appTheme.typography.titleMedium.copyWith(color: appTheme.colors.white),
                ),
              ),
              AppCards.outlined(
                child: Text(
                  'Outlined Card',
                  style: appTheme.typography.titleMedium,
                ),
              ),
              AppCards.bordered(
                child: Text(
                  'Bordered Card',
                  style: appTheme.typography.titleMedium,
                ),
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Predefined Card Styles
          _buildCardSection(
            'Predefined Card Styles',
            [
              AppCards.musicTrack(
                title: 'Sample Track',
                subtitle: 'Sample Artist',
                imageUrl: 'https://via.placeholder.com/160x120',
                onTap: () => _showSnackBar('Music track tapped'),
              ),
              AppCards.profile(
                title: 'Sample Profile',
                subtitle: 'Sample Description',
                imageUrl: 'https://via.placeholder.com/60x60',
                onTap: () => _showSnackBar('Profile tapped'),
              ),
              AppCards.event(
                title: 'Sample Event',
                subtitle: 'Sample Event Description',
                date: 'Dec 25, 2024',
                location: 'Sample Location',
                imageUrl: 'https://via.placeholder.com/160x120',
                onTap: () => _showSnackBar('Event tapped'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputsTab() {
    final appTheme = AppTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Field Components',
            style: appTheme.typography.displayH2.copyWith(
              color: appTheme.colors.primary,
            ),
          ),
          SizedBox(height: appTheme.spacing.xl),

          // Input Variants
          _buildInputSection(
            'Input Variants',
            [
              AppInputs.search(
                hintText: 'Search variant...',
                onChanged: (value) {},
              ),
              AppInputs.chat(
                hintText: 'Chat variant...',
                onChanged: (value) {},
              ),
              AppInputs.profile(
                label: 'Profile Input',
                hintText: 'Profile variant...',
                onChanged: (value) {},
              ),
              AppInputs.event(
                label: 'Event Input',
                hintText: 'Event variant...',
                onChanged: (value) {},
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Input Sizes
          _buildInputSection(
            'Input Sizes',
            [
              AppInputField(
                hintText: 'Small input',
                onChanged: (value) {},
                size: AppInputSize.small,
              ),
              AppInputField(
                hintText: 'Medium input',
                onChanged: (value) {},
                size: AppInputSize.medium,
              ),
              AppInputField(
                hintText: 'Large input',
                onChanged: (value) {},
                size: AppInputSize.large,
              ),
              AppInputField(
                hintText: 'XLarge input',
                onChanged: (value) {},
                size: AppInputSize.xlarge,
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Input with Icons
          _buildInputSection(
            'Inputs with Icons',
            [
              AppInputField(
                hintText: 'With prefix icon',
                onChanged: (value) {},
                prefixIcon: Icon(Icons.person),
              ),
              AppInputField(
                hintText: 'With suffix icon',
                onChanged: (value) {},
                suffixIcon: Icon(Icons.visibility),
              ),
              AppInputField(
                hintText: 'With both icons',
                onChanged: (value) {},
                prefixIcon: Icon(Icons.email),
                suffixIcon: Icon(Icons.check_circle),
              ),
            ],
          ),

          SizedBox(height: appTheme.spacing.xl),

          // Input with Labels
          _buildInputSection(
            'Inputs with Labels',
            [
              AppInputField(
                label: 'Email Address',
                hintText: 'Enter your email',
                onChanged: (value) {},
                keyboardType: TextInputType.emailAddress,
              ),
              AppInputField(
                label: 'Password',
                hintText: 'Enter your password',
                onChanged: (value) {},
                obscureText: true,
              ),
              AppInputField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                onChanged: (value) {},
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingTab() {
    return Column(
      children: [
        Expanded(child: SpacingSystem()),
        Expanded(child: BorderRadiusSystem()),
      ],
    );
  }

  Widget _buildButtonSection(String title, List<Widget> children) {
    final appTheme = AppTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appTheme.spacing.m),
        Wrap(
          spacing: appTheme.spacing.m,
          runSpacing: appTheme.spacing.m,
          children: children,
        ),
      ],
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    final appTheme = AppTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appTheme.spacing.m),
        ...children.map((child) => Padding(
          padding: EdgeInsets.only(bottom: appTheme.spacing.m),
          child: child,
        )),
      ],
    );
  }

  Widget _buildInputSection(String title, List<Widget> children) {
    final appTheme = AppTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appTheme.spacing.m),
        ...children.map((child) => Padding(
          padding: EdgeInsets.only(bottom: appTheme.spacing.m),
          child: child,
        )),
      ],
    );
  }

  void _showSnackBar(String message) {
    final appTheme = AppTheme();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: appTheme.typography.bodyH9.copyWith(
            color: appTheme.colors.white,
          ),
        ),
        backgroundColor: appTheme.colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.m),
        ),
      ),
    );
  }
}