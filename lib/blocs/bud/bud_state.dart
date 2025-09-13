import 'package:equatable/equatable.dart';

abstract class BudState extends Equatable {
  const BudState();

  @override
  List<Object?> get props => [];
}

class BudInitial extends BudState {}

class BudLoading extends BudState {}

class BudFailure extends BudState {
  final String error;

  const BudFailure(this.error);

  @override
  List<Object> get props => [error];
}

class BudsLoaded extends BudState {
  final List<dynamic> buds;

  const BudsLoaded({required this.buds});

  @override
  List<Object?> get props => [buds];
}

class BudMatchesLoaded extends BudState {
  final List<dynamic> matches;

  const BudMatchesLoaded({required this.matches});

  @override
  List<Object?> get props => [matches];
}

class BudRecommendationsLoaded extends BudState {
  final List<dynamic> recommendations;

  const BudRecommendationsLoaded({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class BudSearchResultsLoaded extends BudState {
  final List<dynamic> results;
  final String query;

  const BudSearchResultsLoaded({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

class BudRequestSentSuccess extends BudState {
  final String userId;

  const BudRequestSentSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRequestAcceptedSuccess extends BudState {
  final String userId;

  const BudRequestAcceptedSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRequestRejectedSuccess extends BudState {
  final String userId;

  const BudRequestRejectedSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRemovedSuccess extends BudState {
  final String userId;

  const BudRemovedSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CommonItemsLoaded extends BudState {
  final List<dynamic> items;
  final String category;
  final String userId;

  const CommonItemsLoaded({
    required this.items,
    required this.category,
    required this.userId,
  });

  @override
  List<Object?> get props => [items, category, userId];
}
