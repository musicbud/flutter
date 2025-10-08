import 'package:equatable/equatable.dart';

class CommonItem extends Equatable {
  final String name;
  final String? artist;
  final String? imageUrl;

  const CommonItem({required this.name, this.artist, this.imageUrl});

  factory CommonItem.fromJson(Map<String, dynamic> json) {
    return CommonItem(
      name: json['name'] ?? json['title'] ?? '',
      artist: json['artist'] ?? json['artists']?.first ?? '',
      imageUrl: json['image_url'] ?? json['album']?['images']?.first?['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (artist != null) 'artist': artist,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  CommonItem copyWith({
    String? name,
    String? artist,
    String? imageUrl,
  }) {
    return CommonItem(
      name: name ?? this.name,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [name, artist, imageUrl];
}
