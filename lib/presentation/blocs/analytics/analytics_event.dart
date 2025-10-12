part of 'analytics_bloc.dart';

/// Base class for analytics events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load analytics data
class LoadAnalytics extends AnalyticsEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadAnalytics({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to track a user action
class TrackEvent extends AnalyticsEvent {
  final String eventName;
  final Map<String, dynamic>? parameters;

  const TrackEvent({
    required this.eventName,
    this.parameters,
  });

  @override
  List<Object?> get props => [eventName, parameters];
}

/// Event to update analytics settings
class UpdateAnalyticsSettings extends AnalyticsEvent {
  final Map<String, dynamic> settings;
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateAnalyticsSettings({
    required this.settings,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [settings, startDate, endDate];
}