import 'package:flutter/material.dart';

class FeaturedArtist {
  final String id;
  final String name;
  final String genre;
  final String? imageUrl;
  final Color accentColor;

  FeaturedArtist({
    required this.id,
    required this.name,
    required this.genre,
    this.imageUrl,
    required this.accentColor,
  });

  factory FeaturedArtist.fromJson(Map<String, dynamic> json) {
    return FeaturedArtist(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      name: json['name'] as String,
      genre: json['genre'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String?,
      accentColor: _parseColor(json['accent_color'] as String? ?? '#FF2196F3'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'image_url': imageUrl,
      'accent_color': '#${(accentColor.value & 0x00FFFFFF).toRadixString(16).padLeft(6, '0')}',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'genre': genre,
      'imageUrl': imageUrl,
      'accentColor': accentColor,
    };
  }

  static Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Color(int.parse(colorString, radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue; // Default color
    }
  }
}