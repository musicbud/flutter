import 'package:equatable/equatable.dart';
import '../../domain/models/event/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  final bool hasReachedEnd;
  final int currentPage;

  const EventsLoaded({
    required this.events,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [events, hasReachedEnd, currentPage];

  EventsLoaded copyWith({
    List<Event>? events,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class EventDetailsLoaded extends EventState {
  final Event event;

  const EventDetailsLoaded(this.event);

  @override
  List<Object> get props => [event];
}

class MyEventsLoaded extends EventState {
  final List<Event> events;

  const MyEventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class UpcomingEventsLoaded extends EventState {
  final List<Event> events;

  const UpcomingEventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventFailure extends EventState {
  final String error;

  const EventFailure(this.error);

  @override
  List<Object> get props => [error];
}
