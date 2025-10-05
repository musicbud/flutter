import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/admin_repository.dart';
import '../../../domain/models/admin.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository repository;

  AdminBloc({required this.repository}) : super(AdminInitial()) {
    on<GetAdminStatsEvent>(_onGetAdminStats);
    on<GetRecentActionsEvent>(_onGetRecentActions);
    on<PerformAdminActionEvent>(_onPerformAdminAction);
    on<UpdateSystemSettingsEvent>(_onUpdateSystemSettings);
    on<GetSystemSettingsEvent>(_onGetSystemSettings);
  }

  Future<void> _onGetAdminStats(
    GetAdminStatsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    final result = await repository.getAdminStats();
    result.fold(
      (failure) => emit(const AdminError('Failed to load admin stats')),
      (stats) => emit(AdminStatsLoaded(stats)),
    );
  }

  Future<void> _onGetRecentActions(
    GetRecentActionsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    final result = await repository.getRecentActions(limit: event.limit);
    result.fold(
      (failure) => emit(const AdminError('Failed to load recent actions')),
      (actions) => emit(AdminActionsLoaded(actions)),
    );
  }

  Future<void> _onPerformAdminAction(
    PerformAdminActionEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    final action = AdminAction(
      actionType: event.actionType,
      targetId: event.targetId,
      performedBy: 'current_admin', // TODO: Get from auth
      timestamp: DateTime.now(),
      metadata: event.metadata,
    );
    final result = await repository.performAdminAction(action);
    result.fold(
      (failure) => emit(const AdminError('Failed to perform action')),
      (_) => emit(AdminActionSuccess()),
    );
  }

  Future<void> _onUpdateSystemSettings(
    UpdateSystemSettingsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    final result = await repository.updateSystemSettings(event.settings);
    result.fold(
      (failure) => emit(const AdminError('Failed to update system settings')),
      (_) => emit(AdminActionSuccess()),
    );
  }

  Future<void> _onGetSystemSettings(
    GetSystemSettingsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    final result = await repository.getSystemSettings();
    result.fold(
      (failure) => emit(const AdminError('Failed to load system settings')),
      (settings) => emit(SystemSettingsLoaded(settings)),
    );
  }
}
