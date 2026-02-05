import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Interest/Tag selection component for multi-select scenarios
///
/// Perfect for:
/// - Genre selection
/// - Interest picking
/// - Tag selection
/// - Filter selection
///
/// Example:
/// ```dart
/// InterestPicker(
///   categories: [
///     InterestCategory(
///       title: 'Music Genres',
///       interests: [
///         Interest(id: 'pop', name: 'Pop', icon: Icons.music_note),
///         Interest(id: 'rock', name: 'Rock', icon: Icons.guitar),
///       ],
///     ),
///   ],
///   selectedInterests: _selectedIds,
///   onInterestsChanged: (selected) => setState(() => _selectedIds = selected),
///   minSelection: 3,
/// )
/// ```
class InterestPicker extends StatefulWidget {
  const InterestPicker({
    super.key,
    required this.categories,
    required this.selectedInterests,
    required this.onInterestsChanged,
    this.minSelection = 0,
    this.maxSelection,
    this.showCounter = true,
  });

  final List<InterestCategory> categories;
  final Set<String> selectedInterests;
  final ValueChanged<Set<String>> onInterestsChanged;
  final int minSelection;
  final int? maxSelection;
  final bool showCounter;

  @override
  State<InterestPicker> createState() => _InterestPickerState();
}

class _InterestPickerState extends State<InterestPicker> {
  void _toggleInterest(String interestId) {
    final newSelection = Set<String>.from(widget.selectedInterests);
    
    if (newSelection.contains(interestId)) {
      newSelection.remove(interestId);
    } else {
      if (widget.maxSelection == null || newSelection.length < widget.maxSelection!) {
        newSelection.add(interestId);
      }
    }
    
    widget.onInterestsChanged(newSelection);
  }

  int get _totalInterests {
    return widget.categories.fold(0, (sum, category) => sum + category.interests.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showCounter) ...[
          Center(
            child: Text(
              '${widget.selectedInterests.length}/$_totalInterests selected',
              style: (DesignSystem.bodyMedium).copyWith(
                color: DesignSystem.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.minSelection > 0 && widget.selectedInterests.length < widget.minSelection)
            Center(
              child: Text(
                'Select at least ${widget.minSelection} interests',
                style: (DesignSystem.caption).copyWith(
                  color: DesignSystem.textMuted,
                ),
              ),
            ),
          const SizedBox(height: DesignSystem.spacingLG),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              return _CategorySection(
                category: category,
                selectedInterests: widget.selectedInterests,
                onInterestTapped: _toggleInterest,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.selectedInterests,
    required this.onInterestTapped,
  });

  final InterestCategory category;
  final Set<String> selectedInterests;
  final ValueChanged<String> onInterestTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DesignSystem.spacingMD,
            horizontal: DesignSystem.spacingSM,
          ),
          child: Text(
            category.title,
            style: (DesignSystem.titleMedium).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingSM),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: category.columnsCount,
            childAspectRatio: category.aspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: category.interests.length,
          itemBuilder: (context, index) {
            final interest = category.interests[index];
            final isSelected = selectedInterests.contains(interest.id);

            return InterestChip(
              interest: interest,
              isSelected: isSelected,
              onTap: () => onInterestTapped(interest.id),
            );
          },
        ),
        const SizedBox(height: DesignSystem.spacingLG),
      ],
    );
  }
}

/// Individual interest chip
class InterestChip extends StatelessWidget {
  const InterestChip({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  final Interest interest;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignSystem.primary.withAlpha(25)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          border: Border.all(
            color: isSelected
                ? DesignSystem.primary
                : DesignSystem.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingSM,
          vertical: DesignSystem.spacingSM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (interest.icon != null) ...[
              Icon(
                interest.icon,
                color: isSelected
                    ? DesignSystem.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: DesignSystem.spacingXS),
            ],
            Expanded(
              child: Text(
                interest.name,
                style: (DesignSystem.bodySmall).copyWith(
                  color: isSelected
                      ? DesignSystem.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data models
class InterestCategory {
  const InterestCategory({
    required this.title,
    required this.interests,
    this.columnsCount = 2,
    this.aspectRatio = 2.5,
  });

  final String title;
  final List<Interest> interests;
  final int columnsCount;
  final double aspectRatio;
}

class Interest {
  const Interest({
    required this.id,
    required this.name,
    this.icon,
  });

  final String id;
  final String name;
  final IconData? icon;
}

/// Simple tag selector
class TagSelector extends StatelessWidget {
  const TagSelector({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  final List<String> tags;
  final Set<String> selectedTags;
  final ValueChanged<Set<String>> onTagsChanged;

  void _toggleTag(String tag) {
    final newSelection = Set<String>.from(selectedTags);
    if (newSelection.contains(tag)) {
      newSelection.remove(tag);
    } else {
      newSelection.add(tag);
    }
    onTagsChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignSystem.spacingSM,
      runSpacing: DesignSystem.spacingSM,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (_) => _toggleTag(tag),
        );
      }).toList(),
    );
  }
}

/// Genre picker specifically for music
class GenrePicker extends StatelessWidget {
  const GenrePicker({
    super.key,
    required this.selectedGenres,
    required this.onGenresChanged,
  });

  final Set<String> selectedGenres;
  final ValueChanged<Set<String>> onGenresChanged;

  static final List<InterestCategory> _musicGenres = [
    const InterestCategory(
      title: 'Popular Genres',
      interests: [
        Interest(id: 'pop', name: 'Pop', icon: Icons.music_note),
        Interest(id: 'rock', name: 'Rock', icon: Icons.music_note),
        Interest(id: 'hip_hop', name: 'Hip Hop', icon: Icons.headphones),
        Interest(id: 'electronic', name: 'Electronic', icon: Icons.flash_on),
        Interest(id: 'r_b', name: 'R&B', icon: Icons.favorite),
        Interest(id: 'country', name: 'Country', icon: Icons.landscape),
      ],
    ),
    const InterestCategory(
      title: 'Classic Genres',
      interests: [
        Interest(id: 'jazz', name: 'Jazz', icon: Icons.piano),
        Interest(id: 'classical', name: 'Classical', icon: Icons.music_note),
        Interest(id: 'blues', name: 'Blues', icon: Icons.music_note),
        Interest(id: 'reggae', name: 'Reggae', icon: Icons.music_note),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return InterestPicker(
      categories: _musicGenres,
      selectedInterests: selectedGenres,
      onInterestsChanged: onGenresChanged,
      minSelection: 3,
    );
  }
}