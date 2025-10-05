import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;
  static const int _pageSize = 20;

  EventBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(EventInitial()) {
    on<EventsRequested>(_onEventsRequested);
    on<EventDetailsRequested>(_onEventDetailsRequested);
    on<EventCreated>(_onEventCreated);
    on<EventUpdated>(_onEventUpdated);
    on<EventDeleted>(_onEventDeleted);
    on<EventRsvpSubmitted>(_onEventRsvpSubmitted);
    on<MyEventsRequested>(_onMyEventsRequested);
    on<UpcomingEventsRequested>(_onUpcomingEventsRequested);
  }

  Future<void> _onEventsRequested(
    EventsRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      final events = await _eventRepository.getEvents(page: event.page);
      final hasReachedEnd = events.length < _pageSize;
      emit(EventsLoaded(
        events: events,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onEventDetailsRequested(
    EventDetailsRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      final eventDetails = await _eventRepository.getEventDetails(event.eventId);
      emit(EventDetailsLoaded(eventDetails));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onEventCreated(
    EventCreated event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      await _eventRepository.createEvent(event.eventData);
      final events = await _eventRepository.getEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onEventUpdated(
    EventUpdated event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      await _eventRepository.updateEvent(event.eventId, event.eventData);
      final updatedEvent = await _eventRepository.getEventDetails(event.eventId);
      emit(EventDetailsLoaded(updatedEvent));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onEventDeleted(
    EventDeleted event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      await _eventRepository.deleteEvent(event.eventId);
      final events = await _eventRepository.getEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onEventRsvpSubmitted(
    EventRsvpSubmitted event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      await _eventRepository.rsvpToEvent(event.eventId, event.status);
      final updatedEvent = await _eventRepository.getEventDetails(event.eventId);
      emit(EventDetailsLoaded(updatedEvent));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onMyEventsRequested(
    MyEventsRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      final events = await _eventRepository.getMyEvents();
      emit(MyEventsLoaded(events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onUpcomingEventsRequested(
    UpcomingEventsRequested event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(EventLoading());
      final events = await _eventRepository.getUpcomingEvents();
      emit(UpcomingEventsLoaded(events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }
}
