import 'package:flutter/material.dart';

class SettingsOptionModel {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsOptionModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.trailing,
  });
}
