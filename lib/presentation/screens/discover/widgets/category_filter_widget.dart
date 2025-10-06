import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),
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
                  right: index < categories.length - 1 ? appTheme.spacing.md : 0,
                ),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: appTheme.spacing.lg,
                      vertical: appTheme.spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appTheme.colors.primaryRed
                          : appTheme.colors.surfaceDark,
                      borderRadius: BorderRadius.circular(appTheme.radius.circular),
                      border: Border.all(
                        color: isSelected
                            ? appTheme.colors.primaryRed
                            : appTheme.colors.borderColor,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? appTheme.shadows.shadowMedium
                          : appTheme.shadows.shadowSmall,
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: appTheme.typography.bodySmall.copyWith(
                          color: isSelected
                              ? appTheme.colors.white
                              : appTheme.colors.textSecondary,
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