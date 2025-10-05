import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/analytics_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsBloc({required AnalyticsRepository analyticsRepository})
      : _analyticsRepository = analyticsRepository,
        super(AnalyticsInitial()) {
    on<AnalyticsRequested>(_onAnalyticsRequested);
    on<AnalyticsEventTracked>(_onAnalyticsEventTracked);
    on<AnalyticsMetricTracked>(_onAnalyticsMetricTracked);
    on<UserAnalyticsRequested>(_onUserAnalyticsRequested);
    on<ContentAnalyticsRequested>(_onContentAnalyticsRequested);
    on<SocialAnalyticsRequested>(_onSocialAnalyticsRequested);
  }

  Future<void> _onAnalyticsRequested(
    AnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      emit(AnalyticsLoading());
      final data = await _analyticsRepository.getTimeRangeAnalytics(
        event.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        event.endDate ?? DateTime.now(),
      );
      emit(AnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onAnalyticsEventTracked(
    AnalyticsEventTracked event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await _analyticsRepository.trackEvent(
        event.eventName,
        event.properties,
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onAnalyticsMetricTracked(
    AnalyticsMetricTracked event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await _analyticsRepository.trackMetric(
        event.metricName,
        event.value,
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onUserAnalyticsRequested(
    UserAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      emit(AnalyticsLoading());
      final data = await _analyticsRepository.getUserAnalytics();
      emit(UserAnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onContentAnalyticsRequested(
    ContentAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      emit(AnalyticsLoading());
      final data = await _analyticsRepository.getContentAnalytics();
      emit(ContentAnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onSocialAnalyticsRequested(
    SocialAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      emit(AnalyticsLoading());
      final data = await _analyticsRepository.getSocialAnalytics();
      emit(SocialAnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
