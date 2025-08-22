import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

enum AppCardVariant {
  primary,
  secondary,
  outline,
  elevated,
  musicTrack,
  profile,
  event,
  gradient,
  transparent,
}

class AppCard extends StatelessWidget {
  final AppCardVariant variant;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;

  const AppCard({
    super.key,
    this.variant = AppCardVariant.primary,
    this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? EdgeInsets.all(appTheme.spacing.md),
        decoration: _getDecoration(appTheme),
        child: child,
      ),
    );
  }

  BoxDecoration _getDecoration(AppTheme appTheme) {
    switch (variant) {
      case AppCardVariant.primary:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.lightGray.withValues(alpha: 0.2),
          ),
        );
      case AppCardVariant.secondary:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
          ),
        );
      case AppCardVariant.outline:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.lightGray.withValues(alpha: 0.3),
          ),
        );
      case AppCardVariant.elevated:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          boxShadow: [
            BoxShadow(
              color: appTheme.colors.darkTone.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case AppCardVariant.musicTrack:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.lightGray.withValues(alpha: 0.2),
          ),
        );
      case AppCardVariant.profile:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.lightGray.withValues(alpha: 0.2),
          ),
        );
      case AppCardVariant.event:
        return BoxDecoration(
          color: appTheme.colors.darkTone,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
          border: Border.all(
            color: appTheme.colors.lightGray.withValues(alpha: 0.2),
          ),
        );
      case AppCardVariant.gradient:
        return BoxDecoration(
          gradient: appTheme.gradients.primaryGradient,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
        );
      case AppCardVariant.transparent:
        return BoxDecoration(
          color: appTheme.colors.transparent,
          borderRadius: BorderRadius.circular(appTheme.radius.lg),
        );
    }
  }

  BorderRadius _getBorderRadius(AppTheme appTheme) {
    switch (variant) {
      case AppCardVariant.gradient:
        return BorderRadius.circular(appTheme.radius.xl);
      default:
        return BorderRadius.circular(appTheme.radius.lg);
    }
  }
}

// Factory constructors for common card types
class AppCards {
  static AppCard musicTrack({
    Key? key,
    required String title,
    required String artist,
    required String album,
    required String imageUrl,
    required String duration,
    bool isLiked = false,
    VoidCallback? onTap,
    VoidCallback? onLike,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.musicTrack,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$artist • $album',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: onLike,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  static AppCard profile({
    Key? key,
    required String name,
    required String role,
    required String imageUrl,
    bool isOnline = false,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.profile,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  static AppCard event({
    Key? key,
    required String title,
    required String subtitle,
    required String date,
    required String location,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.event,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  static AppCard gradient({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.gradient,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard defaultCard({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.primary,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard white({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.primary,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard transparent({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.transparent,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard glass({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.transparent,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard outlined({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.outline,
      child: child,
      onTap: onTap,
    );
  }

  static AppCard bordered({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.outline,
      child: child,
      onTap: onTap,
    );
  }
}