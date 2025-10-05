import 'package:equatable/equatable.dart';
import '../../domain/models/discover_item.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  final List<DiscoverItem> items;
  final List<String> categories;
  final String selectedCategory;
  final bool isRefreshing;

  const DiscoverLoaded({
    required this.items,
    required this.categories,
    required this.selectedCategory,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [items, categories, selectedCategory, isRefreshing];

  DiscoverLoaded copyWith({
    List<DiscoverItem>? items,
    List<String>? categories,
    String? selectedCategory,
    bool? isRefreshing,
  }) {
    return DiscoverLoaded(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError(this.message);

  @override
  List<Object?> get props => [message];
}
