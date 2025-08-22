import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

/// Reusable Card Component based on Figma Design
class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool isInteractive;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.default_,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.shadows,
    this.onTap,
    this.isInteractive = false,
    this.width,
    this.height,
    this.alignment,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = _getCardDecoration();
    final cardPadding = padding ?? _getDefaultPadding();
    final cardMargin = margin ?? _getDefaultMargin();

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: cardPadding,
      margin: cardMargin,
      decoration: cardDecoration,
      alignment: alignment,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );

    if (onTap != null || isInteractive) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? _getDefaultBorderRadius(),
          ),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }

  BoxDecoration _getCardDecoration() {
    final baseDecoration = BoxDecoration(
      color: backgroundColor ?? _getDefaultBackgroundColor(),
      borderRadius: BorderRadius.circular(
        borderRadius ?? _getDefaultBorderRadius(),
      ),
      border: _getBorder(),
      boxShadow: shadows ?? _getDefaultShadows(),
    );

    // Add gradient for specific variants
    switch (variant) {
      case AppCardVariant.gradient:
        return baseDecoration.copyWith(
          gradient: AppTheme.gradientCard,
        );
      case AppCardVariant.glass:
        return baseDecoration.copyWith(
          color: AppTheme.semiTransparentWhite,
          border: Border.all(
            color: AppTheme.transparentWhite,
            width: 0.5,
          ),
        );
      default:
        return baseDecoration;
    }
  }

  Border? _getBorder() {
    if (borderColor == null && borderWidth == null) {
      return _getDefaultBorder();
    }

    return Border.all(
      color: borderColor ?? _getDefaultBorderColor(),
      width: borderWidth ?? 1.0,
    );
  }

  Border _getDefaultBorder() {
    switch (variant) {
      case AppCardVariant.outlined:
        return Border.all(
          color: AppTheme.transparentWhite,
          width: 0.5,
        );
      case AppCardVariant.bordered:
        return Border.all(
          color: AppTheme.primaryPink,
          width: 1.0,
        );
      default:
        return Border.all(
          color: Colors.transparent,
          width: 0,
        );
    }
  }

  Color _getDefaultBackgroundColor() {
    switch (variant) {
      case AppCardVariant.default_:
        return AppTheme.neutralBlack;
      case AppCardVariant.white:
        return AppTheme.neutralWhite;
      case AppCardVariant.transparent:
        return Colors.transparent;
      case AppCardVariant.glass:
        return AppTheme.semiTransparentWhite;
      case AppCardVariant.gradient:
        return AppTheme.neutralBlack;
      case AppCardVariant.outlined:
        return AppTheme.neutralBlack;
      case AppCardVariant.bordered:
        return AppTheme.neutralBlack;
    }
  }

  Color _getDefaultBorderColor() {
    switch (variant) {
      case AppCardVariant.outlined:
        return AppTheme.transparentWhite;
      case AppCardVariant.bordered:
        return AppTheme.primaryPink;
      default:
        return Colors.transparent;
    }
  }

  double _getDefaultBorderRadius() {
    switch (variant) {
      case AppCardVariant.default_:
        return AppTheme.radiusXL;
      case AppCardVariant.white:
        return AppTheme.radiusXXL;
      case AppCardVariant.transparent:
        return AppTheme.radiusM;
      case AppCardVariant.glass:
        return AppTheme.radiusM;
      case AppCardVariant.gradient:
        return AppTheme.radiusXL;
      case AppCardVariant.outlined:
        return AppTheme.radiusXL;
      case AppCardVariant.bordered:
        return AppTheme.radiusM;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (variant) {
      case AppCardVariant.default_:
        return const EdgeInsets.all(AppTheme.spacingXL);
      case AppCardVariant.white:
        return const EdgeInsets.all(AppTheme.spacingMassive);
      case AppCardVariant.transparent:
        return const EdgeInsets.all(AppTheme.spacingM);
      case AppCardVariant.glass:
        return const EdgeInsets.all(AppTheme.spacingL);
      case AppCardVariant.gradient:
        return const EdgeInsets.all(AppTheme.spacingM);
      case AppCardVariant.outlined:
        return const EdgeInsets.all(AppTheme.spacingXL);
      case AppCardVariant.bordered:
        return const EdgeInsets.all(AppTheme.spacingL);
    }
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    switch (variant) {
      case AppCardVariant.default_:
        return const EdgeInsets.all(AppTheme.spacingM);
      case AppCardVariant.white:
        return const EdgeInsets.all(AppTheme.spacingL);
      case AppCardVariant.transparent:
        return EdgeInsets.zero;
      case AppCardVariant.glass:
        return const EdgeInsets.all(AppTheme.spacingS);
      case AppCardVariant.gradient:
        return const EdgeInsets.all(AppTheme.spacingM);
      case AppCardVariant.outlined:
        return const EdgeInsets.all(AppTheme.spacingM);
      case AppCardVariant.bordered:
        return const EdgeInsets.all(AppTheme.spacingS);
    }
  }

  List<BoxShadow> _getDefaultShadows() {
    switch (variant) {
      case AppCardVariant.white:
        return AppTheme.shadowLarge;
      case AppCardVariant.default_:
      case AppCardVariant.transparent:
      case AppCardVariant.glass:
      case AppCardVariant.gradient:
      case AppCardVariant.outlined:
      case AppCardVariant.bordered:
        return [];
    }
  }
}

/// Card Variants
enum AppCardVariant {
  default_,
  white,
  transparent,
  glass,
  gradient,
  outlined,
  bordered,
}

/// Predefined Card Styles for Common Use Cases
class AppCards {
  /// Music Track Card
  static AppCard musicTrack({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
      margin: margin ?? const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      borderRadius: AppTheme.radiusM,
    );
  }

  /// Profile Card
  static AppCard profile({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.gradient,
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
    );
  }

  /// Event Card
  static AppCard event({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
    );
  }

  /// Search Input Card
  static AppCard searchInput({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.outlined,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXL,
        vertical: AppTheme.spacingXL,
      ),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
    );
  }

  /// Glass Card for Overlays
  static AppCard glass({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.glass,
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingS),
    );
  }

  /// White Card with Shadow
  static AppCard white({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AppCard(
      key: key,
      child: child,
      variant: AppCardVariant.white,
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingMassive),
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingL),
    );
  }
}

/// Specialized Card Components
class AppCardComponents {
  /// Music Track Card with Image, Title, and Artist
  static Widget musicTrackCard({
    Key? key,
    required String imageUrl,
    required String title,
    required String artist,
    String? subtitle,
    VoidCallback? onTap,
    bool isPlaying = false,
  }) {
    return AppCards.musicTrack(
      key: key,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.neutralWhite,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: AppTheme.spacingS),
                  Text(
                    subtitle,
                    style: AppTheme.overline.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: AppTheme.spacingS),
                Text(
                  artist,
                  style: AppTheme.overline.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isPlaying)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.primaryPink,
                borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppTheme.neutralWhite,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  /// Profile Card with Image, Name, and Details
  static Widget profileCard({
    Key? key,
    required String imageUrl,
    required String name,
    required String age,
    String? location,
    String? description,
    VoidCallback? onTap,
  }) {
    return AppCards.profile(
      key: key,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacingS),
          Text(
            'Age: $age',
            style: AppTheme.bodyH10.copyWith(
              color: AppTheme.neutralWhite,
            ),
          ),
          if (location != null) ...[
            SizedBox(height: AppTheme.spacingS),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.neutralLightGray,
                  size: 16,
                ),
                SizedBox(width: AppTheme.spacingS),
                Text(
                  location,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.neutralLightGray,
                  ),
                ),
              ],
            ),
          ],
          if (description != null) ...[
            SizedBox(height: AppTheme.spacingM),
            Text(
              description,
              style: AppTheme.caption.copyWith(
                color: AppTheme.neutralLightGray,
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  /// Event Card with Title, Date, and Actions
  static Widget eventCard({
    Key? key,
    required String title,
    required String date,
    required String location,
    String? description,
    required List<String> attendees,
    VoidCallback? onTap,
    VoidCallback? onGoing,
    VoidCallback? onInterested,
  }) {
    return AppCards.event(
      key: key,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.titleSmall,
          ),
          SizedBox(height: AppTheme.spacingS),
          Text(
            date,
            style: AppTheme.caption.copyWith(
              color: AppTheme.neutralLightGray,
            ),
          ),
          SizedBox(height: AppTheme.spacingS),
          Text(
            location,
            style: AppTheme.caption.copyWith(
              color: AppTheme.neutralLightGray,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: AppTheme.spacingM),
            Text(
              description,
              style: AppTheme.caption.copyWith(
                color: AppTheme.neutralWhite,
                height: 1.27,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: AppButtons.primary(
                  text: 'I\'m going',
                  onPressed: onGoing,
                  size: AppButtonSize.small,
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: AppButtons.ghost(
                  text: 'I\'m interested',
                  onPressed: onInterested,
                  size: AppButtonSize.small,
                ),
              ),
            ],
          ),
          if (attendees.isNotEmpty) ...[
            SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                ...attendees.take(5).map((attendee) => Container(
                  margin: EdgeInsets.only(right: AppTheme.spacingS),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(attendee),
                  ),
                )),
                if (attendees.length > 5)
                  Container(
                    margin: EdgeInsets.only(right: AppTheme.spacingS),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryPink,
                      child: Text(
                        '+${attendees.length - 5}',
                        style: AppTheme.overline.copyWith(
                          color: AppTheme.neutralWhite,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}