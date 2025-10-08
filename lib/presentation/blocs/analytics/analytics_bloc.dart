import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/analytics_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  AnalyticsBloc({required this.analyticsRepository}) : super(const AnalyticsInitial()) {
    on<AnalyticsRequested>(_onAnalyticsRequested);
    on<ContentAnalyticsRequested>(_onContentAnalyticsRequested);
    on<SocialAnalyticsRequested>(_onSocialAnalyticsRequested);
    on<EventTracked>(_onEventTracked);
    on<MetricTracked>(_onMetricTracked);
  }

  Future<void> _onAnalyticsRequested(
    AnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    try {
      final analytics = await analyticsRepository.getUserAnalytics();
      emit(UserAnalyticsLoaded(analytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onContentAnalyticsRequested(
    ContentAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    try {
      final contentAnalytics = await analyticsRepository.getContentAnalytics();
      emit(ContentAnalyticsLoaded(contentAnalytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onSocialAnalyticsRequested(
    SocialAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    try {
      final socialAnalytics = await analyticsRepository.getSocialAnalytics();
      emit(SocialAnalyticsLoaded(socialAnalytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onEventTracked(
    EventTracked event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await analyticsRepository.trackEvent(event.eventName, event.properties);
    } catch (e) {
      // Silently handle tracking errors to avoid disrupting user experience
    }
  }

  Future<void> _onMetricTracked(
    MetricTracked event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await analyticsRepository.trackMetric(event.metricName, event.value);
    } catch (e) {
      // Silently handle tracking errors to avoid disrupting user experience
    }
  }
}