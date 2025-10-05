import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../../domain/models/channel.dart';
import '../../../domain/models/channel_settings.dart';
import '../../../domain/models/channel_stats.dart';
import '../../../config/constants.dart' as api_constants;

abstract class ChannelRemoteDataSource {
  Future<List<Channel>> getChannels({int? limit, int? offset});
  Future<Channel> getChannelById(String id);
  Future<Channel> createChannel(Channel channel);
  Future<Channel> updateChannel(Channel channel);
  Future<void> deleteChannel(String id);
  Future<void> joinChannel(String channelId);
  Future<void> leaveChannel(String channelId);
  Future<List<String>> getChannelMembers(String channelId);
  Future<void> addModerator(String channelId, String userId);
  Future<void> removeModerator(String channelId, String userId);
  Future<void> updateChannelSettings(String channelId, ChannelSettings settings);
  Future<void> muteChannel(String channelId);
  Future<void> unmuteChannel(String channelId);
  Future<ChannelStats> getChannelStats(String channelId);
}

class ChannelRemoteDataSourceImpl implements ChannelRemoteDataSource {
  final http.Client client;

  ChannelRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Channel>> getChannels({int? limit, int? offset}) async {
    final queryParams = {
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    };

    final response = await client.get(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels').replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Channel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get channels: ${response.statusCode}');
    }
  }

  @override
  Future<Channel> getChannelById(String id) async {
    final response = await client.get(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Channel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to get channel by ID: ${response.statusCode}');
    }
  }

  @override
  Future<Channel> createChannel(Channel channel) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(channel.toJson()),
    );

    if (response.statusCode == 201) {
      return Channel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to create channel: ${response.statusCode}');
    }
  }

  @override
  Future<Channel> updateChannel(Channel channel) async {
    final response = await client.put(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/${channel.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(channel.toJson()),
    );

    if (response.statusCode == 200) {
      return Channel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to update channel: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteChannel(String id) async {
    final response = await client.delete(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw ServerException(message: 'Failed to delete channel: ${response.statusCode}');
    }
  }

  @override
  Future<void> joinChannel(String channelId) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/join'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to join channel: ${response.statusCode}');
    }
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/leave'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to leave channel: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getChannelMembers(String channelId) async {
    final response = await client.get(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/members'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return List<String>.from(jsonList);
    } else {
      throw ServerException(message: 'Failed to get channel members: ${response.statusCode}');
    }
  }

  @override
  Future<void> addModerator(String channelId, String userId) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/moderators'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId}),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to add moderator: ${response.statusCode}');
    }
  }

  @override
  Future<void> removeModerator(String channelId, String userId) async {
    final response = await client.delete(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/moderators/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw ServerException(message: 'Failed to remove moderator: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateChannelSettings(String channelId, ChannelSettings settings) async {
    final response = await client.put(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/settings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(settings.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update channel settings: ${response.statusCode}');
    }
  }

  @override
  Future<void> muteChannel(String channelId) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/mute'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to mute channel: ${response.statusCode}');
    }
  }

  @override
  Future<void> unmuteChannel(String channelId) async {
    final response = await client.post(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/unmute'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unmute channel: ${response.statusCode}');
    }
  }

  @override
  Future<ChannelStats> getChannelStats(String channelId) async {
    final response = await client.get(
      Uri.parse('${api_constants.ApiConstants.baseUrl}/channels/$channelId/stats'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ChannelStats.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to get channel stats: ${response.statusCode}');
    }
  }
}
