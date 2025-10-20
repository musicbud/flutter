class Activity {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime timestamp;

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
