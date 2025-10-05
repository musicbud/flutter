class WatchParty {
  final String id;
  final String hostId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final String status; // 'scheduled', 'live', 'ended'
  final List<String> participantIds;
  final Map<String, dynamic> settings;
  final String? currentTrackId;
  final DateTime createdAt;

  const WatchParty({
    required this.id,
    required this.hostId,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    required this.status,
    this.participantIds = const [],
    this.settings = const {},
    this.currentTrackId,
    required this.createdAt,
  });

  factory WatchParty.fromJson(Map<String, dynamic> json) {
    return WatchParty(
      id: json['id'] as String,
      hostId: json['hostId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      status: json['status'] as String,
      participantIds: (json['participantIds'] as List<dynamic>?)?.cast<String>() ?? [],
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      currentTrackId: json['currentTrackId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostId': hostId,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status,
      'participantIds': participantIds,
      'settings': settings,
      'currentTrackId': currentTrackId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';
  bool get isEnded => status == 'ended';

  WatchParty copyWith({
    String? id,
    String? hostId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    List<String>? participantIds,
    Map<String, dynamic>? settings,
    String? currentTrackId,
    DateTime? createdAt,
  }) {
    return WatchParty(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      participantIds: participantIds ?? this.participantIds,
      settings: settings ?? this.settings,
      currentTrackId: currentTrackId ?? this.currentTrackId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
