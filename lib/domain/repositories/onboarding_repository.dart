import '../../../models/onboarding_step.dart';

abstract class OnboardingRepository {
  /// Get the list of onboarding steps in order
  Future<List<OnboardingStep>> getOnboardingSteps();

  /// Save completion status for a step
  Future<void> completeStep(String stepId, Map<String, dynamic> data);

  /// Skip an optional step
  Future<void> skipStep(String stepId);

  /// Reset onboarding progress
  Future<void> resetProgress();

  /// Get user preferences collected during onboarding
  Future<Map<String, dynamic>> getPreferences();

  /// Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences);

  /// Check if onboarding is completed
  Future<bool> isOnboardingComplete();
}
