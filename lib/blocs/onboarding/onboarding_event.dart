import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingStepCompleted extends OnboardingEvent {
  final String stepId;
  final Map<String, dynamic> data;

  const OnboardingStepCompleted({
    required this.stepId,
    this.data = const {},
  });

  @override
  List<Object?> get props => [stepId, data];
}

class OnboardingSkipped extends OnboardingEvent {
  final String stepId;
  
  const OnboardingSkipped(this.stepId);

  @override
  List<Object?> get props => [stepId];
}

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}

class OnboardingPreferencesUpdated extends OnboardingEvent {
  final Map<String, dynamic> preferences;

  const OnboardingPreferencesUpdated(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
