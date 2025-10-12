part of 'analytics_bloc.dart';

/// Base class for analytics states
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

/// Loading state
class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

/// Loaded state with analytics data
class AnalyticsLoaded extends AnalyticsState {
  final Analytics analytics;

  const AnalyticsLoaded({required this.analytics});

  @override
  List<Object?> get props => [analytics];
}

/// Error state
class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message});

  @override
  List<Object?> get props => [message];
}