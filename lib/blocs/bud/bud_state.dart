import 'package:equatable/equatable.dart';
import '../../models/bud.dart';

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
  final List<Bud> buds;

  const BudsLoaded(this.buds);

  @override
  List<Object> get props => [buds];
}
