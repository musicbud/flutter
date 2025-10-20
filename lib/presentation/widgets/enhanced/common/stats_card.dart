import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Stats card for displaying metrics
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color,
    this.trend,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? color;
  final double? trend; // Positive for up, negative for down

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();
    final cardColor = color ?? design?.designSystemColors.primary ?? theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(design?.designSystemSpacing.lg ?? 16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design?.designSystemRadius.md ?? 8),
        border: Border.all(
          color: cardColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, color: cardColor, size: 24),
          SizedBox(height: design?.designSystemSpacing.sm ?? 8),
          Text(
            value,
            style: (design?.designSystemTypography.displaySmall ?? theme.textTheme.displaySmall)?.copyWith(
              color: cardColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          SizedBox(height: design?.designSystemSpacing.xs ?? 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
                    color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (trend != null)
                Row(
                  children: [
                    Icon(
                      trend! >= 0 ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: trend! >= 0 ? Colors.green : Colors.red,
                    ),
                    Text(
                      '${trend!.abs()}%',
                      style: TextStyle(
                        color: trend! >= 0 ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Horizontal stats row
class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.stats,
  });

  final List<StatData> stats;

  @override
  Widget build(BuildContext context) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>();

    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          Expanded(
            child: StatsCard(
              value: stats[i].value,
              label: stats[i].label,
              icon: stats[i].icon,
              color: stats[i].color,
              trend: stats[i].trend,
            ),
          ),
          if (i < stats.length - 1)
            SizedBox(width: design?.designSystemSpacing.md ?? 12),
        ],
      ],
    );
  }
}

class StatData {
  const StatData({
    required this.value,
    required this.label,
    this.icon,
    this.color,
    this.trend,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? color;
  final double? trend;
}

/// Compact stat display
class CompactStat extends StatelessWidget {
  const CompactStat({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          SizedBox(width: design?.designSystemSpacing.xs ?? 4),
        ],
        Text(
          value,
          style: (design?.designSystemTypography.titleMedium ?? theme.textTheme.titleMedium)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: design?.designSystemSpacing.xs ?? 4),
        Text(
          label,
          style: (design?.designSystemTypography.bodySmall ?? theme.textTheme.bodySmall)?.copyWith(
            color: design?.designSystemColors.textMuted ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
