import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/analytics_repository.dart';
import '../../../models/analytics.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

/// BLoC for managing analytics data
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  AnalyticsBloc({
    required this.analyticsRepository,
  }) : super(const AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<TrackEvent>(_onTrackEvent);
    on<UpdateAnalyticsSettings>(_onUpdateAnalyticsSettings);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      emit(const AnalyticsLoading());

      // Provide default dates if not specified
      final startDate = event.startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final endDate = event.endDate ?? DateTime.now();

      final analyticsData = await analyticsRepository.getTimeRangeAnalytics(
        startDate,
        endDate,
      );

      // Convert Map<String, dynamic> to Analytics object
      final analytics = Analytics.fromJson(analyticsData);
      emit(AnalyticsLoaded(analytics: analytics));
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }

  Future<void> _onTrackEvent(
    TrackEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await analyticsRepository.trackEvent(
        event.eventName,
        event.parameters ?? {},
      );

      // Optionally emit a success state or keep current state
      if (state is AnalyticsLoaded) {
        emit(state);
      }
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateAnalyticsSettings(
    UpdateAnalyticsSettings event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      // Analytics settings update not available in repository
      // This functionality needs to be implemented in the repository

      // Reload analytics with new settings
      add(LoadAnalytics(
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }
}