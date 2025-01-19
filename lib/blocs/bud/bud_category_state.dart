import 'package:equatable/equatable.dart';

abstract class BudCategoryState extends Equatable {
  const BudCategoryState();

  @override
  List<Object?> get props => [];
}

class BudCategoryInitial extends BudCategoryState {}

class BudCategoryLoading extends BudCategoryState {}

class BudCategoryLoaded extends BudCategoryState {
  final List<String> categories;
  final String? selectedCategory;
  final int? selectedIndex;

  const BudCategoryLoaded({
    required this.categories,
    this.selectedCategory,
    this.selectedIndex,
  });

  @override
  List<Object?> get props => [categories, selectedCategory, selectedIndex];

  BudCategoryLoaded copyWith({
    List<String>? categories,
    String? selectedCategory,
    int? selectedIndex,
  }) {
    return BudCategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class BudCategoryFailure extends BudCategoryState {
  final String error;

  const BudCategoryFailure(this.error);

  @override
  List<Object> get props => [error];
}
