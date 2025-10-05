import 'package:equatable/equatable.dart';
import '../../../domain/models/analytics.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final Analytics analytics;

  const AnalyticsLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class UserAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> data;

  const UserAnalyticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ContentAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> contentAnalytics;

  const ContentAnalyticsLoaded(this.contentAnalytics);

  @override
  List<Object?> get props => [contentAnalytics];
}

class SocialAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> socialAnalytics;

  const SocialAnalyticsLoaded(this.socialAnalytics);

  @override
  List<Object?> get props => [socialAnalytics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}