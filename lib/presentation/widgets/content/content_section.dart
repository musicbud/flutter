import 'package:flutter/material.dart';

/// A reusable content section widget with title and content
class ContentSection extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? titleStyle;
  final bool showDivider;
  final Color? dividerColor;
  final double? dividerThickness;

  const ContentSection({
    Key? key,
    required this.title,
    required this.content,
    this.icon,
    this.padding,
    this.margin,
    this.titleStyle,
    this.showDivider = true,
    this.dividerColor,
    this.dividerThickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon!,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: titleStyle ?? const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          content,

          // Divider
          if (showDivider) ...[
            const SizedBox(height: 16),
            Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 32.0),
              child: Divider(
                color: dividerColor ?? Colors.white24,
                thickness: dividerThickness ?? 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}