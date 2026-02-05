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
    final cardColor = color ?? DesignSystem.primary;

    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: cardColor.withAlpha(25),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: Border.all(
          color: cardColor.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, color: cardColor, size: 24),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            value,
            style: (DesignSystem.displaySmall).copyWith(
              color: cardColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: (DesignSystem.bodySmall).copyWith(
                    color: DesignSystem.textMuted,
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
            const SizedBox(width: DesignSystem.spacingMD),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: DesignSystem.spacingXS),
        ],
        Text(
          value,
          style: (DesignSystem.titleMedium).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: DesignSystem.spacingXS),
        Text(
          label,
          style: (DesignSystem.bodySmall).copyWith(
            color: DesignSystem.textMuted,
          ),
        ),
      ],
    );
  }
}