import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class GetAdminStatsEvent extends AdminEvent {}

class GetRecentActionsEvent extends AdminEvent {
  final int limit;

  const GetRecentActionsEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class PerformAdminActionEvent extends AdminEvent {
  final String actionType;
  final String targetId;
  final Map<String, dynamic> metadata;

  const PerformAdminActionEvent({
    required this.actionType,
    required this.targetId,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [actionType, targetId, metadata];
}

class UpdateSystemSettingsEvent extends AdminEvent {
  final Map<String, dynamic> settings;

  const UpdateSystemSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class GetSystemSettingsEvent extends AdminEvent {}
