import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class AnalyticsRequested extends AnalyticsEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const AnalyticsRequested({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class AnalyticsEventTracked extends AnalyticsEvent {
  final String eventName;
  final Map<String, dynamic> properties;

  const AnalyticsEventTracked({
    required this.eventName,
    required this.properties,
  });

  @override
  List<Object> get props => [eventName, properties];
}

class AnalyticsMetricTracked extends AnalyticsEvent {
  final String metricName;
  final double value;

  const AnalyticsMetricTracked({
    required this.metricName,
    required this.value,
  });

  @override
  List<Object> get props => [metricName, value];
}

class UserAnalyticsRequested extends AnalyticsEvent {}

class ContentAnalyticsRequested extends AnalyticsEvent {}

class SocialAnalyticsRequested extends AnalyticsEvent {}
