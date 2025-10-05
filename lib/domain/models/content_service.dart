class ContentService {
  final String id;
  final String name;
  final String iconUrl;
  final String status;
  final bool isConnected;

  ContentService({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.status,
    required this.isConnected,
  });

  factory ContentService.fromJson(Map<String, dynamic> json) {
    return ContentService(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String,
      status: json['status'] as String,
      isConnected: json['is_connected'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'status': status,
      'is_connected': isConnected,
    };
  }

  ContentService copyWith({
    String? id,
    String? name,
    String? iconUrl,
    String? status,
    bool? isConnected,
  }) {
    return ContentService(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
