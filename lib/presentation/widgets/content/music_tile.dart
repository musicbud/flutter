import 'package:flutter/material.dart';

/// A reusable music tile widget for displaying track information
class MusicTile extends StatelessWidget {
  final String title;
  final String artist;
  final String? imageUrl;
  final String? fallbackImage;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final bool isBookmarked;
  final double imageSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const MusicTile({
    Key? key,
    required this.title,
    required this.artist,
    this.imageUrl,
    this.fallbackImage = 'assets/cover.jpg',
    this.onTap,
    this.onBookmark,
    this.isBookmarked = false,
    this.imageSize = 50,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: _buildImage(),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          artist,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: onBookmark != null
            ? IconButton(
                onPressed: onBookmark,
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? const Color(0xFFFF6B8F) : Colors.white,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      try {
        return Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              fallbackImage!,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        return Image.asset(
          fallbackImage!,
          fit: BoxFit.cover,
        );
      }
    }
    return Image.asset(
      fallbackImage!,
      fit: BoxFit.cover,
    );
  }
}