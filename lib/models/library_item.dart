import 'package:equatable/equatable.dart';
import 'content_service.dart';

class LibraryItem extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String type; // 'playlist', 'song', 'album'
  final DateTime addedAt;
  final DateTime? lastPlayedAt;
  final bool isDownloaded;
  final bool isLiked;
  final ContentService? service; // spotify, ytmusic, etc.
  final Map<String, dynamic>? metadata;

  const LibraryItem({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.type,
    required this.addedAt,
    this.lastPlayedAt,
    this.isDownloaded = false,
    this.isLiked = false,
    this.service,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        type,
        addedAt,
        lastPlayedAt,
        isDownloaded,
        isLiked,
        service,
        metadata,
      ];

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : null,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      isLiked: json['isLiked'] as bool? ?? false,
      service: json['service'] != null
          ? ContentService.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'addedAt': addedAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'isDownloaded': isDownloaded,
      'isLiked': isLiked,
      'service': service?.toJson(),
      'metadata': metadata,
    };
  }
}
