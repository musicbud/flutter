import 'package:equatable/equatable.dart';

/// A model class representing an image with different sizes
class Image extends Equatable {
  final String url;
  final int? width;
  final int? height;
  final String? size; // small, medium, large, etc.

  const Image({
    required this.url,
    this.width,
    this.height,
    this.size,
  });

  /// Creates an [Image] from a JSON map
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      size: json['size'] as String?,
    );
  }

  /// Converts this [Image] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'size': size,
    };
  }

  @override
  List<Object?> get props => [url, width, height, size];
}
