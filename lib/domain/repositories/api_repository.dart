abstract class ApiRepository {
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<List<dynamic>> getChannels();
  Future<Map<String, dynamic>> getChannelDetails(String channelId);
  Future<Map<String, dynamic>> createChannel(Map<String, dynamic> channelData);
}
