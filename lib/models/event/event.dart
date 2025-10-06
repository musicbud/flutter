import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String imageUrl;
  final String organizer;
  final List<String> attendees;
  final int maxCapacity;
  final bool isPrivate;
  final String status; // 'upcoming', 'ongoing', 'completed', 'cancelled'
  final Map<String, int> rsvpCounts; // 'going', 'maybe', 'notGoing'
  final String userRsvpStatus; // 'going', 'maybe', 'notGoing', 'none'

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.imageUrl,
    required this.organizer,
    required this.attendees,
    required this.maxCapacity,
    required this.isPrivate,
    required this.status,
    required this.rsvpCounts,
    required this.userRsvpStatus,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      imageUrl: json['image_url'] as String,
      organizer: json['organizer'] as String,
      attendees: List<String>.from(json['attendees'] as List),
      maxCapacity: json['max_capacity'] as int,
      isPrivate: json['is_private'] as bool,
      status: json['status'] as String,
      rsvpCounts: Map<String, int>.from(json['rsvp_counts'] as Map),
      userRsvpStatus: json['user_rsvp_status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'image_url': imageUrl,
      'organizer': organizer,
      'attendees': attendees,
      'max_capacity': maxCapacity,
      'is_private': isPrivate,
      'status': status,
      'rsvp_counts': rsvpCounts,
      'user_rsvp_status': userRsvpStatus,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? imageUrl,
    String? organizer,
    List<String>? attendees,
    int? maxCapacity,
    bool? isPrivate,
    String? status,
    Map<String, int>? rsvpCounts,
    String? userRsvpStatus,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      organizer: organizer ?? this.organizer,
      attendees: attendees ?? this.attendees,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      isPrivate: isPrivate ?? this.isPrivate,
      status: status ?? this.status,
      rsvpCounts: rsvpCounts ?? this.rsvpCounts,
      userRsvpStatus: userRsvpStatus ?? this.userRsvpStatus,
    );
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        location,
        imageUrl,
        organizer,
        attendees,
        maxCapacity,
        isPrivate,
        status,
        rsvpCounts,
        userRsvpStatus,
      ];
}
