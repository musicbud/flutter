import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Configuration class for navigation components
class NavigationConfig extends Equatable {
  const NavigationConfig({
    this.margin,
    this.borderRadius,
    this.selectedColor,
    this.unselectedColor,
    this.elevation,
  });

  /// Margin for navigation components
  final EdgeInsetsGeometry? margin;

  /// Border radius for navigation components
  final BorderRadius? borderRadius;

  /// Color for selected navigation items
  final Color? selectedColor;

  /// Color for unselected navigation items
  final Color? unselectedColor;

  /// Elevation for navigation components
  final double? elevation;

  /// Creates a copy of this NavigationConfig with the given fields replaced
  NavigationConfig copyWith({
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? selectedColor,
    Color? unselectedColor,
    double? elevation,
  }) {
    return NavigationConfig(
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  List<Object?> get props => [
    margin,
    borderRadius,
    selectedColor,
    unselectedColor,
    elevation,
  ];
}