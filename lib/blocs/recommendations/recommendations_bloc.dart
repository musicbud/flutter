import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'recommendations_event.dart';
import 'recommendations_state.dart';
import '../../data/network/api_service.dart';

class RecommendationsBloc extends Bloc<RecommendationsEvent, RecommendationsState> {
  final ApiService _apiService;

  RecommendationsBloc({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const RecommendationsInitial()) {
    on<LoadRecommendations>(_onLoadRecommendations);
    on<RefreshRecommendations>(_onRefreshRecommendations);
    on<LoadRecommendationsByType>(_onLoadRecommendationsByType);
  }

  Future<void> _onLoadRecommendations(
    LoadRecommendations event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(const RecommendationsLoading());

    try {
      // Call the recommendations API endpoint
      final response = await _apiService.getRecommendations();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        if (data['success'] == true && data['data'] != null) {
          emit(RecommendationsLoaded(
            recommendations: data['data'] as Map<String, dynamic>,
            loadedAt: DateTime.now(),
          ));
        } else {
          emit(const RecommendationsEmpty());
        }
      } else {
        emit(RecommendationsError('Failed to load recommendations: ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      emit(RecommendationsError('Network error: ${e.message}'));
    } catch (e) {
      emit(RecommendationsError('Unexpected error: $e'));
    }
  }

  Future<void> _onRefreshRecommendations(
    RefreshRecommendations event,
    Emitter<RecommendationsState> emit,
  ) async {
    // Same as load but doesn't show loading state if already loaded
    if (state is! RecommendationsLoaded) {
      emit(const RecommendationsLoading());
    }

    try {
      final response = await _apiService.getRecommendations();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        if (data['success'] == true && data['data'] != null) {
          emit(RecommendationsLoaded(
            recommendations: data['data'] as Map<String, dynamic>,
            loadedAt: DateTime.now(),
          ));
        } else {
          emit(const RecommendationsEmpty());
        }
      } else {
        emit(RecommendationsError('Failed to refresh recommendations: ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      emit(RecommendationsError('Network error: ${e.message}'));
    } catch (e) {
      emit(RecommendationsError('Unexpected error: $e'));
    }
  }

  Future<void> _onLoadRecommendationsByType(
    LoadRecommendationsByType event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(const RecommendationsLoading());

    try {
      final response = await _apiService.getRecommendationsByType(event.type);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        if (data['success'] == true && data['data'] != null) {
          emit(RecommendationsLoaded(
            recommendations: {event.type: data['data']},
            loadedAt: DateTime.now(),
          ));
        } else {
          emit(const RecommendationsEmpty());
        }
      } else {
        emit(RecommendationsError('Failed to load ${event.type}: ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      emit(RecommendationsError('Network error: ${e.message}'));
    } catch (e) {
      emit(RecommendationsError('Unexpected error: $e'));
    }
  }
}
