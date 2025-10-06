import '../../domain/repositories/event_repository.dart';
import '../../models/event/event.dart';
import '../data_sources/remote/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _remoteDataSource;

  EventRepositoryImpl({
    required EventRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Event>> getEvents({int page = 1}) async {
    return await _remoteDataSource.getEvents(page: page);
  }

  @override
  Future<Event> getEventDetails(String eventId) async {
    return await _remoteDataSource.getEventDetails(eventId);
  }

  @override
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    await _remoteDataSource.createEvent(eventData);
  }

  @override
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    await _remoteDataSource.updateEvent(eventId, eventData);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _remoteDataSource.deleteEvent(eventId);
  }

  @override
  Future<void> rsvpToEvent(String eventId, String status) async {
    await _remoteDataSource.rsvpToEvent(eventId, status);
  }

  @override
  Future<List<Event>> getMyEvents() async {
    return await _remoteDataSource.getMyEvents();
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    return await _remoteDataSource.getUpcomingEvents();
  }
}
