import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class EventsRequested extends EventEvent {
  final int page;

  const EventsRequested({this.page = 1});

  @override
  List<Object> get props => [page];
}

class EventDetailsRequested extends EventEvent {
  final String eventId;

  const EventDetailsRequested(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class EventCreated extends EventEvent {
  final Map<String, dynamic> eventData;

  const EventCreated(this.eventData);

  @override
  List<Object> get props => [eventData];
}

class EventUpdated extends EventEvent {
  final String eventId;
  final Map<String, dynamic> eventData;

  const EventUpdated({
    required this.eventId,
    required this.eventData,
  });

  @override
  List<Object> get props => [eventId, eventData];
}

class EventDeleted extends EventEvent {
  final String eventId;

  const EventDeleted(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class EventRsvpSubmitted extends EventEvent {
  final String eventId;
  final String status;

  const EventRsvpSubmitted({
    required this.eventId,
    required this.status,
  });

  @override
  List<Object> get props => [eventId, status];
}

class MyEventsRequested extends EventEvent {}

class UpcomingEventsRequested extends EventEvent {}
