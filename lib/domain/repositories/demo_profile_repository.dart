import '../models/demo_user_profile.dart';

abstract class DemoProfileRepository {
  /// Get demo user profile
  Future<DemoUserProfile> getProfile();

  /// Update demo profile data
  Future<DemoUserProfile> updateProfile(Map<String, dynamic> data);

  /// Get profile statistics
  Future<Map<String, int>> getStats();

  /// Update profile preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences);

  /// Update profile interests
  Future<void> updateInterests(List<String> interests);

  /// Toggle premium status (demo only)
  Future<void> togglePremium();

  /// Add/Remove badges (demo only)
  Future<void> updateBadges(List<String> badges);

  /// Get real-time profile updates
  Stream<DemoUserProfile> get profileUpdates;

  /// Get real-time stats updates
  Stream<Map<String, int>> get statsUpdates;
}
