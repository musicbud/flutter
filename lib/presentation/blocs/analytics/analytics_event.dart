import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class AnalyticsRequested extends AnalyticsEvent {
  const AnalyticsRequested();
}

class ContentAnalyticsRequested extends AnalyticsEvent {
  const ContentAnalyticsRequested();
}

class SocialAnalyticsRequested extends AnalyticsEvent {
  const SocialAnalyticsRequested();
}

class EventTracked extends AnalyticsEvent {
  final String eventName;
  final Map<String, dynamic> properties;

  const EventTracked(this.eventName, this.properties);

  @override
  List<Object?> get props => [eventName, properties];
}

class MetricTracked extends AnalyticsEvent {
  final String metricName;
  final double value;

  const MetricTracked(this.metricName, this.value);

  @override
  List<Object?> get props => [metricName, value];
}