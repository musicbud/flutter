/// Represents a Spotify playback device
class SpotifyDevice {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final int volumePercent;

  const SpotifyDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = false,
    this.volumePercent = 50,
  });

  factory SpotifyDevice.fromJson(Map<String, dynamic> json) {
    return SpotifyDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool? ?? false,
      volumePercent: json['volume_percent'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_active': isActive,
      'volume_percent': volumePercent,
    };
  }

  SpotifyDevice copyWith({
    String? id,
    String? name,
    String? type,
    bool? isActive,
    int? volumePercent,
  }) {
    return SpotifyDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      volumePercent: volumePercent ?? this.volumePercent,
    );
  }
}
