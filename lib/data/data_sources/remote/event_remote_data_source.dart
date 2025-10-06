import 'package:dio/dio.dart';
import '../../../models/event/event.dart';

abstract class EventRemoteDataSource {
  Future<List<Event>> getEvents({int page = 1});
  Future<Event> getEventDetails(String eventId);
  Future<void> createEvent(Map<String, dynamic> eventData);
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData);
  Future<void> deleteEvent(String eventId);
  Future<void> rsvpToEvent(String eventId, String status);
  Future<List<Event>> getMyEvents();
  Future<List<Event>> getUpcomingEvents();
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final Dio _dioClient;
  static const String _baseUrl = 'api/events';
  static const int _pageSize = 20;

  EventRemoteDataSourceImpl({required Dio dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Event>> getEvents({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        _baseUrl,
        queryParameters: {
          'page': page,
          'size': _pageSize,
        },
      );
      return (response.data['events'] as List)
          .map((event) => Event.fromJson(event))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get events: ${e.message}');
    }
  }

  @override
  Future<Event> getEventDetails(String eventId) async {
    try {
      final response = await _dioClient.get('$_baseUrl/$eventId');
      return Event.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get event details: ${e.message}');
    }
  }

  @override
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    try {
      await _dioClient.post(_baseUrl, data: eventData);
    } on DioException catch (e) {
      throw Exception('Failed to create event: ${e.message}');
    }
  }

  @override
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    try {
      await _dioClient.patch('$_baseUrl/$eventId', data: eventData);
    } on DioException catch (e) {
      throw Exception('Failed to update event: ${e.message}');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await _dioClient.delete('$_baseUrl/$eventId');
    } on DioException catch (e) {
      throw Exception('Failed to delete event: ${e.message}');
    }
  }

  @override
  Future<void> rsvpToEvent(String eventId, String status) async {
    try {
      await _dioClient.post(
        '$_baseUrl/$eventId/rsvp',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw Exception('Failed to RSVP to event: ${e.message}');
    }
  }

  @override
  Future<List<Event>> getMyEvents() async {
    try {
      final response = await _dioClient.get('$_baseUrl/me');
      return (response.data['events'] as List)
          .map((event) => Event.fromJson(event))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get my events: ${e.message}');
    }
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    try {
      final response = await _dioClient.get('$_baseUrl/upcoming');
      return (response.data['events'] as List)
          .map((event) => Event.fromJson(event))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get upcoming events: ${e.message}');
    }
  }
}
