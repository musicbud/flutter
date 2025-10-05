import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc({required this.repository}) : super(const OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingStepCompleted>(_onStepCompleted);
    on<OnboardingSkipped>(_onStepSkipped);
    on<OnboardingReset>(_onReset);
    on<OnboardingPreferencesUpdated>(_onPreferencesUpdated);
  }

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingLoading());

      final isComplete = await repository.isOnboardingComplete();
      if (isComplete) {
        final preferences = await repository.getPreferences();
        emit(OnboardingComplete(preferences: preferences));
        return;
      }

      final steps = await repository.getOnboardingSteps();
      if (steps.isEmpty) {
        emit(const OnboardingError('No onboarding steps found'));
        return;
      }

      final preferences = await repository.getPreferences();
      
      emit(OnboardingInProgress(
        steps: steps,
        currentStepIndex: 0,
        preferences: preferences,
      ));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onStepCompleted(
    OnboardingStepCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentState = state as OnboardingInProgress;

    try {
      await repository.completeStep(event.stepId, event.data);

      final updatedCompletedSteps = Map<String, bool>.from(currentState.completedSteps)
        ..[event.stepId] = true;

      final nextStepIndex = currentState.currentStepIndex + 1;
      
      if (nextStepIndex >= currentState.steps.length) {
        if (currentState.copyWith(completedSteps: updatedCompletedSteps).isComplete) {
          emit(OnboardingComplete(preferences: currentState.preferences));
        } else {
          emit(currentState.copyWith(
            completedSteps: updatedCompletedSteps,
          ));
        }
      } else {
        emit(currentState.copyWith(
          currentStepIndex: nextStepIndex,
          completedSteps: updatedCompletedSteps,
        ));
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onStepSkipped(
    OnboardingSkipped event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentState = state as OnboardingInProgress;

    try {
      await repository.skipStep(event.stepId);

      final nextStepIndex = currentState.currentStepIndex + 1;
      
      if (nextStepIndex >= currentState.steps.length) {
        if (currentState.isComplete) {
          emit(OnboardingComplete(preferences: currentState.preferences));
        }
      } else {
        emit(currentState.copyWith(
          currentStepIndex: nextStepIndex,
        ));
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingLoading());
      
      await repository.resetProgress();
      final steps = await repository.getOnboardingSteps();
      
      emit(OnboardingInProgress(
        steps: steps,
        currentStepIndex: 0,
      ));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> _onPreferencesUpdated(
    OnboardingPreferencesUpdated event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentState = state as OnboardingInProgress;

    try {
      await repository.updatePreferences(event.preferences);
      
      emit(currentState.copyWith(
        preferences: event.preferences,
      ));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}
