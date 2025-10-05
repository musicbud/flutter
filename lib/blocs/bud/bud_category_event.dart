import 'package:equatable/equatable.dart';

abstract class BudCategoryEvent extends Equatable {
  const BudCategoryEvent();

  @override
  List<Object?> get props => [];
}

class BudCategoriesRequested extends BudCategoryEvent {}

class BudCategoriesRefreshRequested extends BudCategoryEvent {}

class BudCategorySelected extends BudCategoryEvent {
  final String category;
  final int index;

  const BudCategorySelected({
    required this.category,
    required this.index,
  });

  @override
  List<Object> get props => [category, index];
}
