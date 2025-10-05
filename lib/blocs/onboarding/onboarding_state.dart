import 'package:equatable/equatable.dart';
import '../../domain/models/onboarding_step.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingInProgress extends OnboardingState {
  final List<OnboardingStep> steps;
  final int currentStepIndex;
  final Map<String, bool> completedSteps;
  final Map<String, dynamic> preferences;

  const OnboardingInProgress({
    required this.steps,
    required this.currentStepIndex,
    this.completedSteps = const {},
    this.preferences = const {},
  });

  @override
  List<Object?> get props => [
    steps,
    currentStepIndex,
    completedSteps,
    preferences,
  ];

  bool get isComplete =>
      steps.where((step) => step.isRequired).every(
        (step) => completedSteps[step.id] == true,
      );

  OnboardingInProgress copyWith({
    List<OnboardingStep>? steps,
    int? currentStepIndex,
    Map<String, bool>? completedSteps,
    Map<String, dynamic>? preferences,
  }) {
    return OnboardingInProgress(
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      completedSteps: completedSteps ?? this.completedSteps,
      preferences: preferences ?? this.preferences,
    );
  }
}

class OnboardingComplete extends OnboardingState {
  final Map<String, dynamic> preferences;

  const OnboardingComplete({
    this.preferences = const {},
  });

  @override
  List<Object?> get props => [preferences];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
