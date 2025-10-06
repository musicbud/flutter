import '../../models/event/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents({int page = 1});
  Future<Event> getEventDetails(String eventId);
  Future<void> createEvent(Map<String, dynamic> eventData);
  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData);
  Future<void> deleteEvent(String eventId);
  Future<void> rsvpToEvent(String eventId, String status);
  Future<List<Event>> getMyEvents();
  Future<List<Event>> getUpcomingEvents();
}
