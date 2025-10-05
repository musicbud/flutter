import 'package:equatable/equatable.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> data;

  const AnalyticsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class UserAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> data;

  const UserAnalyticsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ContentAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> data;

  const ContentAnalyticsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class SocialAnalyticsLoaded extends AnalyticsState {
  final Map<String, dynamic> data;

  const SocialAnalyticsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}
