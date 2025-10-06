import 'package:equatable/equatable.dart';
import '../../../models/admin.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminStatsLoaded extends AdminState {
  final AdminStats stats;

  const AdminStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AdminActionsLoaded extends AdminState {
  final List<AdminAction> actions;

  const AdminActionsLoaded(this.actions);

  @override
  List<Object?> get props => [actions];
}

class SystemSettingsLoaded extends AdminState {
  final Map<String, dynamic> settings;

  const SystemSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class AdminActionSuccess extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
