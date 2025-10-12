import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategoryFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return Container(
                margin: EdgeInsets.only(
                  right: index < categories.length - 1 ? DesignSystem.spacingMD : 0,
                ),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingLG,
                      vertical: DesignSystem.spacingSM,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? DesignSystem.primary
                          : DesignSystem.surfaceContainer,
                      borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                      border: Border.all(
                        color: isSelected
                            ? DesignSystem.primary
                            : DesignSystem.border,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? DesignSystem.shadowMedium
                          : DesignSystem.shadowSmall,
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: DesignSystem.bodySmall.copyWith(
                          color: isSelected
                              ? DesignSystem.onPrimary
                              : DesignSystem.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}