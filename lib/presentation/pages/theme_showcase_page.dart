import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input_field.dart';
import '../widgets/common/app_typography.dart';

/// Theme Showcase Page - Demonstrates all reusable components
class ThemeShowcasePage extends StatefulWidget {
  const ThemeShowcasePage({super.key});

  @override
  State<ThemeShowcasePage> createState() => _ThemeShowcasePageState();
}

class _ThemeShowcasePageState extends State<ThemeShowcasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralBlack,
      appBar: AppBar(
        title: Text(
          'MusicBud Design System',
          style: AppTheme.titleSmall.copyWith(
            color: AppTheme.neutralWhite,
          ),
        ),
        backgroundColor: AppTheme.neutralBlack,
        foregroundColor: AppTheme.neutralWhite,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryPink,
          labelColor: AppTheme.primaryPink,
          unselectedLabelColor: AppTheme.neutralLightGray,
          tabs: const [
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          AppTypography(),
          SizedBox(height: AppTheme.spacingHuge),
          TypographyScale(),
        ],
      ),
    );
  }

  Widget _buildColorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          ColorPalette(),
          SizedBox(height: AppTheme.spacingHuge),
          _buildColorUsageExamples(),
        ],
      ),
    );
  }

  Widget _buildButtonsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Button Variants',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppButtons.primary(
                text: 'Primary Button',
                onPressed: () => _showSnackBar('Primary Button Pressed'),
              ),
              AppButtons.secondary(
                text: 'Secondary Button',
                onPressed: () => _showSnackBar('Secondary Button Pressed'),
              ),
              AppButtons.ghost(
                text: 'Ghost Button',
                onPressed: () => _showSnackBar('Ghost Button Pressed'),
              ),
              AppButton(
                text: 'Text Button',
                variant: AppButtonVariant.text,
                onPressed: () => _showSnackBar('Text Button Pressed'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Button Sizes',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppButton(
                text: 'Small',
                size: AppButtonSize.small,
                onPressed: () => _showSnackBar('Small Button Pressed'),
              ),
              AppButton(
                text: 'Medium',
                size: AppButtonSize.medium,
                onPressed: () => _showSnackBar('Medium Button Pressed'),
              ),
              AppButton(
                text: 'Large',
                size: AppButtonSize.large,
                onPressed: () => _showSnackBar('Large Button Pressed'),
              ),
              AppButton(
                text: 'XLarge',
                size: AppButtonSize.xlarge,
                onPressed: () => _showSnackBar('XLarge Button Pressed'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Special Button Styles',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppButtons.matchNow(
                text: 'Match Now',
                onPressed: () => _showSnackBar('Match Now Pressed'),
              ),
              AppButtons.tag(
                text: 'Music',
                onPressed: () => _showSnackBar('Music Tag Pressed'),
              ),
              AppButtons.tag(
                text: 'Anime',
                onPressed: () => _showSnackBar('Anime Tag Pressed'),
              ),
              AppButtons.tag(
                text: 'Movies',
                onPressed: () => _showSnackBar('Movies Tag Pressed'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Button with Icons',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppButton(
                text: 'Play',
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _showSnackBar('Play Button Pressed'),
              ),
              AppButton(
                text: 'Like',
                icon: const Icon(Icons.favorite),
                variant: AppButtonVariant.secondary,
                onPressed: () => _showSnackBar('Like Button Pressed'),
              ),
              AppButton(
                text: 'Share',
                icon: const Icon(Icons.share),
                variant: AppButtonVariant.ghost,
                onPressed: () => _showSnackBar('Share Button Pressed'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Loading States',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppButton(
                text: 'Loading...',
                isLoading: true,
                onPressed: () {},
              ),
              AppButton(
                text: 'Loading...',
                variant: AppButtonVariant.secondary,
                isLoading: true,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Variants',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: [
              AppCards.musicTrack(
                child: AppCardComponents.musicTrackCard(
                  imageUrl: 'https://placehold.co/70x70',
                  title: 'Waves of Stardust',
                  artist: 'Midnight Echoes',
                  subtitle: 'Popular track this week',
                ),
              ),
              AppCards.profile(
                child: AppCardComponents.profileCard(
                  imageUrl: 'https://placehold.co/100x100',
                  name: 'Emily',
                  age: '24',
                  location: 'UK - London',
                  description: 'A passionate marketing specialist with a flair for creativity and innovation.',
                ),
              ),
              AppCards.event(
                child: AppCardComponents.eventCard(
                  title: 'Annual Harmony Music Festival!',
                  date: 'Wednesday, 14 May, 2025',
                  location: 'Harmony Heights Festival, Banff National Park',
                  description: 'Join us for three days of unforgettable music featuring top artists across various genres.',
                  attendees: [
                    'https://placehold.co/55x55',
                    'https://placehold.co/55x55',
                    'https://placehold.co/55x55',
                    'https://placehold.co/55x55',
                    'https://placehold.co/55x55',
                  ],
                  onGoing: () => _showSnackBar('Going to event!'),
                  onInterested: () => _showSnackBar('Interested in event!'),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Card with Custom Styling',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          AppCard(
            variant: AppCardVariant.glass,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Glass Card',
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.neutralWhite,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  'This is a glass card with semi-transparent background and border.',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.neutralLightGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Field Variants',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          AppInputs.search(
            hintText: 'Search for music, artists, or playlists...',
            onChanged: (value) => _showSnackBar('Searching for: $value'),
            onSubmitted: (value) => _showSnackBar('Submitted: $value'),
          ),
          SizedBox(height: AppTheme.spacingHuge),
          AppInputs.chat(
            hintText: 'Type your message here...',
            onChanged: (value) => _showSnackBar('Typing: $value'),
            onSubmitted: (value) => _showSnackBar('Message sent: $value'),
          ),
          SizedBox(height: AppTheme.spacingHuge),
          AppInputs.profile(
            label: 'Full Name',
            hintText: 'Enter your full name',
            onChanged: (value) => _showSnackBar('Name: $value'),
          ),
          SizedBox(height: AppTheme.spacingHuge),
          AppInputs.event(
            label: 'Event Title',
            hintText: 'Enter event title',
            onChanged: (value) => _showSnackBar('Event title: $value'),
          ),
          SizedBox(height: AppTheme.spacingHuge),
          Text(
            'Custom Input Fields',
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          AppInputField(
            label: 'Custom Input',
            hintText: 'This is a custom input field',
            variant: AppInputVariant.light,
            size: AppInputSize.large,
            onChanged: (value) => _showSnackBar('Custom input: $value'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          SpacingSystem(),
          SizedBox(height: AppTheme.spacingHuge),
          BorderRadiusSystem(),
        ],
      ),
    );
  }

  Widget _buildColorUsageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Usage Examples',
          style: AppTheme.titleSmall.copyWith(
            color: AppTheme.neutralWhite,
          ),
        ),
        SizedBox(height: AppTheme.spacingL),
        Wrap(
          spacing: AppTheme.spacingM,
          runSpacing: AppTheme.spacingM,
          children: [
            _buildColorExample('Primary', AppTheme.primaryPink),
            _buildColorExample('Secondary', AppTheme.secondaryBlue),
            _buildColorExample('Success', AppTheme.successGreen),
            _buildColorExample('Warning', AppTheme.warningOrange),
            _buildColorExample('Error', AppTheme.errorRed),
            _buildColorExample('Neutral', AppTheme.neutralLightGray),
          ],
        ),
      ],
    );
  }

  Widget _buildColorExample(String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.neutralWhite,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTheme.caption.copyWith(
          color: _getContrastColor(color),
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppTheme.neutralBlack : AppTheme.neutralWhite;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }
}