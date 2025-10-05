abstract class ServicesRepository {
  // Service connection operations
  Future<void> connectSpotify(String code);
  Future<void> disconnectSpotify();
  Future<void> connectLastFM(String code);
  Future<void> disconnectLastFM();
  Future<void> connectYTMusic(String code);
  Future<void> disconnectYTMusic();
  Future<void> connectMAL(String code);
  Future<void> disconnectMAL();

  // Service status
  Future<Map<String, dynamic>> getServiceStatus(String serviceName);
  Future<List<Map<String, dynamic>>> getAllServicesStatus();
}