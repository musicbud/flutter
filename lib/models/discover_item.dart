class DiscoverItem {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String? imageUrl;
  final Map<String, dynamic> metadata;
  final String category;
  
  const DiscoverItem({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.imageUrl,
    this.metadata = const {},
    required this.category,
  });
  
  /// Getter for subtitle (maps to description for compatibility)
  String? get subtitle => description;

  factory DiscoverItem.fromJson(Map<String, dynamic> json) {
    return DiscoverItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
      'metadata': metadata,
      'category': category,
    };
  }

  DiscoverItem copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    String? category,
  }) {
    return DiscoverItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      category: category ?? this.category,
    );
  }
}
