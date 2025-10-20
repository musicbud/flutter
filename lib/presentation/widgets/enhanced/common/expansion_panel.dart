import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern expansion panel with smooth animations
///
/// Supports:
/// - Single and multiple expansion
/// - Custom headers and content
/// - Icons and trailing widgets
/// - Accordion-style groups
///
/// Example:
/// ```dart
/// ModernExpansionPanel(
///   title: 'Playlist Settings',
///   children: [
///     ListTile(title: Text('Setting 1')),
///     ListTile(title: Text('Setting 2')),
///   ],
/// )
/// ```
class ModernExpansionPanel extends StatefulWidget {
  const ModernExpansionPanel({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.borderRadius,
  });

  final String title;
  final List<Widget> children;
  final String? subtitle;
  final Widget? leading;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? backgroundColor;
  final Color? expandedBackgroundColor;
  final BorderRadius? borderRadius;

  @override
  State<ModernExpansionPanel> createState() => _ModernExpansionPanelState();
}

class _ModernExpansionPanelState extends State<ModernExpansionPanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isExpanded
            ? (widget.expandedBackgroundColor ?? design?.designSystemColors.surfaceContainer ?? theme.colorScheme.surfaceContainerHighest)
            : (widget.backgroundColor ?? theme.colorScheme.surface),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(design?.designSystemRadius.md ?? 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _handleTap,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(design?.designSystemRadius.md ?? 8),
            child: Padding(
              padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 12),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    SizedBox(width: design?.designSystemSpacing.md ?? 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: (design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
                          Text(
                            widget.subtitle!,
                            style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                              color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: design?.designSystemColors.onSurfaceVariant ?? theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                design?.designSystemSpacing.md ?? 12,
                0,
                design?.designSystemSpacing.md ?? 12,
                design?.designSystemSpacing.md ?? 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.children,
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

/// Accordion-style expansion panel group
class ExpansionPanelGroup extends StatefulWidget {
  const ExpansionPanelGroup({
    super.key,
    required this.items,
    this.allowMultipleExpanded = false,
    this.spacing,
  });

  final List<ExpansionPanelItem> items;
  final bool allowMultipleExpanded;
  final double? spacing;

  @override
  State<ExpansionPanelGroup> createState() => _ExpansionPanelGroupState();
}

class _ExpansionPanelGroupState extends State<ExpansionPanelGroup> {
  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(
      widget.items.length,
      (index) => widget.items[index].initiallyExpanded,
    );
  }

  void _handleExpansionChanged(int index, bool isExpanded) {
    setState(() {
      if (widget.allowMultipleExpanded) {
        _expandedStates[index] = isExpanded;
      } else {
        for (int i = 0; i < _expandedStates.length; i++) {
          _expandedStates[i] = i == index ? isExpanded : false;
        }
      }
    });
    widget.items[index].onExpansionChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();
    final itemSpacing = widget.spacing ?? design?.designSystemSpacing.sm ?? 8;

    return Column(
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          ModernExpansionPanel(
            title: widget.items[i].title,
            subtitle: widget.items[i].subtitle,
            leading: widget.items[i].leading,
            initiallyExpanded: _expandedStates[i],
            onExpansionChanged: (isExpanded) => _handleExpansionChanged(i, isExpanded),
            children: widget.items[i].children,
          ),
          if (i < widget.items.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}

/// Expansion panel item data model
class ExpansionPanelItem {
  const ExpansionPanelItem({
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  final String title;
  final List<Widget> children;
  final String? subtitle;
  final Widget? leading;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
}

/// Simple accordion list
class SimpleAccordion extends StatelessWidget {
  const SimpleAccordion({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget content;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: initiallyExpanded,
      children: [content],
    );
  }
}

/// Expandable card with custom styling
class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    super.key,
    required this.header,
    required this.expandedContent,
    this.collapsedContent,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  final Widget header;
  final Widget expandedContent;
  final Widget? collapsedContent;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.all(design?.designSystemSpacing.md ?? 12),
              child: widget.header,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      design?.designSystemSpacing.md ?? 12,
                      0,
                      design?.designSystemSpacing.md ?? 12,
                      design?.designSystemSpacing.md ?? 12,
                    ),
                    child: widget.expandedContent,
                  )
                : (widget.collapsedContent ?? const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

/// FAQ-style expansion panel
class FAQPanel extends StatelessWidget {
  const FAQPanel({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  final String question;
  final String answer;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return ModernExpansionPanel(
      title: question,
      initiallyExpanded: initiallyExpanded,
      leading: Icon(
        Icons.help_outline,
        color: design?.designSystemColors.primary ?? theme.colorScheme.primary,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: design?.designSystemSpacing.sm ?? 8),
          child: Text(
            answer,
            style: design?.designSystemTypography.bodyMedium ?? theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

/// Playlist-style expandable list
class PlaylistExpansionPanel extends StatelessWidget {
  const PlaylistExpansionPanel({
    super.key,
    required this.playlistName,
    required this.trackCount,
    required this.tracks,
    this.coverImage,
    this.initiallyExpanded = false,
  });

  final String playlistName;
  final int trackCount;
  final List<Widget> tracks;
  final Widget? coverImage;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return ModernExpansionPanel(
      title: playlistName,
      subtitle: '$trackCount ${trackCount == 1 ? 'track' : 'tracks'}',
      initiallyExpanded: initiallyExpanded,
      leading: coverImage ??
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: design?.designSystemColors.surfaceContainer ?? theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(design?.designSystemRadius.sm ?? 4),
            ),
            child: Icon(
              Icons.music_note,
              color: design?.designSystemColors.primary ?? theme.colorScheme.primary,
            ),
          ),
      children: tracks,
    );
  }
}
