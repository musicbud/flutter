import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../../services/api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<UserProfile> getUserProfile() async {
    final userProfileData = await apiService.getUserProfile();
    return UserProfile(
      uid: userProfileData.uid,
      username: userProfileData.username,
      email: userProfileData.email,
      photoUrl: userProfileData.photoUrl,
    );
  }
}
