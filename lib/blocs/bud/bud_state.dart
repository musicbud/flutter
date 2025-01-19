import 'package:equatable/equatable.dart';
import '../../models/bud_match.dart';

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
  final List<BudMatch> buds;

  const BudsLoaded(this.buds);

  @override
  List<Object> get props => [buds];
}
