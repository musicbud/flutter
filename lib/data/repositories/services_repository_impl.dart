import 'package:musicbud_flutter/domain/repositories/services_repository.dart';
import '../../domain/repositories/user_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final UserRepository _userRepository;

  ServicesRepositoryImpl({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<void> connectSpotify(String code) async {
    await _userRepository.connectSpotify(code);
  }

  @override
  Future<void> disconnectSpotify() async {
    await _userRepository.disconnectSpotify();
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _userRepository.connectLastFM(code);
  }

  @override
  Future<void> disconnectLastFM() async {
    await _userRepository.disconnectLastFM();
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _userRepository.connectYTMusic(code);
  }

  @override
  Future<void> disconnectYTMusic() async {
    await _userRepository.disconnectYTMusic();
  }

  @override
  Future<void> connectMAL(String code) async {
    await _userRepository.connectMAL(code);
  }

  @override
  Future<void> disconnectMAL() async {
    await _userRepository.disconnectMAL();
  }

  @override
  Future<Map<String, dynamic>> getServiceStatus(String serviceName) async {
    // TODO: Implement service status checking
    return {'status': 'unknown'};
  }

  @override
  Future<List<Map<String, dynamic>>> getAllServicesStatus() async {
    // TODO: Implement all services status checking
    return [];
  }
}