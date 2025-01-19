import 'package:equatable/equatable.dart';

abstract class BudCommonItemsEvent extends Equatable {
  const BudCommonItemsEvent();

  @override
  List<Object?> get props => [];
}

class BudCommonItemsRequested extends BudCommonItemsEvent {
  final String budId;

  const BudCommonItemsRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class BudCommonItemsRefreshRequested extends BudCommonItemsEvent {
  final String budId;

  const BudCommonItemsRefreshRequested(this.budId);

  @override
  List<Object> get props => [budId];
}
