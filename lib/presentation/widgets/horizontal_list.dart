import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import 'common/modern_button.dart';
import 'mixins/interaction/hover_mixin.dart';
import 'mixins/interaction/focus_mixin.dart';

class HorizontalList extends StatefulWidget {
  final String? title;
  final List<Widget> items;
  final VoidCallback? onSeeAll;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final bool enableHover;
  final bool enableFocus;

  const HorizontalList({
    super.key,
    this.title,
    required this.items,
    this.onSeeAll,
    this.spacing = 8.0,
    this.padding,
    this.enableHover = true,
    this.enableFocus = true,
  });

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList>
    with HoverMixin<HorizontalList>, FocusMixin<HorizontalList> {

  @override
  void initState() {
    super.initState();
    if (widget.enableHover) {
      setupHover(
        onHover: () {},
        onExit: () {},
        enableScaleAnimation: false,
      );
    }
    if (widget.enableFocus) {
      setupFocus(
        onFocus: () {},
        onUnfocus: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: design.designSystemSpacing.md,
              vertical: design.designSystemSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title!,
                  style: design.designSystemTypography.titleMedium.copyWith(
                    color: design.designSystemColors.onSurface,
                  ),
                ),
                if (widget.onSeeAll != null)
                  ModernButton(
                    text: 'See All',
                    onPressed: widget.onSeeAll,
                    variant: ModernButtonVariant.text,
                    size: ModernButtonSize.small,
                  ),
              ],
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: widget.padding ?? EdgeInsets.symmetric(
            horizontal: design.designSystemSpacing.md,
          ),
          child: Row(
            children: widget.items.expand((child) => [
              child,
              SizedBox(width: widget.spacing)
            ]).toList()
              ..removeLast(), // Remove the last spacing
          ),
        ),
      ],
    );
  }
}